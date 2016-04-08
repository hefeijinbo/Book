//
//  HUD.swift
//  Test
//
//  Created by bo on 16/1/24.
//  Copyright © 2016年 huami. All rights reserved.
//

import UIKit

public class HUD: UIView {
    
    //MARK: - public
    public static func showLoading(title: String,inView: UIView = UIApplication.sharedApplication().delegate!.window!!) -> HUD {
        let hud = bundle.loadNibNamed("HUD", owner:nil, options:nil)[0] as! HUD
        hud.show(.Loading, title: title, inView: inView)
        return hud
    }

    public static func showSuccess(title: String,inView: UIView = UIApplication.sharedApplication().delegate!.window!!) -> HUD {
        let hud = bundle.loadNibNamed("HUD", owner:nil, options:nil)[0] as! HUD
        hud.show(.Success, title: title, inView: inView)
        return hud
    }
    
    public static func showFailure(title: String,inView: UIView = UIApplication.sharedApplication().delegate!.window!!) -> HUD {
        let hud = bundle.loadNibNamed("HUD", owner:nil, options:nil)[0] as! HUD
        hud.show(.Failure, title: title, inView: inView)
        return hud
    }
    
    public static func hideLoading(inView: UIView = UIApplication.sharedApplication().delegate!.window!!) {
        hide(inView)
    }
    
    //MARK: - private
    private enum HUDType:String {
        case Loading = "loading_hud" //需要手动调用 hide 方法关闭
        case Success = "success_hud",Failure = "failure_hud" //自动关闭
    }
    
    private static let bundle = NSBundle(forClass: HUD.self)
    
    private static func hide(inView: UIView) {
        for view in inView.subviews {
            if let view = view as? HUD {
                view.hide()
            }
        }
    }
    
    private func hide() {
        imageView.layer.removeAllAnimations()
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.alpha = 0
            }) { (finished) -> Void in
                self.removeFromSuperview()
        }
    }
    
    private func show(type:HUDType,title:String,inView:UIView) {
        
        for view in inView.subviews {
            if let view = view as? HUD {
                view.hide()
            }
        }
        
        labelTitle.text = title
        var ratio:CGFloat = 1.5 //iPad1.5倍缩放
        if UIDevice.currentDevice().userInterfaceIdiom != .Pad {
            ratio = UIScreen.mainScreen().bounds.size.width / 375.0//相对于iPhone 6的比例
        }
        viewContainer.layer.cornerRadius = 9 * ratio
        constraintImageViewTop.constant = 14 * ratio
        constraintTitleBottom.constant = 14 * ratio
        constraintLabelTitleTop.constant = 9.6 * ratio
        constraintLabelTitleLeading.constant = 20.6 * ratio
        constraintLabelTitleTrailing.constant = 20.6 * ratio
        constraintLabelTitleMinWidth.constant = 63 * ratio
        constraintLabelTitleMaxWidth.constant = 160 * ratio
        constraintImageViewWidth.constant = 52 * ratio
        labelTitle.font = UIFont.systemFontOfSize(13 * ratio)

        inView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false

        inView.addConstraint(NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: inView, attribute: .Leading, multiplier: 1, constant: 0))
        inView.addConstraint(NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: inView, attribute: .Trailing, multiplier: 1, constant: 0))
        inView.addConstraint(NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: inView, attribute: .Top, multiplier: 1, constant: 0))
        inView.addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom , relatedBy: .Equal, toItem: inView, attribute: .Bottom, multiplier: 1, constant: 0))

        alpha = 0
        UIView.animateWithDuration(0.1) { () -> Void in
            self.alpha = 1
        }
        
        imageView.layer.removeAnimationForKey("rotation")
        imageView.image = UIImage(named: type.rawValue, inBundle: HUD.bundle, compatibleWithTraitCollection: nil)
        if (type == .Loading) {
            let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotation.toValue = M_PI * 2
            rotation.duration = 0.6
            rotation.repeatCount = MAXFLOAT
            rotation.removedOnCompletion = false
            imageView.layer.addAnimation(rotation, forKey: "rotation")
        } else {// 2s后移除
            userInteractionEnabled = false            
            let popTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(2 * NSEC_PER_SEC)) // 1
            dispatch_after(popTime, dispatch_get_main_queue()) { // 2
                self.hide()
            }
        }
    }
    
    //MARK: - IBOutlet -
    @IBOutlet private weak var viewContainer: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var constraintImageViewTop: NSLayoutConstraint!
    @IBOutlet private weak var constraintLabelTitleTop: NSLayoutConstraint!
    @IBOutlet private weak var constraintTitleBottom: NSLayoutConstraint!
    @IBOutlet private weak var constraintImageViewWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraintLabelTitleTrailing: NSLayoutConstraint!
    @IBOutlet private weak var constraintLabelTitleLeading: NSLayoutConstraint!
    @IBOutlet private weak var constraintLabelTitleMinWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraintLabelTitleMaxWidth: NSLayoutConstraint!
}
