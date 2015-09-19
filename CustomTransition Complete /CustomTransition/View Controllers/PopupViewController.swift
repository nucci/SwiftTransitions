//
//  PopupViewController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 17/09/15.
//  Copyright © 2015 Gian Nucci. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController, UIViewControllerTransitioningDelegate {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.preferredContentSize = CGSize(width: 200, height: 100)
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 4
        self.view.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.view.layer.borderWidth = 1
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapped")))
    }

    func tapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.transitioningDelegate = self
        self.modalPresentationStyle = .Custom
    }
    
    
    //MARK: - <UIViewControllerTransitioningDelegate>
    
    lazy var popupAnimation = PopupAnimationController()
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        self.popupAnimation.reverseAnimation = false
        return self.popupAnimation
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        self.popupAnimation.reverseAnimation = true
        return self.popupAnimation
    }

}
