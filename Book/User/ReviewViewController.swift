//
//  ReviewViewController.swift
//  Book
//
//  Created by 金波 on 16/1/22.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class ReviewViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    var book = Book() {
        didSet {
            imageView.setImageWith(book.image)
        }
    }

}
