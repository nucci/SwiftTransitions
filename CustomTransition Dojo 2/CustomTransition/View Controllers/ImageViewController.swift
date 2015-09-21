//
//  ImageViewController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 19/09/15.
//  Copyright © 2015 Gian Nucci. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController  {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.alpha = 0.0
        // Do any additional setup after loading the view.
        
        self.imageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "tap")
        self.imageView.addGestureRecognizer(tap)
        
        self.textView.userInteractionEnabled = false
        
        self.navigationController?.navigationBarHidden = true
    }

    func tap ()
    {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.textView.alpha = 0.0
        }) { (bool) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.textView.alpha = 1.0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
