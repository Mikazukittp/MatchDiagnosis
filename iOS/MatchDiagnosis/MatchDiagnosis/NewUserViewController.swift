//
//  NewUserViewController.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/10/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

enum Sex: Int {
    case Man = 0
    case Woman
}

class NewUserViewController: UIViewController , UITextFieldDelegate {
    
    enum Status: Int {
        case New = 0
        case Add
    }
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var deleteButton: RoundButton!
    var userSex :Sex = Sex.Man
    var userName :String?
    var user :User?
    var rightbuttonTitle = "追加"
    var settingStatus = Status.New
    
    let manager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        if (userName?.isEmpty == false) {
            inputField.text = userName!
            rightbuttonTitle = "変更"
            settingStatus = Status.Add
            self.title = "ユーザ設定"
        } else {
            deleteButton.hidden = true
            self.title = "新規登録"
        }
        
        inputField.returnKeyType = UIReturnKeyType.Done
        inputField.delegate = self
        inputField.becomeFirstResponder()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        setHeaderButton()
    }

    func setHeaderButton () {
        let backButton :UIButton = UIButton(frame: CGRectMake(0, 0, 60, 20))
        backButton.setTitle("閉じる", forState: .Normal)
        backButton.addTarget(self, action: Selector("backButtonTapped"), forControlEvents: .TouchUpInside)
        let bckButtonItem :UIBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = bckButtonItem
        
        let AddButton :UIButton = UIButton(frame: CGRectMake(0, 0, 70, 20))
        AddButton.setTitle(rightbuttonTitle, forState: .Normal)
        AddButton.addTarget(self, action: Selector("addButtonTapped"), forControlEvents: .TouchUpInside)
        let AddButtonItem :UIBarButtonItem = UIBarButtonItem(customView: AddButton)
        self.navigationItem.rightBarButtonItem = AddButtonItem
    }
    
    func backButtonTapped () {
        self.rootViewController()
    }
    
    func addButtonTapped () {
        
        if inputField.text?.isEmpty == true {
            self.showAlertView("名前を入力してください")
            return
        }
        
        if self.settingStatus == Status.New {
            
            //新規追加
            manager.add(self.inputField.text!, sex: self.userSex.rawValue, complition: { (error) -> Void in
                
                if error == true {
                    //エラーアラートの表示
                    self.showAlertView("既に登録されている名前です")
                } else {
                    self.rootViewController()
                }
            })
            
        } else {
            
            //名前の変更

            let userStr = inputField.text!
            manager.reload(self.user!, text: userStr, complition: { (error) -> Void in
                if error == true {
                    self.showAlertView("登録されていないユーザです")
                } else {
                    self.rootViewController()
                }
            })
        }
    }
    @IBAction func deleteButtonTapped(sender: AnyObject) {
        //ユーザの削除
        manager.deleteUser(self.user!) { (error) -> Void in
            if error == true {
                self.showAlertView("登録されていないユーザです")
            } else {
                self.rootViewController()
            }
        }
        
    }
    
    func textFieldDidChange(notification:NSNotification){
        
        //ここで文字数を取得して、いい感じに処理します。
        let length = inputField.text!.utf16.count
        
        let maxLength: Int = 20
        
        if (length > maxLength) {
            inputField.text = ""
            inputField.attributedPlaceholder = NSAttributedString(string:"20文字を超えています。",
                attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
            print("20文字を超えています")
            
            return;
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    func showAlertView (message :String) {
        let title = "ユーザ登録エラー"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let noAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(noAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func rootViewController () {
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
}
