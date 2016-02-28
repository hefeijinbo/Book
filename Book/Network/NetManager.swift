//
//  NetManager.swift
//  Book
//
//  Created by 金波 on 15/12/25.
//  Copyright © 2015年 jikexueyuan. All rights reserved.
//

import UIKit
import AFNetworking

struct NetManager {
    
    struct URLString {
        static let GetBooks = "https://api.douban.com/v2/book/search"
        static let GetUserInfo = "https://api.douban.com/v2/user/"
        static let Login = "https://www.douban.com/service/auth2/token"
    }
    
    static let NotificationUserInfo = "UserInfo"
    
    struct OAuthLogin {
        //应用的唯一标识，对应于APIKey
        static let client_id = "044a3a0984e7ef550cdeae1c8eb7cdff"
        static let client_secret = "eb0d6aeeede176e6"
        //用户授权完成后的回调地址，应用需要通过此回调地址获得用户的授权结果。此地址必须与在应用注册时填写的回调地址一致。
        static let redirect_uri = "https://www.baidu.com"
        static var URLStringGetCode = "https://www.douban.com/service/auth2/auth?client_id=\(client_id)&&redirect_uri=\(redirect_uri)&&response_type=code"
        
        static func loginWithCode(code:String,resultClosure:(Bool) -> Void) {
        NetManager.POST(URLString.Login, parameters: ["client_id":client_id,"client_secret":client_secret,"redirect_uri":redirect_uri,"grant_type":"authorization_code","code":code], success: { (responseObject) -> Void in
                if let dict = responseObject as? [String:NSObject] {
                    User.sharedUser.loginWithDict(dict)
                    resultClosure(true)
                }
            }) { (error) -> Void in
                resultClosure(false)
            }
        }
    }
    
    static func updateUserInfo() {
        GET(URLString.GetUserInfo + User.sharedUser.douban_user_id, parameters: nil, success: { (responseObject) -> Void in
            User.sharedUser.updateUserInfoWithDict(responseObject as? [String:NSObject] ?? [:])
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationUserInfo, object: nil)
        }) { (error) -> Void in
            print(error)
        }
    }
    
    static func getReviewsWithBookId(bookId: String,page:Int,resultClosure:(Bool,[Review]!)->Void) {
        GET("https://api.douban.com/v2/book/\(bookId)/reviews", parameters: ["start":page * 10,"count":10], success: { (responseObject) -> Void in
            var reviews = [Review]()
            if let reviewsArray = (responseObject as? [String:NSObject])?["reviews"] as? [[String:NSObject]] {
                for dict in reviewsArray {
                    reviews.append(Review(dict:dict))
                }
            }
            resultClosure(true,reviews)
        },failure: { (error) -> Void in
            resultClosure(false,nil)
        })
    }

    static func getBooks(tag:String, page:Int,resultClosure:(Bool,[Book]!) -> Void) {
        GET(URLString.GetBooks, parameters: ["tag":tag,"start":page * 10,"count":10], success: { (responseObject) -> Void in
            var books = [Book]()
            if let dict = responseObject as? [String:NSObject],array = dict["books"] as? [[String:NSObject]] {
                for dict in array {
                    books.append(Book(dict: dict))
                }
            }
            resultClosure(true,books)
        }) { (error) -> Void in
            resultClosure(false,nil)
        }
    }
    
    static func getBookTitles(tag:String, page:Int,resultClosure:([String]) -> Void) {
        GET(URLString.GetBooks, parameters: ["tag":tag,"start":0,"count":10,"fields":"title"], success: { (responseObject) -> Void in
            var searchTitles = [String]()
            if let dict = responseObject as? [String:NSObject],array = dict["books"] as? [[String:NSObject]] {
                for dict in array {
                    if let title = dict["title"] as? String {
                        searchTitles.append(title)
                    }
                }
            }
            resultClosure(searchTitles)
        },failure: nil)
    }

    static func GET(URLString:String, parameters:[String:NSObject]?, success:((NSObject?) -> Void)?, failure:((NSError) -> Void)?) {
        let manager = AFHTTPSessionManager()
        manager.GET(URLString, parameters: parameters, success: { (task, responseObject) -> Void in
            success?(responseObject as? NSObject)
        }) { (task, error) -> Void in
            failure?(error)
        }
    }
    
    static func POST(URLString:String, parameters:[String:NSObject]?, success:((NSObject?) -> Void)?, failure:((NSError) -> Void)?) {
        let manager = AFHTTPSessionManager()
        manager.POST(URLString, parameters: parameters, success: { (task, responseObject) -> Void in
            success?(responseObject as? NSObject)
        }) { (task, error) -> Void in
            failure?(error)
        }
    }
}
