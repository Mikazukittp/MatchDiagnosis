//
//  SelectViewController.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/10/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import RealmSwift


class SelectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    
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

        //回答用のユーザたち
        selectUserNames = masterUserNames?.filter("sex = \(selectUserSex)")
        userName.text = plyer?.name
        
        let nib  = UINib(nibName: identifier, bundle:nil)
        tableView.registerNib(nib, forCellReuseIdentifier:identifier)
        tableView.separatorColor = UIColor.clearColor()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UserTableViewCell
        
        if cell == nil {
            cell = UserTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        }
        
        cell!.userName!.text = selectUserNames[indexPath.row].name
        cell!.setHiddenCheckBox()
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
        
        let title = "\(userName.text!)さんでよろしいですか？"
        let message = "\(likePeople)が好きなのですね？"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: {
            (action:UIAlertAction!) -> Void in
            
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
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                
        })

        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }


}
