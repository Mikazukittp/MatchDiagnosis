//
//  SettingViewController.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/10/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import RealmSwift

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UserTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var lastTouchCellIndex :Int = 0
    
    let identifier: String = "UserTableViewCell"
    var userNames: Results<User>?
    let sectionTitle = ["Man","Woman"]
    let manager = UserManager()
    var checkUser :[[Int]] = [[], []]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib  = UINib(nibName: identifier, bundle:nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier:identifier)
        
        self.tableView.separatorColor = UIColor.clearColor()
        
        setHeaderButton()
        
    }
    override func viewWillAppear(animated: Bool) {
        userNames = manager.allFriends()
        checkUser = [[],[]]
        
        tableView.reloadData()
    }
    
    @IBAction func registWomanTapped(sender: AnyObject) {
        presentVC("", userSex: Sex.Woman)
    }
    @IBAction func registMenTapped(sender: AnyObject) {
        presentVC("", userSex: Sex.Man)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UserTableViewCell
        
        if cell == nil {
            cell = UserTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        }
        let usersInSection = userNames?.filter("sex = \(indexPath.section)")
        cell!.userName!.text = usersInSection?[indexPath.row].name
        cell!.resetCheckBox()
        cell?.delegate = self
        
        return cell!
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (userNames?.filter("sex = \(section)").count)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 78.0
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        lastTouchCellIndex = indexPath.row
        let usersInSection = userNames?.filter("sex = \(indexPath.section)")

        changeUserInfoController((usersInSection?[indexPath.row])!)
    }
    
    func checkBoxTapped(cell: UserTableViewCell , isChecked :Bool) {
        let indexPath = tableView.indexPathForCell(cell)
        let usersInSection = userNames?.filter("sex = \(indexPath!.section)")
        
        
        if isChecked { //チェックつけた時
            checkUser[(indexPath?.section)!] += [(usersInSection?[indexPath!.row].id)!]
        }else { //チェック外した時
            let id = (usersInSection?[indexPath!.row].id)!
            var i = 0
            for check_id :Int in checkUser[(indexPath?.section)!] {
                if check_id == id {
                    break
                }
                i++
            }
            checkUser[(indexPath?.section)!].removeAtIndex(i)
        }
    }
   
    func setHeaderButton () {
        let backButton :UIButton = UIButton(frame: CGRectMake(0, 0, 60, 20))
        backButton.setTitle("START", forState: .Normal)
        backButton.addTarget(self, action: Selector("startButtonTapped"), forControlEvents: .TouchUpInside)
        let bckButtonItem :UIBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = bckButtonItem
    }
    
    func startButtonTapped () {
        let users =  checkUserObjectWithCheckUser()
        
        if users?.count > 0 {
            let manager = EventManager()
            let event_id = manager.eventNum()
            
            let pc = SelectViewController(nibName: "SelectViewController", bundle: nil)
            pc.masterUserNames = users
            pc.event_id = event_id
            self.navigationController?.pushViewController(pc, animated: true)
        } else {
            showAlertView("男女一人づつは選択してください。")

        }
    }
    
    func presentVC (userName :String? ,userSex :Sex?) {
        let vc = NewUserViewController(nibName: "NewUserViewController", bundle: nil)
        vc.userSex = userSex!
        
        let nc = UINavigationController(rootViewController: vc)
        
        self.presentViewController(nc, animated: true) { () -> Void in
            
        }
    }
    
    func changeUserInfoController (user :User) {
        let vc = NewUserViewController(nibName: "NewUserViewController", bundle: nil)
        vc.user = user
        vc.userSex = Sex(rawValue: user.sex)!
        vc.userName = user.name
        
        let nc = UINavigationController(rootViewController: vc)
        
        self.presentViewController(nc, animated: true) { () -> Void in
            
        }
    }
    
    func checkUserObjectWithCheckUser () -> Results<User>?{
        
        var query = "id = "
        
        for i in 0...1 {
            if checkUser[i].count == 0 {
                print("男女一人づつは選択してください。")
                return nil
            }
            for id :Int in checkUser[i]{
                query += "\(id) OR id = "
            }
            print(query)
        }
        print(query.substringToIndex(query.endIndex.advancedBy(-9)))
        query = query.substringToIndex(query.endIndex.advancedBy(-9))
        
        let users = userNames?.filter(query)

        return users!;
    }
    
    func showAlertView (message :String) {
        let title = "ユーザ登録エラー"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let noAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(noAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

}
