//
//  BookExtensions.swift
//  Book
//
//  Created by 金波 on 15/12/27.
//  Copyright © 2015年 jikexueyuan. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

//MJRefresh
extension UITableView {
    func headerAddMJRefresh(block:MJRefreshComponentRefreshingBlock) {
        mj_header = MJRefreshNormalHeader(refreshingBlock: block)
    }
    
    func headerBeginRefresh() {
        mj_header.beginRefreshing()
    }
    
    func headerEndRefresh() {
        mj_header.endRefreshing()
    }
    
    func footerAddMJRefresh(block:MJRefreshComponentRefreshingBlock) {
        mj_footer = MJRefreshBackNormalFooter(refreshingBlock:block)
    }
    
    func footerBeginRefresh() {
        mj_footer.beginRefreshing()
    }
    
    func footerEndRefresh() {
        mj_footer.endRefreshing()
    }
    
    func footerEndRefreshNoMoreData() {
        mj_footer.endRefreshingWithNoMoreData()
    }
    
    func footerResetNoMoreData() {
        mj_footer.resetNoMoreData()
    }
}

func dispatch_after(time:UInt64,closure:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW,
        Int64(time * NSEC_PER_SEC)) // 1
    dispatch_after(popTime, dispatch_get_main_queue()) { // 2
        closure();
    }
}

extension UIStoryboard {
    enum StoryboardType:String {
        case Main = "Main"
        case User = "User"
    }

    static func instantiateVCWithType(type:StoryboardType,identifier:String) -> UIViewController {
        return UIStoryboard(name: type.rawValue, bundle: nil).instantiateViewControllerWithIdentifier(identifier)
    }
}

extension UIImage {
    //调整size
    func resizeToSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIImageView {
    func setImageWith(URLString:String) {
        let URL = NSURL(string: URLString)
        let key = SDWebImageManager.sharedManager().cacheKeyForURL(URL) ?? ""
        if let cacheImage = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(key) {
            image = cacheImage
        } else {
            sd_setImageWithURL(URL)
        }
    }
    
    //下载图片并调整size
    func setResizeImageWith(URLString:String) {
        let URL = NSURL(string: URLString)
        let key = SDWebImageManager.sharedManager().cacheKeyForURL(URL) ?? ""
        let width = frame.size.width
        
        if var cacheImage = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(key) { // 取本地缓存图片并设置合适的size
            if cacheImage.size.width > width {
                let size = CGSizeMake(width, cacheImage.size.height * (width / cacheImage.size.width))
                cacheImage = cacheImage.resizeToSize(size)
            }
            self.image = cacheImage
        } else { // 下载网络图片并设置合适的size
            SDWebImageDownloader.sharedDownloader().downloadImageWithURL(URL, options: .AllowInvalidSSLCertificates, progress: nil, completed: { (var image, data, error, result) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if image != nil && image.size.width > width {
                        let size = CGSizeMake(width, image.size.height * (width / image.size.width))
                        image = image.resizeToSize(size)
                    }
                    self.image = image
                })
            })
        }
    }
}