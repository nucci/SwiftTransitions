//
//  TransitionsTableViewController.swift
//  CustomTransition
//
//  Created by Gian Nucci on 15/09/15.
//  Copyright (c) 2015 Gian Nucci. All rights reserved.
//

import UIKit

class TransitionsTableViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            let zoomVC = self.storyboard!.instantiateViewController(withIdentifier: "detailViewController")
            self.present(zoomVC, animated: true, completion: nil)
            break
        case 1:
            let popupVC = self.storyboard!.instantiateViewController(withIdentifier: "popupViewController")
            self.present(popupVC, animated: true, completion: nil)
            break
        case 2:
            let cubeVC = self.storyboard!.instantiateViewController(withIdentifier: "cubeViewController")
            self.navigationController?.pushViewController(cubeVC, animated: true)
            break
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: false);
    }
    
}
