//
//  ImageViewController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 18/09/15.
//  Copyright © 2015 Gian Nucci. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.quoteLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.quoteLabel.alpha = 1
        })
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.animate(withDuration: 0.15, animations: { () -> Void in
            self.quoteLabel.alpha = 0
            }, completion: { (finished: Bool) -> Void in
                self.dismiss(animated: true, completion: nil)
        }) 
    }

}
