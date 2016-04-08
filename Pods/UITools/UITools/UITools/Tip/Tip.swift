//
//  Tip.swift
//  Test
//
//  Created by jinbo on 16/2/15.
//  Copyright © 2016年 huami. All rights reserved.
//

import UIKit

public class Tip: UIView {
    
    //MARK: public
    public enum TipType:String {
        case Warning = "warning_tip.png",Success = "success_tip.png",Loading = "loading_tip.png",Failure = "failure_tip.png"
    }
    
    public enum TipPosition {
        //插入(覆盖)在headView的顶部(底部)
        case TopCover, TopInsert, BottomCover, BottomInsert
    }
    
    public static func showTip(title:String,inTableView:UITableView, type: TipType, position: TipPosition , btnTuple:(btnTitle: String,clickClosure:(Void->Void)?)?) -> Tip {
        if let headerView = inTableView.tableHeaderView {
            for subview in headerView.subviews {
                if let tip = subview as? Tip {
                    tip.configureTip(title, type: type, btnTuple: btnTuple)
                    tip.updatePosition(position,isAdd: false)
                    return tip
                }
            }
        }
        let tip = NSBundle(forClass: Tip.self).loadNibNamed("Tip", owner: nil, options: nil)[0] as! Tip
        tip.tableView = inTableView
        tip.headViewOld = inTableView.tableHeaderView
        tip.configureTip(title, type: type, btnTuple: btnTuple)
        tip.updatePosition(position,isAdd: true)
        return tip
    }
    
    public static func hideTip(inTableView: UITableView, delay:UInt64 = 0) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(delay * NSEC_PER_SEC)) // 1
        dispatch_after(popTime, dispatch_get_main_queue()) { // 2
            if let headView = inTableView.tableHeaderView {
                for view in headView.subviews {
                    if let tip = view as? Tip {
                        tip.close(nil)
                        break;
                    }
                }
            }
        }
    }
    
    //MARK: private
    private func configureTip(title:String, type: TipType,btnTuple:(btnTitle: String,clickClosure:(Void->Void)?)?) {
        hidden = false
        constraintLineViewHeight.constant = 1 / UIScreen.mainScreen().scale
        btnRight.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.25).CGColor
        if let btnTuple = btnTuple {
            btnRight.setTitle(btnTuple.btnTitle, forState: .Normal)
            clickClosure = btnTuple.clickClosure
            btnRight.hidden = false
        } else {
            btnRight.hidden = true
        }
        lblTitle.text = title
        btnLeft.setImage(UIImage(named: type.rawValue, inBundle: NSBundle(forClass: Tip.self), compatibleWithTraitCollection: nil), forState:.Normal)
        btnLeft.userInteractionEnabled = type == .Failure
        btnLeft.layer.removeAnimationForKey("rotation")

        if type == .Loading {
            let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotation.fromValue = 0
            rotation.toValue = M_PI * 2.0
            rotation.duration = 0.3
            rotation.removedOnCompletion = false
            rotation.repeatCount = Float.infinity
            btnLeft.layer.addAnimation(rotation, forKey: "rotation")
        }
    }
    
    private func updatePosition(position: TipPosition,isAdd:Bool) {
        var originHeight:CGFloat = 0
        if headViewOld != nil {
            originHeight = headViewOld.frame.size.height
            tableView.tableHeaderView = nil
            headViewOld.translatesAutoresizingMaskIntoConstraints = false
            self.translatesAutoresizingMaskIntoConstraints = false
            if isAdd {
                headViewNew = UIView()
                headViewNew.addSubview(headViewOld)
                headViewNew.addSubview(self)
            }
            headViewNew.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[view]|", options: .AlignAllLeft, metrics: nil, views: ["view":headViewOld]))
            headViewNew.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[view]|", options: .AlignAllLeft, metrics:nil, views: ["view":self]))
            var format = ""
            if position == .TopCover || position == .TopInsert {
                format = "V:|[view(44)]"
            } else {
                format = "V:[view(44)]|"
            }
            headViewNew.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: .AlignAllLeft, metrics:nil, views: ["view":self]))

            if position == .TopCover || position == .TopInsert {
                headViewNew.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view(height)]", options: .AlignAllLeft, metrics: ["height":originHeight], views: ["view":headViewOld]))
            } else {
                headViewNew.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[view(height)]|", options: .AlignAllLeft, metrics: ["height":originHeight], views: ["view":headViewOld]))
            }
        } else {
            originHeight = 0
            if isAdd {
                headViewNew.addSubview(self)
            }
        }
        if position == .TopInsert || position == .BottomInsert {
            headViewNew.frame.size.height = originHeight + frame.size.height
        } else {
            headViewNew.frame.size.height = originHeight
        }

        tableView.tableHeaderView = headViewNew
    }
    
    @IBAction private func close(sender: AnyObject?) {
        hidden = true
        tableView.tableHeaderView!.frame.size.height = headViewOld.frame.size.height
    }
    
    @IBAction private func clickBtnRight(sender: AnyObject) {
        clickClosure?()
    }
    
    private var clickClosure:(()->())?
    private weak var tableView: UITableView!
    private var headViewOld:UIView!
    private var headViewNew:UIView!
    @IBOutlet private var btnLeft: UIButton!
    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var btnRight: UIButton!
    @IBOutlet private weak var constraintLineViewHeight: NSLayoutConstraint!
    
}
