//
//  ImagemAnimationController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 19/09/15.
//  Copyright © 2015 Gian Nucci. All rights reserved.
//

import UIKit

class ImagemAnimationController: NSObject , UIViewControllerAnimatedTransitioning{

    
    var reverseAnimation = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if self.reverseAnimation {
            animateOut(transitionContext)
        }
        else {
            animateIn(transitionContext)
        }
    }
    
    func animateIn(transitionContext: UIViewControllerContextTransitioning)
    {
        
        let navigationController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as! UINavigationController
        let tableViewController = navigationController.topViewController as! TransitionsTableViewController
        let imageViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let containerView: UIView = transitionContext.containerView()!
        let imageView = imageViewController.view
        let tableView = tableViewController.view
        
        let duration = self.transitionDuration(transitionContext)
        
        let cell = tableViewController.tableView.cellForRowAtIndexPath(NSIndexPath (forRow: 3, inSection: 0));
        
        let newImageView = UIImageView(image: cell?.imageView?.image)
        newImageView.frame = (cell?.imageView?.convertRect((cell?.imageView?.bounds)!, toView: navigationController.view))!
        
        // since the detail view was just built, it needs to be added to the view heirarchy
        containerView.addSubview(newImageView)
        containerView.addSubview(imageView)
        
        imageView.frame = containerView.bounds
        
        imageView.alpha = 0
       // detailView.transform = CGAffineTransformMakeScale(Zoom.maximum, Zoom.maximum)
        
        UIView.animateWithDuration(duration, delay:0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            imageView.alpha = 1
            newImageView.transform = CGAffineTransformIdentity
            newImageView.frame = containerView.bounds
            
            }) { (animationCompleted: Bool) -> Void in
                
                // return the table view back to its original state
                tableView.transform = CGAffineTransformIdentity
                
                // when the animation is done we need to complete the transition
                transitionContext.completeTransition(animationCompleted)
        }
    }
    
    func animateOut(transitionContext: UIViewControllerContextTransitioning)
    {
        let navigationController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as! UINavigationController
        let tableViewController = navigationController.topViewController as! TransitionsTableViewController
        let imageViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let containerView: UIView = transitionContext.containerView()!
        let imageView = imageViewController.view
        let tableView = tableViewController.view
        
        let cell = tableViewController.tableView.cellForRowAtIndexPath(NSIndexPath (forRow: 3, inSection: 0));
        
        let newImageView = UIImageView(image: cell?.imageView?.image)
        newImageView.frame = (cell?.imageView?.convertRect((cell?.imageView?.bounds)!, toView: navigationController.view))!
        
        // since the detail view was just built, it needs to be added to the view heirarchy
        containerView.addSubview(imageView)
        containerView.addSubview(newImageView)
        
        
        newImageView.frame = transitionContext.finalFrameForViewController(tableViewController)
        newImageView.alpha = 0
        //tableView.transform = CGAffineTransformMakeScale(Zoom.minimum, Zoom.minimum)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            tableView.alpha = 1
            tableView.transform = CGAffineTransformIdentity
            
            imageView.alpha = 0
            //detailView.transform = CGAffineTransformMakeScale(Zoom.maximum, Zoom.maximum)
            
            }) { (animationCompleted: Bool) -> Void in
                
                imageView.alpha = 1
                imageView.transform = CGAffineTransformIdentity
                
                transitionContext.completeTransition(animationCompleted)
        }
    }
    

    
    
}
