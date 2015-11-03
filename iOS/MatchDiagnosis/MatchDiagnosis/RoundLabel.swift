
//
//  RoundLabel.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/11/03.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class RoundLabel: SexLabel {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.width / 2;
        self.clipsToBounds = true;
        self.layer.borderColor = UIColor(red: 0.875, green: 0.882, blue: 0.890, alpha: 1.0).CGColor
        self.layer.borderWidth = 3
    }
    
}
