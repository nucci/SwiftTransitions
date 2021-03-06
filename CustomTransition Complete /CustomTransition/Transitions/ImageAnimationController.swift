//
//  ImageAnimationController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 18/09/15.
//  Copyright © 2015 Gian Nucci. All rights reserved.
//

import UIKit

class ImageAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var reverseAnimation = false
    
    lazy var animationImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRectZero)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = true
        return imageView
        }()
    
    
    //MARK: - <UIViewControllerAnimatedTransitioning>
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        if self.reverseAnimation {
            return 0.4
        }
        return 0.6
    }
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        if self.reverseAnimation {
            animateOut(transitionContext)
        }
        else {
            animateIn(transitionContext)
        }
    }
    
    func animateIn(transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = self.transitionDuration(transitionContext)
        
        // pull out values we need from the context
        let tableNavigationController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! UINavigationController
        let tableViewController = tableNavigationController.topViewController as! TransitionsTableViewController
        let imageViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ImageViewController
        let containerView = transitionContext.containerView()
        let destinationViewFrame = transitionContext.finalFrameForViewController(imageViewController)
        
        // size the destination view
        imageViewController.view.frame = destinationViewFrame
        containerView!.addSubview(imageViewController.view)
        containerView!.layoutIfNeeded()
        
        // hide the destination view until the image animates into place
        imageViewController.view.hidden = true
        
        // get a reference to the cell's image view
        let indexPath = NSIndexPath(forRow: 3, inSection: 0)
        let imageCell = tableViewController.tableView.cellForRowAtIndexPath(indexPath)!
        let cellImageView = imageCell.contentView.subviews.last as! UIImageView
        
        // configure the animation image view with the cell's image and frame
        self.animationImageView.image = cellImageView.image
        self.animationImageView.frame = cellImageView.convertRect(cellImageView.bounds, toView: containerView)
        containerView!.addSubview(self.animationImageView)
        
        // fade in the animation image
        self.animationImageView.alpha = 0
        UIView.animateWithDuration(duration * 0.25, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            
            self.animationImageView.alpha = 1
            
            }, completion: nil)
        
        // size the image to match the destination view frame
        let destinationImageFrame = imageViewController.imageView.convertRect(imageViewController.imageView.bounds, toView: containerView)
        
        UIView.animateWithDuration(duration * 0.75, delay: duration * 0.25, options: .CurveEaseInOut, animations: { () -> Void in
            
            // resize the image to match the size of the destination view
            self.animationImageView.frame = destinationImageFrame
            
            }, completion: { (finished: Bool) -> Void in
                
                // remove the transition image view
                self.animationImageView.removeFromSuperview()
                
                // show the destination view
                imageViewController.view.hidden = false
                
                // finish the transition
                transitionContext.completeTransition(true)
        })
    }
    
    func animateOut(transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = self.transitionDuration(transitionContext)
        
        // pull out values we need from the context
        let tableNavigationController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! UINavigationController
        let tableViewController = tableNavigationController.topViewController as! TransitionsTableViewController
        let imageViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ImageViewController
        let containerView = transitionContext.containerView()
        
        // get a reference to the cell's image view
        let indexPath = NSIndexPath(forRow: 3, inSection: 0)
        let imageCell = tableViewController.tableView.cellForRowAtIndexPath(indexPath)!
        let cellImageView = imageCell.contentView.subviews.last as! UIImageView
        
        // configure the animation image view with the cell's image and frame
        self.animationImageView.image = cellImageView.image
        self.animationImageView.frame = imageViewController.imageView.convertRect(imageViewController.imageView.bounds, toView: containerView)
        
        // remove the view we're transitioning from
        imageViewController.view.removeFromSuperview()
        
        // place the animation image on top
        containerView!.addSubview(self.animationImageView)
        
        // resize the animation image to match the cell image view's frame
        let destinationImageFrame = cellImageView.convertRect(cellImageView.bounds, toView: containerView)
        
        UIView.animateWithDuration(duration * 0.75, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.animationImageView.frame = destinationImageFrame
            
            }, completion: nil)
        
        // fade out the animation image and end the transition
        UIView.animateWithDuration(duration * 0.25, delay: duration * 0.75, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.animationImageView.alpha = 0
            
            }, completion: { (finished: Bool) -> Void in
                
                self.animationImageView.removeFromSuperview()
                
                transitionContext.completeTransition(true)
        })
    }
}
