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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.reverseAnimation {
            animateOut(transitionContext)
        }
        else {
            animateIn(transitionContext)
        }
    }
    
    func animateIn(_ transitionContext: UIViewControllerContextTransitioning)
    {
        
        let navigationController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)! as! UINavigationController
        let tableViewController = navigationController.topViewController as! TransitionsTableViewController
        let imageViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let containerView: UIView = transitionContext.containerView
        let imageView = imageViewController.view
        let tableView = tableViewController.view
        
        let duration = self.transitionDuration(using: transitionContext)
        
        let cell = tableViewController.tableView.cellForRow(at: IndexPath (row: 3, section: 0));
        
        let newImageView = UIImageView(image: cell?.imageView?.image)
        newImageView.frame = (cell?.imageView?.convert((cell?.imageView?.bounds)!, to: navigationController.view))!
        
        // since the detail view was just built, it needs to be added to the view heirarchy
        containerView.addSubview(newImageView)
        containerView.addSubview(imageView!)
        
        imageView?.frame = containerView.bounds
        
        imageView?.alpha = 0
       // detailView.transform = CGAffineTransformMakeScale(Zoom.maximum, Zoom.maximum)
        
        UIView.animate(withDuration: duration, delay:0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            imageView?.alpha = 1
            newImageView.transform = CGAffineTransform.identity
            newImageView.frame = containerView.bounds
            
            }) { (animationCompleted: Bool) -> Void in
                
                // return the table view back to its original state
                tableView?.transform = CGAffineTransform.identity
                
                // when the animation is done we need to complete the transition
                transitionContext.completeTransition(animationCompleted)
        }
    }
    
    func animateOut(_ transitionContext: UIViewControllerContextTransitioning)
    {
        let navigationController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)! as! UINavigationController
        let tableViewController = navigationController.topViewController as! TransitionsTableViewController
        let imageViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        let containerView: UIView = transitionContext.containerView
        let imageView = imageViewController.view
        let tableView = tableViewController.view
        
        let cell = tableViewController.tableView.cellForRow(at: IndexPath (row: 3, section: 0));
        
        let newImageView = UIImageView(image: cell?.imageView?.image)
        newImageView.frame = (cell?.imageView?.convert((cell?.imageView?.bounds)!, to: navigationController.view))!
        
        // since the detail view was just built, it needs to be added to the view heirarchy
        containerView.addSubview(imageView!)
        containerView.addSubview(newImageView)
        
        
        newImageView.frame = transitionContext.finalFrame(for: tableViewController)
        newImageView.alpha = 0
        //tableView.transform = CGAffineTransformMakeScale(Zoom.minimum, Zoom.minimum)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            
            tableView?.alpha = 1
            tableView?.transform = CGAffineTransform.identity
            
            imageView?.alpha = 0
            //detailView.transform = CGAffineTransformMakeScale(Zoom.maximum, Zoom.maximum)
            
            }) { (animationCompleted: Bool) -> Void in
                
                imageView?.alpha = 1
                imageView?.transform = CGAffineTransform.identity
                
                transitionContext.completeTransition(animationCompleted)
        }
    }
    

    
    
}
