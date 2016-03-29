//
//  TopViewController.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/11/03.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import SCLAlertView
import RealmSwift

class TopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let backButtonItem = UIBarButtonItem(title: "戻る", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        //マッチングを見る方法
        //eventIdが高いものが最新
        //usersとeventのidを比較して解析する
//        let realm = try! Realm()
//        let users = realm.objects(User)
//        print(users)
//        let event = realm.objects(Event)
//        print(event)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    @IBAction func startButtonTapped(sender: AnyObject) {
        
        let vc: UIViewController = SettingViewController(nibName: "SettingViewController", bundle:nil)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(vc, animated: false)
   }

}
