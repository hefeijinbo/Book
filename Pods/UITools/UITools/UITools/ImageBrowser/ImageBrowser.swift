//
//  PhoneBrowserController.swift
//  Book
//
//  Created by jinbo on 16/1/4.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

let MainWindow = UIApplication.sharedApplication().delegate!.window!!

public class ImageBrowser: UIViewController {
    
    //MARK: public
    //frame 相对于 keyWindow 的位置
    public static func showFromImageView(imageView:UIImageView,URLStrings:[String],index:Int) -> ImageBrowser {
        let browser = UIStoryboard(name: "ImageBrowser", bundle: NSBundle(forClass: ImageBrowser.self)).instantiateInitialViewController() as! ImageBrowser
        browser.URLStrings = URLStrings
        browser.index = index
        browser.startFrame = imageView.superview!.convertRect(imageView.frame, toView: MainWindow)
        browser.image = imageView.image
        MainWindow.rootViewController?.presentViewController(browser, animated: false, completion: nil)
        return browser
    }
    
    //MARK: private
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var URLStrings = [String]()
    private var index = 0
    private var startFrame = CGRectZero
    private var endFrame = UIScreen.mainScreen().bounds
    private var image: UIImage?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        
        let screenBounds = UIScreen.mainScreen().bounds
        let screenSize = screenBounds.size
        
        if let image = imageView.image {
            
            let ratio = image.size.width / image.size.height
            
            if ratio < (startFrame.width / startFrame.height) {
                let midX = CGRectGetMidX(startFrame);
                startFrame.size.width = startFrame.height * ratio;
                startFrame.origin.x = midX - startFrame.size.width / 2;
            } else {
                let midY = CGRectGetMidY(startFrame);
                startFrame.size.height = startFrame.width / ratio;
                startFrame.origin.y = midY - startFrame.size.height / 2;
            }
            
            if ratio < screenSize.width / screenSize.height {
                endFrame.size.width = screenSize.height * ratio;
                endFrame.origin.x = CGRectGetMidX(screenBounds) - endFrame.size.width / 2;
            } else {
                endFrame.size.height = screenSize.width / ratio;
                endFrame.origin.y = CGRectGetMidY(screenBounds) - endFrame.size.height / 2;
            }
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        imageView.frame = startFrame
        collectionView.setContentOffset(CGPointMake(UIScreen.mainScreen().bounds.size.width * CGFloat(self.index),0), animated: false)
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.imageView.frame = self.endFrame
            }) { (result) -> Void in
                self.imageView.hidden = true
                self.collectionView.hidden = false;
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return URLStrings.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageBrowserCell", forIndexPath: indexPath) as! ImageBrowserCell
        cell.imageView.setImageWith(URLStrings[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let cell  = cell as? ImageBrowserCell {
            cell.scrollView.zoomScale = 1
        }
    }
    
    private var hasTransition = false
    
    public override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        hasTransition = true
        let index = Int(collectionView.contentOffset.x / UIScreen.mainScreen().bounds.size.width)
        coordinator.animateAlongsideTransition(nil) { (context) -> Void in
            self.collectionView.reloadData()
            self.collectionView.setContentOffset(CGPointMake(UIScreen.mainScreen().bounds.size.width * CGFloat(index),0), animated: false)
        }
    }
    
    @IBAction private func tapCollectionView(sender: AnyObject) {
        if hasTransition {
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        imageView.hidden = false
        collectionView.hidden = true
        imageView.frame = endFrame
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.imageView.frame = self.startFrame
            }) { (result) -> Void in
                self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
}
