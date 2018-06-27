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
        
        self.imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.tap))
        self.imageView.addGestureRecognizer(tap)
        
        self.textView.isUserInteractionEnabled = false
        
        self.navigationController?.isNavigationBarHidden = true
    }

    @objc func tap ()
    {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.textView.alpha = 0.0
        }, completion: { (bool) -> Void in
            self.navigationController?.popViewController(animated: true)
        }) 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.textView.alpha = 1.0
        }) 
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
