//
//  ReviewCell.swift
//  Book
//
//  Created by 金波 on 16/1/3.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import UITools

class ReviewCell: UITableViewCell {

    @IBOutlet weak var imageViewHead: UIImageView!

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSummary: UILabel!
    @IBOutlet weak var labelRatingNum: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    func configureWithReview(review:Review) {
        imageViewHead.setImageWith(review.author.avatar)
        labelTitle.text = review.title
        labelName.text = review.author.name
        ratingView.value = CGFloat(review.rating.average)

        labelSummary.text = review.summary
        labelDate.text = review.updated
    }
}
