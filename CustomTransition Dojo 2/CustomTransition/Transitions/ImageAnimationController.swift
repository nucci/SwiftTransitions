//
//  ImageAnimationController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 19/09/15.
//  Copyright © 2015 Gian Nucci. All rights reserved.
//

import UIKit

class ImageAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    // animation properties
    var reverseAnimation = false
    lazy var tempImageView : UIImageView = {
    
        let imageView = UIImageView ()
        imageView.image = UIImage(named: "balloons.png")
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        
        return imageView
    }()
    
    //MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.reverseAnimation {
            animateOut(transitionContext)
        }
        else {
            animateIn(transitionContext)
        }
    }
    
    //MARK: - Animations
    
    func animateIn(_ transitionContext: UIViewControllerContextTransitioning)
    {
        let tableViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)! as! TransitionsTableViewController
        let imageViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let containerView: UIView = transitionContext.containerView
        let detailView = imageViewController.view
        let indexPath = IndexPath(row: 3, section: 0)
        let cell = tableViewController.tableView.cellForRow(at: indexPath)
        let rect = cell?.imageView?.convert((cell?.imageView?.frame)!, to: containerView)
        tempImageView.frame = rect!
        
        containerView.addSubview(tempImageView)
        
        
//        let imageView = cell?.imageView
//        tempImageView.bounds = (imageView?.bounds)!;
        
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay:0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.tempImageView.frame = containerView.bounds
            
            
            //detailView.transform = CGAffineTransformIdentity
            
            }) { (animationCompleted: Bool) -> Void in
                
                // since the detail view was just built, it needs to be added to the view heirarchy
                containerView.addSubview(detailView!)
                detailView?.frame = containerView.bounds
                
                self.tempImageView.removeFromSuperview()
                // when the animation is done we need to complete the transition
                transitionContext.completeTransition(animationCompleted)
        }
    }
    
    func animateOut(_ transitionContext: UIViewControllerContextTransitioning)
    {
        let tableViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)! as! TransitionsTableViewController
        let imageViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        let containerView: UIView = transitionContext.containerView
        let detailView = imageViewController.view
        let indexPath = IndexPath(row: 3, section: 0)
        let cell = tableViewController.tableView.cellForRow(at: indexPath)
        let rect = cell?.imageView?.convert((cell?.imageView?.frame)!, to: containerView)
        tempImageView.frame = containerView.bounds
        
        containerView.addSubview(tableViewController.view)
        containerView.addSubview(tempImageView)
        
        
        //        let imageView = cell?.imageView
        //        tempImageView.bounds = (imageView?.bounds)!;
        
        imageViewController.view.alpha = 0
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay:0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.tempImageView.frame = rect!
            
            
            //detailView.transform = CGAffineTransformIdentity
            
            }) { (animationCompleted: Bool) -> Void in
                
                // since the detail view was just built, it needs to be added to the view heirarchy
                containerView.addSubview(detailView!)
                
                self.tempImageView.removeFromSuperview()
                
                // when the animation is done we need to complete the transition
                transitionContext.completeTransition(animationCompleted)
        }
    }
}
