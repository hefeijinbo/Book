//
//  Toast.swift
//  Test
//
//  Created by jinbo on 16/2/14.
//  Copyright © 2016年 huami. All rights reserved.
//

import UIKit

public class Toast: UIView {
    
    //MARK: public
    public enum ToastPosition {
        case Bottom,Center
    }

    public static func showToast(title:String, inView:UIView = UIApplication.sharedApplication().delegate!.window!!, position:ToastPosition = .Bottom) -> Toast {
        for subview in inView.subviews {
            if let subview = subview as? Toast {
                subview.hide()
            }
        }
        let toast = NSBundle(forClass: Toast.self).loadNibNamed("Toast", owner: nil, options: nil)[0] as! Toast
        toast.configureToast(title, inView: inView,position: position)
        return toast
    }
    
    //MARK: private
    private func configureToast(title: String, inView: UIView, position:ToastPosition) {
        labelTitle.text = title
        let ratio = UIScreen.mainScreen().bounds.size.width / 375.0
        constraintTop.constant = 16 * ratio
        constraintBottom.constant = 16 * ratio
        constraintLeading.constant = 13.7 * ratio
        constraintTrailing.constant = 13.7 * ratio
        layer.cornerRadius = 9 * ratio
        
        inView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0
        UIView.animateWithDuration(0.1) { () -> Void in
            self.alpha = 1
        }
        inView.addConstraint(NSLayoutConstraint(item: inView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .Width, multiplier: 1, constant: 104.0 * ratio))
        addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .Width, multiplier: 1, constant: 203.0 * ratio))
        
        if position == .Bottom {
            inView.addConstraint(NSLayoutConstraint(item: inView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant:112 * ratio))
        } else {
            inView.addConstraint(NSLayoutConstraint(item: inView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant:0))
        }
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(2 * NSEC_PER_SEC)) // 1
        dispatch_after(popTime, dispatch_get_main_queue()) { // 2
            self.hide()
        }
        
    }
    
    private func hide() {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.alpha = 0
            }, completion: { (finished) -> Void in
                self.removeFromSuperview()
        })
    }
    
    @IBOutlet private var viewBg:UIView!
    @IBOutlet private var labelTitle:UILabel!
    @IBOutlet private var constraintTop:NSLayoutConstraint!
    @IBOutlet private var constraintBottom:NSLayoutConstraint!
    @IBOutlet private var constraintLeading:NSLayoutConstraint!
    @IBOutlet private var constraintTrailing:NSLayoutConstraint!

}
