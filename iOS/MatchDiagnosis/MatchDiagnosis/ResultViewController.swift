//
//  ResultViewController.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/10/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    var event_id :Int!
    let manager = EventManager()
    
    @IBOutlet weak var coupleNumLabel: RoundLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Naviagationbar潜り込み防止
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        coupleNum()
        
    }
    
    @IBAction func topButtonTapped(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func coupleNum () {
        manager.event_id = self.event_id
        let num = manager.coupleNum()
        coupleNumLabel.text = "\(num)"
    }

}
