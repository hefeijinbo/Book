//
//  ReviewContainerViewController.swift
//  Book
//
//  Created by bo on 16/2/21.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class ReviewContainerViewController: UIViewController {

    var book = Book()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (childViewControllers[0] as! ReviewViewController).book = book
    }

    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}
