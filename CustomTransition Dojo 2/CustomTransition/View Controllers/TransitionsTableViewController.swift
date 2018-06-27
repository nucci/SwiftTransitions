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
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: false);
    }
    
    //MARK: - <UIViewControllerTransitioningDelegate>
    
    lazy var zoomAnimation = ZoomAnimationController()
    lazy var cubeAnimation = CubeAnimationController()
    lazy var imageAnimation = ImageAnimationController()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if presented.isKind(of: DetailViewController.self) {
            self.zoomAnimation.reverseAnimation = false
            return self.zoomAnimation
        }
        
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if dismissed.isKind(of: DetailViewController.self) {
            self.zoomAnimation.reverseAnimation = true
            return self.zoomAnimation
        }
        
        return nil
    }
    
    //MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        switch (operation) {
            
        case .pop:
            self.imageAnimation.reverseAnimation = true
            break
            
        default:
            self.imageAnimation.reverseAnimation = false
            break
        }
        
        return self.imageAnimation
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        if self.cubeAnimation.interactive {
            return self.cubeAnimation
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.delegate = self

    }
}
