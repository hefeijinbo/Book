//
//  BookRatingView.swift
//  Rating Demo
//
//  Created by jinbo on 15/12/28.
//  Copyright © 2015年 On The huami. All rights reserved.
//

import UIKit

public class RatingView: UIView {
    
    //MARK: public
    //当前评分值
    @IBInspectable public var value:CGFloat = 0.0 {
        didSet {
            let maxStar = CGFloat(self.maxStar)
            if value > maxStar {
                value = maxStar
            } else if value < 0 {
                value = 0
            }
            setNeedsLayout()
        }
    }
    
    //最大评分数
    @IBInspectable public var maxStar:CGFloat = 5
    
    //MARK: private
    private var imageViews = [UIImageView]()
    private var firstLoad = true

    func touchRatingView(gesture:UIGestureRecognizer) {
        value = gesture.locationInView(self).x / frame.size.width * maxStar
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if firstLoad {
            firstLoad = false
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: "touchRatingView:"))
            addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "touchRatingView:"))
        }
        
        maxStar = floor(maxStar)
        
        let starWidth = (frame.size.width - (maxStar - 1) * 4)/maxStar
        
        if imageViews.isEmpty {
            for i in 0..<Int(maxStar) {
                let i = CGFloat(i)
                let emptyImageView = UIImageView(image: UIImage(named: "star_empty.png", inBundle: NSBundle(forClass: RatingView.self), compatibleWithTraitCollection: nil))
                let fullImageView = UIImageView(image: UIImage(named: "star_full.png", inBundle: NSBundle(forClass: RatingView.self), compatibleWithTraitCollection: nil))
                let starFrame = CGRect(x: starWidth * i + 4 * i, y: 0, width: starWidth, height: frame.size.height)
                emptyImageView.contentMode = .ScaleAspectFit
                fullImageView.contentMode = .ScaleAspectFit
                emptyImageView.frame = starFrame
                fullImageView.frame = starFrame
                imageViews.append(fullImageView)
                addSubview(emptyImageView)
                addSubview(fullImageView)
            }
        }
        
        for (i,imageView) in imageViews.enumerate() {
            let i = CGFloat(i)
            if value >= i + 1 {
                imageView.layer.mask = nil
                imageView.hidden = false
            } else if value < i + 1 && value > i {
                let maskLayer = CALayer()
                maskLayer.frame = CGRect(x: 0, y: 0, width: (value - i) * starWidth, height: frame.size.height)
                maskLayer.backgroundColor = UIColor.blackColor().CGColor
                imageView.layer.mask = maskLayer
                imageView.hidden = false
            } else {
                imageView.layer.mask = nil
                imageView.hidden = true
            }
        }

    }
}
