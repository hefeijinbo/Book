//
//  BookCell.swift
//  Book
//
//  Created by 金波 on 15/12/26.
//  Copyright © 2015年 jikexueyuan. All rights reserved.
//

import UIKit
import UITools

class BookCell: UITableViewCell {

    var URLStrings = [String]()
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var labelDetail: UILabel!
    
    override func awakeFromNib() {
        imageViewIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "clickImageView"))
    }
    
    func clickImageView() {
        if let tableView = self.superview?.superview as? UITableView {
            let indexPath = tableView.indexPathForCell(self)
            ImageBrowser.showFromImageView(imageViewIcon, URLStrings:URLStrings, index: indexPath?.row ?? 0)
        }
    }
    
    func configureWithBook(book:Book,URLStrings:[String]) {
        self.URLStrings = URLStrings
        imageViewIcon.setResizeImageWith(book.image)
        ratingView.value = CGFloat(book.rating.average)
        labelTitle.text = book.title
        
        var detail = ""
        
        for str in book.author {
            detail += (str + "/")
        }
        labelDetail.text = detail + book.publisher + "/" + book.pubdate
    }
}
