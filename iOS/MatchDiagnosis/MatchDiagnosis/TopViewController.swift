//
//  TopViewController.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/11/03.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import SCLAlertView

class TopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
