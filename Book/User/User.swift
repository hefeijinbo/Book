//
//  User.swift
//  DouBan
//
//  Created by Admin on 15/2/27.
//  Copyright (c) 2015年 jinbo. All rights reserved.
//

import UIKit


class User: NSObject,NSCoding {
    
    let KeyExpires_time = "expires_in"
    let KeyAccess_token = "access_token"
    let KeyDouban_user_name = "douban_user_name"
    let KeyRefresh_token = "refresh_token"
    let KeyDouban_user_id = "douban_user_id"
    
    //User Info key
    let KeyAlt = "alt";//个人主页
    let KeyAvatar = "avatar"
    let KeyCreated = "created"
    let KeyDesc = "desc";
    let KeyId = "id"
    let KeyIs_banned = "is_banned"
    let KeyIs_suicide = "is_suicide"
    let KeyLarge_avatar = "large_avatar"
    let KeyLoc_id = "loc_id"
    let KeyLoc_name = "loc_name"
    let KeyName = "name"
    let KeySignature = "signature"
    let KeyType = "type"
    let KeyUid = "uid"
    
    //单例
    static let sharedUser = NSKeyedUnarchiver.unarchiveObjectWithFile(DocumentPath + "/user") as? User ?? User()
    
    //相对于1970年的过期日期
    var expires_time = 0.0
    var access_token = ""
    var douban_user_name = ""
    var refresh_token = ""
    var douban_user_id = "" {
        didSet {
            NetManager.updateUserInfo()
        }
    }
    
    //User Info 
    var alt = "";
    var avatar = "";
    var created = ""
    var desc = ""
    var is_banned = 0
    var is_suicide = 0;
    var large_avatar = ""
    var loc_id = 0;
    var loc_name = "";
    var name = "";
    var signature = "";
    var type = "";

    func updateUserInfoWithDict(dict:[String:NSObject]) {
        alt = dict[KeyAlt] as? String ?? "";//个人主页
        avatar = dict[KeyAvatar] as? String ?? ""
        created = dict[KeyCreated] as? String ?? ""
        desc = dict[KeyDesc] as? String ?? ""
        is_banned = dict[KeyIs_banned] as? Int ?? 0
        is_suicide = dict[KeyIs_suicide] as? Int ?? 0
        large_avatar = dict[KeyLarge_avatar] as? String ?? ""
        loc_id = dict[KeyLoc_id] as? Int ?? 0
        loc_name = dict[KeyLoc_name] as? String ?? ""
        name = dict[KeyName] as? String ?? ""
        signature = dict[KeySignature] as? String ?? ""
        type = dict[KeyType] as? String ?? ""
    }
    
    var isLogin:Bool {
        if !access_token.isEmpty && expires_time > NSDate().timeIntervalSince1970 {
            return true
        } else {
            return false
        }
    }
    
    func loginWithDict(dict:[String:NSObject]) {
        if let expires_in = dict[KeyExpires_time] as? Double {
            expires_time = NSDate().timeIntervalSince1970 + expires_in
        }
        access_token = dict[KeyAccess_token] as? String ?? ""
        douban_user_name = dict[KeyDouban_user_name] as? String ?? ""
        refresh_token = dict[KeyRefresh_token] as? String ?? ""
        douban_user_id = dict[KeyDouban_user_id] as? String ?? ""
        NSKeyedArchiver.archiveRootObject(self, toFile: DocumentPath + "/user")
    }
    
    func logout() {
        expires_time = 0.0
        access_token = ""
        douban_user_name = ""
        refresh_token = ""
        douban_user_id = ""
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(expires_time, forKey: KeyExpires_time)
        aCoder.encodeObject(access_token, forKey: KeyAccess_token)
        aCoder.encodeObject(douban_user_name, forKey: KeyDouban_user_name)
        aCoder.encodeObject(refresh_token, forKey: KeyRefresh_token)
        aCoder.encodeObject(douban_user_id, forKey: KeyDouban_user_id)
    }
    
    required init?(coder aDecoder: NSCoder) {
        expires_time = aDecoder.decodeObjectForKey(KeyExpires_time) as? Double ?? 0.0
        access_token = aDecoder.decodeObjectForKey(KeyAccess_token) as? String ?? ""
        douban_user_name = aDecoder.decodeObjectForKey(KeyDouban_user_name) as? String ?? ""
        refresh_token = aDecoder.decodeObjectForKey(KeyRefresh_token) as? String ?? ""
        douban_user_id = aDecoder.decodeObjectForKey(KeyDouban_user_id) as? String ?? ""
    }

    override init() {
        super.init()
    }
}
