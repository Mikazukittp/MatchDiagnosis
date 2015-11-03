//
//  User.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/11/01.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import RealmSwift

class User: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var sex = 0
    dynamic var like_id = 0
    
    //primary keyに設定します
    override static func primaryKey() -> String? {
        return "id"
    }
}
