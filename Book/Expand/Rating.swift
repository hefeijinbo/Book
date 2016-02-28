//
//  Rating.swift
//  Book
//
//  Created by 金波 on 15/12/29.
//  Copyright © 2015年 jikexueyuan. All rights reserved.
//

import UIKit

struct Rating {
    
    let KeyAverage = "average"
    let KeyMax = "max"
    let KeyMin = "min"
    let KeyNumRaters = "numRaters"

    var average = 0.0
    var max = 10.0
    var min = 0.0
    var numRaters = 19.0
    
    init(dict:[String:NSObject]) {
        min = dict[KeyMin] as? Double ?? 0.0
        numRaters = dict[KeyNumRaters] as? Double ?? 0.0
        max = dict[KeyMax] as? Double ?? 5.0
        let ratio = 5 / max
        max = 5.0
        
        average = Double(dict[KeyAverage] as? String ?? "") ?? 0.0
        average = average * ratio
    }
    
    init() {
        
    }
}
