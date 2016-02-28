//
//  Constants.swift
//  Book
//
//  Created by 金波 on 16/1/5.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

let DocumentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true)[0]

let MainWindow = UIApplication.sharedApplication().delegate!.window!!

var ScreenMidX: CGFloat {
    return CGRectGetMidX(UIScreen.mainScreen().bounds)
}

var ScreenMidY: CGFloat {
    return CGRectGetMidY(UIScreen.mainScreen().bounds)
}

var ScreenRatio: CGFloat {
    return ScreenWidth / ScreenHeight
}

var ScreenWidth:CGFloat {
    return UIScreen.mainScreen().bounds.size.width
}

var ScreenHeight:CGFloat {
    return UIScreen.mainScreen().bounds.size.height
}

