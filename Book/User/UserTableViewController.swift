//
//  UserTableViewController.swift
//  Book
//
//  Created by bo on 16/2/20.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    @IBOutlet weak var imageViewIcon: UIImageView!

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!

    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var labelAlt: UILabel!
    
    @IBOutlet weak var labelCreated: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewIcon.setImageWith(User.sharedUser.avatar)
        labelName.text = User.sharedUser.name
        labelAddress.text = User.sharedUser.loc_name
        labelID.text = User.sharedUser.douban_user_id
        labelAlt.text = User.sharedUser.alt
        labelCreated.text = User.sharedUser.created
        labelDesc.text = User.sharedUser.desc
        
        tableView.tableFooterView = UIView()

    }



}
