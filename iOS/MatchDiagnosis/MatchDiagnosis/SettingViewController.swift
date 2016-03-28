//
//  SettingViewController.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/10/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import RealmSwift

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var lastTouchCellIndex :Int = 0
    
    let identifier: String = "UserTableViewCell"
    var userNames: Results<User>?
    let sectionTitle = ["男子","女子"]
    let manager = UserManager()
    var checkUser :[[Int]] = [[], []]

    @IBOutlet weak var sugestView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib  = UINib(nibName: identifier, bundle:nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier:identifier)
        
        self.tableView.separatorColor = UIColor.clearColor()
        
        
        let titleImage = UIImageView.init(image: UIImage.init(named: "HeaderIcon"))
        self.navigationItem.titleView = titleImage
        
        setHeaderButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        sendPV()
    }

    override func viewWillAppear(animated: Bool) {
        userNames = manager.allFriends()
        
        if (userNames?.count > 0) {
            sugestView.hidden = true
        }else {
            sugestView.hidden = false
        }
        
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
        let user = usersInSection?[indexPath.row]
        cell!.userName!.text = user!.name
        cell!.userName.setTextColor(Sex(rawValue: user!.sex)!)
//        
//        let checkId = checkUser[indexPath.section][indexPath.row]
//        
//        if checkId == user!.id {
//           cell!.isChecked = true
//        }else {
//            cell!.isChecked = false
//        }
//        cell?.setImage()
//        cell?.delegate = self
        
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
    
//    func checkBoxTapped(cell: UserTableViewCell , isChecked :Bool) {
//        let indexPath = tableView.indexPathForCell(cell)
//        let usersInSection = userNames?.filter("sex = \(indexPath!.section)")
//        
//        
//        if isChecked { //チェックつけた時
//            checkUser[(indexPath?.section)!] += [(usersInSection?[indexPath!.row].id)!]
//        }else { //チェック外した時
//            let id = (usersInSection?[indexPath!.row].id)!
//            var i = 0
//            for check_id :Int in checkUser[(indexPath?.section)!] {
//                if check_id == id {
//                    break
//                }
//                i++
//            }
//            checkUser[(indexPath?.section)!].removeAtIndex(i)
//        }
//    }
   
    func setHeaderButton () {
        let backButton :UIButton = UIButton(frame: CGRectMake(0, 0, 80, 20))
        backButton.setTitle("スタート", forState: .Normal)
        backButton.addTarget(self, action: Selector("startButtonTapped"), forControlEvents: .TouchUpInside)
        let bckButtonItem :UIBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = bckButtonItem
    }
    
    private func sendPV() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "ユーザ登録画面")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func startButtonTapped () {
        for i in 0...1 {
            let usersInSection = userNames?.filter("sex = \(i)")
            if usersInSection!.count == 0 {
                showAlertView("男女一人づつは選択してください。")
                return
            }
        }
        
        let manager = EventManager()
        let event_id = manager.eventNum()
        let pc = SelectViewController(nibName: "SelectViewController", bundle: nil)
        pc.masterUserNames = userNames
        pc.event_id = event_id
        self.navigationController?.pushViewController(pc, animated: true)
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
    
//    func checkUserObjectWithCheckUser () -> Results<User>?{
//        
//        var query = "id = "
//        
//        for i in 0...1 {
//            if checkUser[i].count == 0 {
//                return nil
//            }
//            for id :Int in checkUser[i]{
//                query += "\(id) OR id = "
//            }
//            print(query)
//        }
//        print(query.substringToIndex(query.endIndex.advancedBy(-9)))
//        query = query.substringToIndex(query.endIndex.advancedBy(-9))
//        
//        let users = userNames?.filter(query)
//
//        return users!;
//    }
    
    func showAlertView (message :String) {
        let title = "ユーザ登録エラー"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let noAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(noAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

}
