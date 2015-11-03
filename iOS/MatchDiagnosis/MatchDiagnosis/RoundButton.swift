//
//  RoundButton.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/10/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.width / 2;
        self.clipsToBounds = true;
    }
}
