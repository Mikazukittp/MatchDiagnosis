//
//  UserTableViewCell.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/10/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

protocol UserTableViewCellDelegate{
    func checkBoxTapped(cell: UserTableViewCell, isChecked: Bool)
}

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var userName: SexLabel!
    
    var isChecked = false
    var delegate: UserTableViewCellDelegate! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setHiddenCheckBox () {
        checkBox.hidden = true
    }
    
    func resetCheckBox () {
        let defaultImage = UIImage(named: "blank_box")!
        isChecked = false
        checkBox.setImage(defaultImage, forState: .Normal)
    }

    @IBAction func checkButtonTapped(sender: AnyObject) {
        var defaultImage: UIImage
        
        if isChecked {
            defaultImage = UIImage(named: "blank_box")!
            isChecked = false
        }else {
            defaultImage = UIImage(named: "check_box")!
            isChecked = true
        }
        
        checkBox.setImage(defaultImage, forState: .Normal)
        delegate.checkBoxTapped(self , isChecked: isChecked)
    }
}
