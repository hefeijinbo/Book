//
//  ImageViewExtension.swift
//
//  Created by jinbo on 16/2/15.
//  Copyright © 2016年 huami. All rights reserved.
//

import UIKit

private var indexPathIdentifierAssociationKey: UInt8 = 0

extension UIImageView {
    
    private var indexPathIdentifier: Int {
        get {
            return objc_getAssociatedObject(self, &indexPathIdentifierAssociationKey) as? Int ?? -1
        }
        set {
            objc_setAssociatedObject(self, &indexPathIdentifierAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    internal func setImageWith(URLString: String) {
        guard let URL = NSURL(string: URLString) else {
            print("\(URLString):unsupported URL")
            return
        }
        
        let cacheManager = ImageCacheManager.sharedInstance
        let request = NSMutableURLRequest(URL: URL, cachePolicy: cacheManager.session.configuration.requestCachePolicy, timeoutInterval: cacheManager.session.configuration.timeoutIntervalForRequest)
        request.addValue("image/*", forHTTPHeaderField: "Accept")
        indexPathIdentifier = -1
        
        let sharedURLCache = NSURLCache.sharedURLCache()
        if let image = cacheManager[URLString] {
            self.image = image
        } else if let cachedResponse = sharedURLCache.cachedResponseForRequest(request), image = UIImage(data: cachedResponse.data), creationTimestamp = cachedResponse.userInfo?["creationTimestamp"] as? CFTimeInterval where (NSDate.timeIntervalSinceReferenceDate() - creationTimestamp) < Double(cacheManager.diskCacheMaxAge) {
            
            cacheManager[URLString] = image
            self.image = image
        } else {
            sharedURLCache.removeCachedResponseForRequest(request)
            let tableView: UITableView
            let collectionView: UICollectionView
            var tableViewCell: UITableViewCell?
            var collectionViewCell: UICollectionViewCell?
            var parentView = self.superview
            
            while parentView != nil {
                if let view = parentView as? UITableViewCell {
                    tableViewCell = view
                } else if let view = parentView as? UITableView {
                    tableView = view
                    
                    if let cell = tableViewCell {
                        let indexPath = tableView.indexPathForRowAtPoint(cell.center)
                        indexPathIdentifier = indexPath?.hashValue ?? -1
                    }
                    break
                } else if let view = parentView as? UICollectionViewCell {
                    collectionViewCell = view
                } else if let view = parentView as? UICollectionView {
                    collectionView = view
                    
                    if let cell = collectionViewCell {
                        let indexPath = collectionView.indexPathForItemAtPoint(cell.center)
                        indexPathIdentifier = indexPath?.hashValue ?? -1
                    }
                    break
                }
                
                parentView = parentView?.superview
            }
            
            let initialIndexIdentifier = indexPathIdentifier
            
            if cacheManager.isDownloadingFromURL(URLString) {
                weak var weakSelf = self
                cacheManager.addImageCacheObserver(weakSelf!, withInitialIndexIdentifier: initialIndexIdentifier, forKey: URLString)
            } else {
                cacheManager.setIsDownloadingFromURL(true, forURLString: URLString)
                
                let dataTask = cacheManager.session.dataTaskWithRequest(request) {
                    (taskData: NSData?, taskResponse: NSURLResponse?, taskError: NSError?) in
                    
                    guard let data = taskData, response = taskResponse, image = UIImage(data: data) where taskError == nil else {
                        cacheManager.setIsDownloadingFromURL(false, forURLString: URLString)
                        cacheManager.removeImageCacheObserversForKey(URLString)
                        return
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        if initialIndexIdentifier == self.indexPathIdentifier {
                            self.image = image
                        }
                        
                        cacheManager[URLString] = image
                        
                        let responseDataIsCacheable = cacheManager.diskCacheMaxAge > 0 &&
                            Double(data.length) <= 0.05 * Double(sharedURLCache.diskCapacity) &&
                            (cacheManager.session.configuration.requestCachePolicy == .ReturnCacheDataElseLoad ||
                                cacheManager.session.configuration.requestCachePolicy == .ReturnCacheDataDontLoad) &&
                            (request.cachePolicy == .ReturnCacheDataElseLoad ||
                                request.cachePolicy == .ReturnCacheDataDontLoad)
                        
                        if let httpResponse = response as? NSHTTPURLResponse, url = httpResponse.URL where responseDataIsCacheable {
                            if var allHeaderFields = httpResponse.allHeaderFields as? [String: String] {
                                allHeaderFields["Cache-Control"] = "max-age=\(cacheManager.diskCacheMaxAge)"
                                if let cacheControlResponse = NSHTTPURLResponse(URL: url, statusCode: httpResponse.statusCode, HTTPVersion: "HTTP/1.1", headerFields: allHeaderFields) {
                                    let cachedResponse = NSCachedURLResponse(response: cacheControlResponse, data: data, userInfo: ["creationTimestamp": NSDate.timeIntervalSinceReferenceDate()], storagePolicy: .Allowed)
                                    sharedURLCache.storeCachedResponse(cachedResponse, forRequest: request)
                                }
                            }
                        }
                    }
                }
                
                dataTask.resume()
            }
        }
    }
}

internal class ImageCacheManager {
    // MARK: - Properties
    private struct ImageCacheKeys {
        static let img = "img"
        static let isDownloading = "isDownloading"
        static let observerMapping = "observerMapping"
    }
    
    static let sharedInstance = ImageCacheManager()
    
    // {"url": {"img": UIImage, "isDownloading": Bool, "observerMapping": {Observer: Int}}}
    private var imageCache = [String: [String: AnyObject]]()
    
    lazy var session: NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = .ReturnCacheDataElseLoad
        configuration.URLCache = .sharedURLCache()
        return NSURLSession(configuration: configuration)
    }()
    
    internal var diskCacheMaxAge: UInt = 60 * 60 * 24 * 7 {
        willSet {
            if newValue == 0 {
                NSURLCache.sharedURLCache().removeAllCachedResponses()
            }
        }
    }
    
    internal var timeoutIntervalForRequest: NSTimeInterval = 60.0 {
        willSet {
            let configuration = self.session.configuration
            configuration.timeoutIntervalForRequest = newValue
            self.session = NSURLSession(configuration: configuration)
        }
    }
    
    internal var requestCachePolicy: NSURLRequestCachePolicy = .ReturnCacheDataElseLoad {
        willSet {
            let configuration = self.session.configuration
            configuration.requestCachePolicy = newValue
            self.session = NSURLSession(configuration: configuration)
        }
    }
    
    private init() {
        // Initialize the disk cache capacity to 50 MB.
        let diskURLCache = NSURLCache(memoryCapacity: 0, diskCapacity: 50 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(diskURLCache)
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidReceiveMemoryWarningNotification, object: nil, queue: NSOperationQueue.mainQueue()) {
            _ in
            self.imageCache.removeAll(keepCapacity: false)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Image Cache Subscripting
    subscript (key: String) -> UIImage? {
        get {
            return imageCacheEntryForKey(key)[ImageCacheKeys.img] as? UIImage
        }
        set {
            if let image = newValue {
                var imageCacheEntry = imageCacheEntryForKey(key)
                imageCacheEntry[ImageCacheKeys.img] = image
                setImageCacheEntry(imageCacheEntry, forKey: key)
                
                if let observerMapping = imageCacheEntry[ImageCacheKeys.observerMapping] as? [NSObject: Int] {
                    for (observer, initialIndexIdentifier) in observerMapping {
                        switch observer {
                        case let imageView as UIImageView:
                            loadObserverAsImageView(imageView, forImage: image, withInitialIndexIdentifier: initialIndexIdentifier)
                        default:
                            break
                        }
                    }
                    
                    removeImageCacheObserversForKey(key)
                }
            }
        }
    }
    
    // MARK: - Image Cache Methods
    func imageCacheEntryForKey(key: String) -> [String: AnyObject] {
        if let imageCacheEntry = self.imageCache[key] {
            return imageCacheEntry
        }
        else {
            let imageCacheEntry: [String: AnyObject] = [ImageCacheKeys.isDownloading: false, ImageCacheKeys.observerMapping: [NSObject: Int]()]
            self.imageCache[key] = imageCacheEntry
            return imageCacheEntry
        }
    }
    
    func setImageCacheEntry(imageCacheEntry: [String: AnyObject], forKey key: String) {
        self.imageCache[key] = imageCacheEntry
    }
    
    func isDownloadingFromURL(urlString: String) -> Bool {
        let isDownloading = imageCacheEntryForKey(urlString)[ImageCacheKeys.isDownloading] as? Bool
        
        return isDownloading ?? false
    }
    
    func setIsDownloadingFromURL(isDownloading: Bool, forURLString urlString: String) {
        var imageCacheEntry = imageCacheEntryForKey(urlString)
        imageCacheEntry[ImageCacheKeys.isDownloading] = isDownloading
        setImageCacheEntry(imageCacheEntry, forKey: urlString)
    }
    
    func addImageCacheObserver(observer: NSObject, withInitialIndexIdentifier initialIndexIdentifier: Int, forKey key: String) {
        var imageCacheEntry = imageCacheEntryForKey(key)
        if var observerMapping = imageCacheEntry[ImageCacheKeys.observerMapping] as? [NSObject: Int] {
            observerMapping[observer] = initialIndexIdentifier
            imageCacheEntry[ImageCacheKeys.observerMapping] = observerMapping
            setImageCacheEntry(imageCacheEntry, forKey: key)
        }
    }
    
    func removeImageCacheObserversForKey(key: String) {
        var imageCacheEntry = imageCacheEntryForKey(key)
        if var observerMapping = imageCacheEntry[ImageCacheKeys.observerMapping] as? [NSObject: Int] {
            observerMapping.removeAll(keepCapacity: false)
            imageCacheEntry[ImageCacheKeys.observerMapping] = observerMapping
            setImageCacheEntry(imageCacheEntry, forKey: key)
        }
    }
    
    // MARK: - Observer Methods
    func loadObserverAsImageView(observer: UIImageView, forImage image: UIImage, withInitialIndexIdentifier initialIndexIdentifier: Int) {
        if initialIndexIdentifier == observer.indexPathIdentifier {
            dispatch_async(dispatch_get_main_queue()) {
                observer.image = image
            }
        }
    }
    
}