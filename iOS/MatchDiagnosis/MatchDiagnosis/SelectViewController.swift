//
//  SelectViewController.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/10/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import RealmSwift
import SCLAlertView


class SelectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roundIcon: RoundLabel!
    @IBOutlet weak var userName: SexLabel!
    
    var masterUserNames: Results<User>!
    var selectUserNames: Results<User>!
    var plyer :User?
    var event_id :Int!
    
    let identifier: String = "UserTableViewCell"
    var currentUserId = 0

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //回答者のユーザ
        plyer = masterUserNames[currentUserId]
        var selectUserSex = 0
        if plyer?.sex == 0 {
           selectUserSex = 1
        }

        let titleImage = UIImageView.init(image: UIImage.init(named: "HeaderIcon"))
        self.navigationItem.titleView = titleImage
        
        roundIcon.setTextColor(Sex(rawValue: plyer!.sex)!)
        roundIcon.text = plyer!.name.substringToIndex(plyer!.name.startIndex.advancedBy(1))
        
        //回答用のユーザたち
        selectUserNames = masterUserNames?.filter("sex = \(selectUserSex)")
        let userDispStr = "\(plyer!.name)の番です。"
        userName.text = userDispStr
        
        userName.setTextColor(Sex(rawValue: plyer!.sex)!)
        
        let nib  = UINib(nibName: identifier, bundle:nil)
        tableView.registerNib(nib, forCellReuseIdentifier:identifier)
        tableView.separatorColor = UIColor.clearColor()
        
        //Naviagationbar潜り込み防止
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UserTableViewCell
        
        if cell == nil {
            cell = UserTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        }
        let user = selectUserNames[indexPath.row]
        cell!.userName!.text = user.name
        cell!.userName.setTextColor(Sex(rawValue: user.sex)!)

//        cell!.setHiddenCheckBox()
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectUserNames!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 78.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let user = selectUserNames?[indexPath.row]
        setAlertView(user!.name, like_id: user!.id)
    }
    
    func setAlertView (likePeople :String , like_id :Int) {
        
        let message = "本当に\(likePeople)でよろしいですか？"
        
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        alertView.addButton("はい") {
            let manager = EventManager()
            manager.event_id = self.event_id
            
            if self.currentUserId + 1 == self.masterUserNames!.count {
                manager.add((self.plyer?.id)!, like_id: like_id, complition: { (error) -> Void in
                    let pc = ResultViewController(nibName: "ResultViewController", bundle: nil)
                    pc.event_id = self.event_id
                    self.navigationController?.pushViewController(pc, animated: true)
                })
            } else {
                manager.add((self.plyer?.id)!, like_id: like_id, complition: { (error) -> Void in
                    let pc = SelectViewController(nibName: "SelectViewController", bundle: nil)
                    pc.currentUserId = self.currentUserId + 1
                    pc.masterUserNames = self.masterUserNames
                    pc.event_id = self.event_id
                    self.navigationController?.pushViewController(pc, animated: true)
                })
            }
        }
        alertView
        alertView.addButton("いいえ") { () -> Void in
            print("いいえ")
        }
        alertView.showNotice("確認", subTitle: message)
    }
}
