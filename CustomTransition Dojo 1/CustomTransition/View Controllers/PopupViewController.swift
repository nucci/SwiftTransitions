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
        self.view.layer.borderColor = UIColor.darkGray.cgColor
        self.view.layer.borderWidth = 1
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PopupViewController.tapped)))
    }

    @objc func tapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }
    
    
    //MARK: - <UIViewControllerTransitioningDelegate>
    
    lazy var popupAnimation = PopupAnimationController()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        self.popupAnimation.reverseAnimation = false
        return self.popupAnimation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        self.popupAnimation.reverseAnimation = true
        return self.popupAnimation
    }

}
