//
//  ViewController.swift
//  SGDragModalViewControllerExample
//
//  Created by sgcy on 15/5/24.
//  Copyright (c) 2015年 sgcy. All rights reserved.
//

import UIKit

class ViewController: UIViewController,SGDragModalViewControllerDelegate{

    
    var dragController:SGDragModalViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let tableVC = UITableViewController(style: UITableViewStyle.Plain)
        
        
        dragController = SGDragModalViewController(bgView: self.view, scrollView: tableVC.tableView, delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showBtnClick(sender: AnyObject) {
        dragController.goCenter()
    }
    
    func SGDragModalViewControllerGoCenter(contentView: UIView) {
        
    }
    func SGDragModalViewControllerGoDown(contentView: UIView) {
        
    }
    func SGDragModalViewControllerGoUp(contentView: UIView) {
        
    }

}

