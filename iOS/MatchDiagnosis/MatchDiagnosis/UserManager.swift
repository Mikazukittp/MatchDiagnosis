//
//  UserManager.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/11/01.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import RealmSwift

class UserManager: NSObject {
    
    func add (name :String ,sex :Int , complition :(error :Bool) ->Void) {
        let realm =  try! Realm()
        // 文字列で検索条件を指定します
        let myFriend = realm.objects(User).filter("name = '\(name)' AND sex = \(sex)")
        
        if myFriend.count == 0 {
            
            let max = realm.objects(User).sorted("id",ascending:false)
            var user_id = 1
            if max.isEmpty == false {
                user_id = max[0].id + 1
            }
            
            //Realmに保存
            let friend = User()
            friend.id = user_id
            friend.name = name
            friend.sex = sex
            
            let realm =  try! Realm()
            try! realm.write {
                realm.add(friend)
                complition(error: false)
            }
        }else {
            complition(error: true)       
        }
    }
    
    func allFriends () -> Results<User> {
        return  try! Realm().objects(User)
    }
    
    func reload (user :User , complition :(error :Bool) ->Void) {
        let realm =  try! Realm()
        let myFriend = realm.objects(User).filter("id = \(user.id)")
       
        if myFriend.count > 0 {

            let friend = myFriend[0] as User
            friend.name = user.name
            
            let realm =  try! Realm()
            try! realm.write {
                realm.add(friend)
                complition(error: false)
            }
        }else {
            complition(error: true)
        }
    }
    
    func deleteUser (user :User, complition :(error :Bool) ->Void) {
        let realm = try! Realm()
        
        let deleteUser = realm.objects(User).filter("id = \(user.id)")

        if deleteUser.count > 0 {
            try! realm.write {
                realm.delete(deleteUser)
                complition(error: false)
            }
        }else {
            complition(error: true)
        }
    }
}
