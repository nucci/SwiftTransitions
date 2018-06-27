//
//  TransitionsTableViewController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 15/09/15.
//  Copyright (c) 2015 Gian Nucci. All rights reserved.
//

import UIKit

class TransitionsTableViewController: UITableViewController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            let zoomVC = self.storyboard!.instantiateViewController(withIdentifier: "detailViewController")
            zoomVC.transitioningDelegate = self
            zoomVC.modalPresentationStyle = .custom
            self.present(zoomVC, animated: true, completion: nil)
            break
        case 1:
            let popupVC = self.storyboard!.instantiateViewController(withIdentifier: "popupViewController")
            self.present(popupVC, animated: true, completion: nil)
            break
        case 2:
            let cubeVC = self.storyboard!.instantiateViewController(withIdentifier: "cubeViewController")
            self.navigationController?.delegate = self
            self.navigationController?.pushViewController(cubeVC, animated: true)
            break
        case 3:
            let imgVC = self.storyboard!.instantiateViewController(withIdentifier: "ImageViewController")
            imgVC.transitioningDelegate = self
            imgVC.modalPresentationStyle = .custom
            self.present(imgVC, animated: true, completion: nil)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: false);
    }
    
    //MARK: - <UIViewControllerTransitioningDelegate>

    lazy var imageAnimation = ImagemAnimationController()
    lazy var zoomAnimation  = ZoomAnimationController()
    lazy var cubeAnimation  = CubeAnimationController()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if presented.isKind(of: DetailViewController.self) {
            self.zoomAnimation.reverseAnimation = false
            return self.zoomAnimation
        } else if presented.isKind(of: ImageViewController.self) {
            self.imageAnimation.reverseAnimation = false
            return self.imageAnimation
        }
        
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if dismissed.isKind(of: DetailViewController.self) {
            self.zoomAnimation.reverseAnimation = true
            return self.zoomAnimation
        } else if dismissed.isKind(of: ImageViewController.self) {
            self.imageAnimation.reverseAnimation = true
            return self.imageAnimation
        }
        
        return nil
    }
    
    //MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        switch (operation) {
            
        case .pop:
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
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        if self.cubeAnimation.interactive {
            return self.cubeAnimation
        }
        return nil
    }
}
