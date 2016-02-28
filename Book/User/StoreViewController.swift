//
//  StoreViewController.swift
//  Book
//
//  Created by bo on 16/2/21.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class StoreViewController: UITableViewController {

    var book = Book() {
        didSet {
            imageView.setImageWith(book.image)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!

}
