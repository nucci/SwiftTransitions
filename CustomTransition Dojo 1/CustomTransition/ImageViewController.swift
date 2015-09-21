//
//  ImageViewController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 19/09/15.
//  Copyright © 2015 Gian Nucci. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var poemaLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismiss")))
    }
  
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.poemaLabel.alpha = 1;
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewControlle     r.
        // Pass the selected object to the new view controller.
    }
    */

}
