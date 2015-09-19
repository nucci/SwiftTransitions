//
//  TransitionsTableViewController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 15/09/15.
//  Copyright (c) 2015 Gian Nucci. All rights reserved.
//

import UIKit

class TransitionsTableViewController: UITableViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row) {
        case 0:
            let zoomVC = self.storyboard!.instantiateViewControllerWithIdentifier("detailViewController")
            self.presentViewController(zoomVC, animated: true, completion: nil)
            break
        case 1:
            let popupVC = self.storyboard!.instantiateViewControllerWithIdentifier("popupViewController")
            self.presentViewController(popupVC, animated: true, completion: nil)
            break
        case 2:
            let cubeVC = self.storyboard!.instantiateViewControllerWithIdentifier("cubeViewController")
            self.navigationController?.pushViewController(cubeVC, animated: true)
            break
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
    }
    
}
