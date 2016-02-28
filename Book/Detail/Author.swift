//
//  Author.swift
//  DouBan
//
//  Created by Admin on 15/3/16.
//  Copyright (c) 2015年 jinbo. All rights reserved.
//

import UIKit

//图书作者信息
class Author: NSObject {
    
    var alt = ""
    var avatar = ""
    var id = 0
    var is_banned = false
    var is_suicide = false
    var large_avatar = ""
    var name = ""
    var type = ""
    var uid = ""
    var url = ""
    
    init(dict:[String:AnyObject]) {
        alt = dict["alt"] as? String ?? ""
        avatar = dict["avatar"] as? String ?? ""
        id = dict["id"] as? Int ?? 0
        is_banned = (dict["is_banned"] as? Int ?? 0) == 1
        is_suicide = [dict["is_suicide"] as? Int ?? 0] == 1
        large_avatar = dict["large_avatar"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        type = dict["type"] as? String ?? ""
        uid = dict["uid"] as? String ?? ""
        url = dict["url"] as? String ?? ""
    }
    
    override init() {
        
    }
    
}
