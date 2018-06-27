//
//  PopupAnimationController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 17/09/15.
//  Copyright © 2015 Gian Nucci. All rights reserved.
//

import UIKit

class PopupAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var reverseAnimation: Bool = false
    
    lazy var dimmerView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return view
    }()
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 1.25
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        if self.reverseAnimation {
            animateOut(transitionContext)
        }
        else {
            animateIn(transitionContext)
        }
    }
    
    func animateIn(_ transitionContext: UIViewControllerContextTransitioning)
    {
        let duration = self.transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        let popupViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let popupView = popupViewController.view
        let popupSize = popupViewController.preferredContentSize
        
        let scaleValues: [NSValue] = [
            NSValue(caTransform3D: CATransform3DScale(CATransform3DMakeTranslation(0, -500, 0), 0, 0, 1)),
            NSValue(caTransform3D: CATransform3DTranslate(CATransform3DMakeScale(1.2, 0.75, 1), 0, 200, 0)),
            NSValue(caTransform3D: CATransform3DTranslate(CATransform3DMakeScale(0.8, 1.3, 1), 0, -55, 0)),
            NSValue(caTransform3D: CATransform3DIdentity)
        ]
        
        let transformAnimation = CAKeyframeAnimation(keyPath: "transform")
        transformAnimation.duration = duration * 0.7
        transformAnimation.values = scaleValues
        transformAnimation.keyTimes = [0, 0.3, 0.6, 1]
        transformAnimation.fillMode = kCAFillModeBoth
        transformAnimation.timingFunctions = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
        ]
        transformAnimation.completionBlock = { (finished: Bool) -> Void in
            
            transitionContext.completeTransition(finished)
        }
        
        let dimmerFadeAnimation = CABasicAnimation(keyPath: "opacity")
        dimmerFadeAnimation.fromValue = 0
        dimmerFadeAnimation.toValue = 1
        dimmerFadeAnimation.duration = duration * 0.3
        dimmerFadeAnimation.fillMode = kCAFillModeBoth
        dimmerFadeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        dimmerFadeAnimation.completionBlock = { (finished: Bool) -> Void in
            if finished {
                containerView.addSubview(popupView!)
                
                // set the layer to its final value before adding the animation
                popupView?.layer.transform = CATransform3DIdentity
                
                popupView?.layer.add(transformAnimation, forKey: "transformAnimation")
            }
            else {
                transitionContext.completeTransition(finished)
            }
        }
        
        popupView?.frame = CGRect(origin: CGPoint.zero, size: popupSize)
        popupView?.center = containerView.center
        
        // display the dimmer
        containerView.addSubview(self.dimmerView)
        self.dimmerView.frame = containerView.bounds
        
        
        // set the layer to its final value before adding the animation
        self.dimmerView.layer.opacity = 1
        self.dimmerView.layer.add(dimmerFadeAnimation, forKey: "dimmerFadeAnimation")
    }
    
    
    func animateOut(_ transitionContext: UIViewControllerContextTransitioning)
    {
        let duration = self.transitionDuration(using: transitionContext)
        let popupViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let popupView = popupViewController.view
        
        let dimmerFadeAnimation = CABasicAnimation(keyPath: "opacity")
        dimmerFadeAnimation.fromValue = 1
        dimmerFadeAnimation.toValue = 0
        dimmerFadeAnimation.duration = duration * 0.4
        dimmerFadeAnimation.fillMode = kCAFillModeBoth
        dimmerFadeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        dimmerFadeAnimation.completionBlock = { (finished: Bool) -> Void in
            transitionContext.completeTransition(finished)
        }
        
        let scaleValues: [NSValue] = [
            NSValue(caTransform3D: CATransform3DIdentity),
            NSValue(caTransform3D: CATransform3DTranslate(CATransform3DMakeScale(1.2, 0.9, 1), 0, -100, 0)),
            NSValue(caTransform3D: CATransform3DScale(CATransform3DMakeTranslation(0, 500, 0), 0, 0.5, 1)),
        ]
        
        let transformAnimation = CAKeyframeAnimation(keyPath: "transform")
        transformAnimation.duration = duration * 0.6
        transformAnimation.values = scaleValues
        transformAnimation.keyTimes = [0, 0.7, 1]
        transformAnimation.fillMode = kCAFillModeBoth
        transformAnimation.timingFunctions = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
        ]
        transformAnimation.completionBlock = { (finished: Bool) -> Void in
            if finished {
                self.dimmerView.layer.opacity = 0
                self.dimmerView.layer.add(dimmerFadeAnimation, forKey: "fadeAnimation")
            }
            else {
                transitionContext.completeTransition(finished)
            }
        }
        
        // its important to set the layer to its final values when adding the animation, without this,
        // you can get a flicker showing the original values when the animation ends.
        popupView?.layer.transform = scaleValues.last!.caTransform3DValue
        popupView?.layer.add(transformAnimation, forKey: "transformAnimation")
    }

}
