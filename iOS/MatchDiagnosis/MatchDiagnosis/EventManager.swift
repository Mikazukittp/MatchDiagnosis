//
//  EventManager.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/11/03.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import RealmSwift

class EventManager: NSObject {
    
    var event_id = 1
    var couple_num = 0

    func add (user_id :Int , like_id :Int, complition :(error :Bool) ->Void) {
        let realm =  try! Realm()
        // 文字列で検索条件を指定します
        let relation = realm.objects(Event).filter("user_id = \(user_id) AND event_id = \(event_id) AND like_id = \(like_id)")
        
        if relation.count == 0 {
            
            let max = realm.objects(Event).sorted("id",ascending:false)
            var id = 1
            if max.isEmpty == false {
                id = max[0].id + 1
            }
            
            //Realmに保存
            let event = Event()
            event.id = id
            event.user_id = user_id
            event.like_id = like_id
            event.event_id = event_id
            
            let realm =  try! Realm()
            try! realm.write {
                realm.add(event)
                complition(error: false)
            }
        }else {
            complition(error: true)
        }
    }
    
    func eventNum () -> Int{
        let realm = try! Realm()
        let event = realm.objects(Event).sorted("event_id", ascending: false)
        if event.isEmpty == false {
            return event[0].event_id + 1
        }
        return event_id
    }
    
    func allEvents (event_id :Int) -> Results<Event> {
        return  try! Realm().objects(Event).filter("event_id = \(event_id)")
    }
    
    func coupleNum () -> Int{
        let events = allEvents(self.event_id)
        
        for myEvent :Event in events {
            let likeUserDetail = events.filter("user_id = \(myEvent.like_id)")[0]
            if myEvent.user_id == likeUserDetail.like_id {
                couple_num++
            }
        }
        
        return couple_num / 2
    }
    
}
