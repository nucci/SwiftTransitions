//
//  CubeViewController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 17/09/15.
//  Copyright © 2015 Gian Nucci. All rights reserved.
//

import UIKit

class CubeAnimationController: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIGestureRecognizerDelegate {
    // constants
    let Rotation = CGFloat(Double.pi/2)
    let Projection: CGFloat = 1 / -600
    let Duration: CFTimeInterval = 0.65
    
    // animation properties
    var reverseAnimation = false
    var transitionContext: UIViewControllerContextTransitioning?
    
    // interactive transition properties
    var interactive = false
    var startTouchPoint: CGPoint?
    var animationTimer: Timer?
    
    //MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return Duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        self.transitionContext = transitionContext
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let (containerView, sourceView, destinationView) = self.transitionContextViews(transitionContext)
        
        // since the detail view was just built, it needs to be added to the view heirarchy
        containerView.addSubview(destinationView)
        destinationView.frame = transitionContext.finalFrame(for: toViewController)
        
        // setup the 3D scene by setting perspective in the container and configurin the view positions
        self.setupScene(containerView, sourceView: sourceView, destinationView: destinationView)
        
        // add animations
        var sourceViewAnimation: CABasicAnimation
        var destinationViewAnimation: CABasicAnimation
        
        if self.reverseAnimation {
            sourceViewAnimation = self.createCubeTransformAnimation(Rotation, view: sourceView, presenting: false)
            destinationViewAnimation = self.createCubeTransformAnimation(-Rotation, view: destinationView, presenting: true)
        }
        else {
            sourceViewAnimation = self.createCubeTransformAnimation(-Rotation, view: sourceView, presenting: false)
            destinationViewAnimation = self.createCubeTransformAnimation(Rotation, view: destinationView, presenting: true)
        }
        
        destinationViewAnimation.completionBlock = { (success: Bool) -> Void in
            // whenever this animation completes we need to update the context and determine
            // if the transition successfully completed.
            transitionContext.completeTransition(success && !transitionContext.transitionWasCancelled)
        }
        
        sourceView.layer.add(sourceViewAnimation, forKey: sourceViewAnimation.keyPath)
        destinationView.layer.add(destinationViewAnimation, forKey: destinationViewAnimation.keyPath)
    }
    
    
    func animationEnded(_ transitionCompleted: Bool)
    {
        self.transitionContext = nil
        self.interactive = false
        self.interactivePopGestureRecognizer = nil
    }
    
    
    //MARK: - UIViewControllerInteractiveTransitioning
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning)
    {
        super.startInteractiveTransition(transitionContext)
        
        // the gesture has already began once this method fires, so we cannot rely on the Begin state for the
        // gesture to record the first touch point. instead, capture it here when the interactive transition begins.
        self.startTouchPoint = self.interactivePopGestureRecognizer?.location(in: transitionContext.containerView)
    }
    
    
    override func cancel() {
        super.cancel()
        
        // here we need to reset the layer properties for our views to their original values.
        // by doing this, we fix an animation flicker that shows the views in their final state
        let transitionContext = self.transitionContext!
        let (_, sourceView, destinationView) = self.transitionContextViews(transitionContext)
        
        let sourceViewAnimation = sourceView.layer.animation(forKey: "transform") as! CABasicAnimation
        let destinationViewAnimation = destinationView.layer.animation(forKey: "transform") as! CABasicAnimation
        
        sourceView.layer.transform = (sourceViewAnimation.fromValue as! NSValue).caTransform3DValue
        destinationView.layer.transform = (destinationViewAnimation.fromValue as! NSValue).caTransform3DValue
    }
    
    
    //MARK: - Gesture Recognizer
    // this gesture is owned by the UINavigationController and is used to update the transition
    // animation as the user pans across the screen. we become the delegate and respond to its
    // actions in order to use the gesture for the transition.
    var interactivePopGestureRecognizer: UIGestureRecognizer? {
        didSet {
            self.interactivePopGestureRecognizer?.delegate = self
            self.interactivePopGestureRecognizer?.addTarget(self, action: #selector(CubeAnimationController.screenEdgeDidPan(_:)))
        }
    }
    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        // prevent the gesture from starting when we're in the middle of animating
        // to a new target value.
        if self.animationTimer != nil {
            return false
        }
        
        // this flag helps us determine when to tell the navigation controller when to use
        // this object as the interactive animation controller. we always want to handle
        // the animation as an interactive one when the pop gesture begins motion
        self.interactive = true
        
        return true
    }
    
    
    @objc func screenEdgeDidPan(_ gesture: UIGestureRecognizer)
    {
        if let transitionContext = self.transitionContext {
            
            let containerView = transitionContext.containerView
            let touchPoint = gesture.location(in: containerView)
            let progress = touchPoint.x / containerView.frame.width
            
            switch (gesture.state) {
                
            case .changed:
                self.update(progress)
                
                if progress >= 0.995 {
                    self.finish()
                }
                break
                
            case .ended, .cancelled:
                
                // when a gesture ends, we need to determine how far through the user
                // was through the animation, and then advance our animation to either a
                // fully transitioned or cancelled state. we control this with a custom
                // timer that updates the transition context until we reach the target progress
                if progress > 0.5 {
                    self.animateToPercentComplete(1)
                }
                else {
                    self.animateToPercentComplete(0)
                }
                break
                
            default:
                break
            }
        }
    }
    
    
    //MARK: - Animation Timer
    
    func animateToPercentComplete(_ percent: CGFloat)
    {
        if self.animationTimer == nil {
            self.animationTimer = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(CubeAnimationController.adjustPercentComplete(_:)), userInfo: Float(percent), repeats: true)
        }
    }
    
    
    func stopAnimationTimer()
    {
        self.animationTimer?.invalidate()
        self.animationTimer = nil
    }
    
    
    @objc func adjustPercentComplete(_ timer: Timer)
    {
        let targetPercent = timer.userInfo as! CGFloat
        let delta = (targetPercent - self.percentComplete) * 0.1
        
        self.update(self.percentComplete + delta)
        
        if abs(delta) < 0.0001 {
            
            self.stopAnimationTimer()
            
            if targetPercent == 1 {
                self.finish()
            }
            else {
                self.cancel()
            }
        }
    }

    
    //MARK: - Helpers
    
    // helper method to retrieve the contents of the transition context
    func transitionContextViews(_ transitionContext: UIViewControllerContextTransitioning) -> (containerView: UIView, sourceView: UIView, destinationView: UIView)
    {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        return (transitionContext.containerView, fromViewController.view, toViewController.view)
    }
    
    func setupScene(_ containerView: UIView, sourceView: UIView, destinationView: UIView)
    {
        // setup the 3D scene by setting perspective in the container and configuring the view positions
        // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreAnimation_guide/AdvancedAnimationTricks/AdvancedAnimationTricks.html#//apple_ref/doc/uid/TP40004514-CH8-SW13
        var containerTransform = CATransform3DIdentity
        containerTransform.m34 = Projection
        containerView.layer.sublayerTransform = containerTransform
        
        // calculate the z-distance as a ratio of the width of the container.
        // this keeps the edges of the cube sides aligned when rotating with different screen sizes
        let z = -(0.5 * self.transitionContext!.containerView.frame.width)
        sourceView.layer.zPosition = z
        sourceView.layer.anchorPointZ = z
        destinationView.layer.zPosition = z
        destinationView.layer.anchorPointZ = z
    }
    
    func createCubeTransformAnimation(_ rotation: CGFloat, view: UIView, presenting: Bool) -> CABasicAnimation
    {
        let viewFromTransform = CATransform3DMakeRotation(rotation, 0, 1, 0)
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        
        if presenting {
            transformAnimation.fromValue = NSValue(caTransform3D: viewFromTransform)
            transformAnimation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
        }
        else {
            transformAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
            transformAnimation.toValue = NSValue(caTransform3D: viewFromTransform)
        }
        
        transformAnimation.duration = Duration
        
        //TODO: use a linear curve when interactive so the motion matches the movement of the touch
        transformAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        
        // set the view's layer to the final value. fixes flickering at the end of the animation
        view.layer.transform = (transformAnimation.toValue as! NSValue).caTransform3DValue
        
        return transformAnimation
    }

}
