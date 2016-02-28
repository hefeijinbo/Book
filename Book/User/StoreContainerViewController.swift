//
//  StoreContainerViewController.swift
//  Book
//
//  Created by bo on 16/2/21.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class StoreContainerViewController: UIViewController {
    
    var book = Book()

    override func viewDidLoad() {
        (childViewControllers[0] as! StoreViewController).book = book
        super.viewDidLoad()
    }
    

    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}
