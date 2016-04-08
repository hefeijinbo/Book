//
//  DetailHeadView.swift
//  Book
//
//  Created by 金波 on 16/1/1.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import UITools

//详情页 headView
class DetailHeadView: UIView {
    //MARK: - Property
    var detailVC: DetailViewController!
    //MARK: - IBOutlet
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var labelRatingNum: UILabel!
    @IBOutlet weak var labelPublisher: UILabel!
    @IBOutlet weak var labelSummary: UILabel!

    static func showInVC(detailVC:DetailViewController) -> DetailHeadView {
        let headView = NSBundle.mainBundle().loadNibNamed("DetailHeadView", owner: nil, options: nil)[0] as! DetailHeadView
        headView.configureWith(detailVC)
        return headView
    }
    
    func configureWith(detailVC:DetailViewController) {
        self.detailVC = detailVC
        imageViewIcon.addGestureRecognizer(UITapGestureRecognizer(target: detailVC, action: #selector(DetailViewController.showImage(_:))))
        imageViewIcon.setImageWith(detailVC.book.image)
        labelTitle.text = detailVC.book.title
        ratingView.value = CGFloat(detailVC.book.rating.average)
        
        var desc = ""
        for str in detailVC.book.author {
            desc += (str + "/")
        }
        
        labelPublisher.text = desc + detailVC.book.publisher + "/" + detailVC.book.pubdate
        labelSummary.text = detailVC.book.summary
        detailVC.tableView.tableHeaderView = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame.size.height = viewContainer.frame.size.height
        detailVC.tableView.tableHeaderView = self
    }

    //评论
    @IBAction func comment(sender: AnyObject) {
        if User.sharedUser.isLogin {
            let reviewContainerVC = UIStoryboard.instantiateVCWithType(.User, identifier: "ReviewContainerViewController") as! ReviewContainerViewController
            reviewContainerVC.book = detailVC.book
            detailVC.navigationController?.pushViewController(reviewContainerVC, animated: true)
        } else {
            detailVC.navigationController?.pushViewController(UIStoryboard(name: "User", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController"), animated: true)
        }
        
    }
    
    //收藏
    @IBAction func collect(sender: AnyObject) {
        if User.sharedUser.isLogin {
            let storeContainerVC = UIStoryboard.instantiateVCWithType(.User, identifier: "StoreContainerViewController") as! StoreContainerViewController
            storeContainerVC.book = detailVC.book
            detailVC.navigationController?.pushViewController(storeContainerVC, animated: true)
        } else {
            detailVC.navigationController?.pushViewController(UIStoryboard(name: "User", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController"), animated: true)
        }
    }

}
