//
//  DetailViewController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 15/09/15.
//  Copyright (c) 2015 Gian Nucci. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DetailViewController.tapped)))
    }
    
    @objc func tapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
