//
//  TransitionsTableViewController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 15/09/15.
//  Copyright (c) 2015 Gian Nucci. All rights reserved.
//

import UIKit

class TransitionsTableViewController: UITableViewController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row) {
        case 0:
            let zoomVC = self.storyboard!.instantiateViewControllerWithIdentifier("detailViewController")
            zoomVC.transitioningDelegate = self
            zoomVC.modalPresentationStyle = .Custom
            self.presentViewController(zoomVC, animated: true, completion: nil)
            break
        case 1:
            let popupVC = self.storyboard!.instantiateViewControllerWithIdentifier("popupViewController")
            self.presentViewController(popupVC, animated: true, completion: nil)
            break
        case 2:
            let cubeVC = self.storyboard!.instantiateViewControllerWithIdentifier("cubeViewController")
            self.navigationController?.delegate = self
            self.navigationController?.pushViewController(cubeVC, animated: true)
            break
        case 3:
            let imgVC = self.storyboard!.instantiateViewControllerWithIdentifier("ImageViewController")
            imgVC.transitioningDelegate = self
            imgVC.modalPresentationStyle = .Custom
            self.presentViewController(imgVC, animated: true, completion: nil)
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
    }
    
    //MARK: - <UIViewControllerTransitioningDelegate>

    lazy var imageAnimation = ImagemAnimationController()
    lazy var zoomAnimation  = ZoomAnimationController()
    lazy var cubeAnimation  = CubeAnimationController()
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if presented.isKindOfClass(DetailViewController) {
            self.zoomAnimation.reverseAnimation = false
            return self.zoomAnimation
        } else if presented.isKindOfClass(ImageViewController) {
            self.imageAnimation.reverseAnimation = false
            return self.imageAnimation
        }
        
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if dismissed.isKindOfClass(DetailViewController) {
            self.zoomAnimation.reverseAnimation = true
            return self.zoomAnimation
        } else if dismissed.isKindOfClass(ImageViewController) {
            self.imageAnimation.reverseAnimation = true
            return self.imageAnimation
        }
        
        return nil
    }
    
    //MARK: - UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        switch (operation) {
            
        case .Pop:
            self.cubeAnimation.reverseAnimation = true
            break
            
        default:
            self.cubeAnimation.reverseAnimation = false
            break
        }
        
        //TODO:
        self.cubeAnimation.interactivePopGestureRecognizer = navigationController.interactivePopGestureRecognizer
        
        return self.cubeAnimation
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        if self.cubeAnimation.interactive {
            return self.cubeAnimation
        }
        return nil
    }
}
