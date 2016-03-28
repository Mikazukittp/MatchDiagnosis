//
//  ResultViewController.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/10/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import SCLAlertView

class ResultViewController: UIViewController {

    var event_id :Int!
    let manager = EventManager()
    var sumUsers :Int?
    
    @IBOutlet weak var coupleLabel: UILabel!
    @IBOutlet weak var coupleNumLabel: RoundLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Naviagationbar潜り込み防止
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let titleImage = UIImageView.init(image: UIImage.init(named: "HeaderIcon"))
        self.navigationItem.titleView = titleImage
        
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        alertView.addButton("結果を見る", target:self, selector:Selector("coupleNum"))
        alertView.showSuccess("マッチング結果", subTitle: "結果を見ますか？")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        sendPV()
    }
    
    @IBAction func topButtonTapped(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func coupleNum () {
        manager.event_id = self.event_id
        let num = manager.coupleNum()
        coupleNumLabel.text = "\(num)"
        sendEvent("\(sumUsers!)人中\(num)組成立")
    }
    
    private func sendPV() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "結果画面")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    
    private func sendEvent(value :String) {
        let tracker = GAI.sharedInstance().defaultTracker
        let builder = GAIDictionaryBuilder.createEventWithCategory("結果画面", action: value, label: "Result", value: nil)
        tracker.send(builder.build() as [NSObject :AnyObject])
    }


}
