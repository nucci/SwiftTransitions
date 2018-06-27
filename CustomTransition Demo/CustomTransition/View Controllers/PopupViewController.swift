//
//  PopupViewController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 17/09/15.
//  Copyright © 2015 Gian Nucci. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PopupViewController.tapped)))
    }

    @objc func tapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
}
