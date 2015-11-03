//
//  Event.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/11/03.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import RealmSwift

class Event: Object {
    dynamic var id = 0
    dynamic var event_id = 0
    dynamic var user_id = 0
    dynamic var like_id = 0
    
    //primary keyに設定します
    override static func primaryKey() -> String? {
        return "id"
    }
}
