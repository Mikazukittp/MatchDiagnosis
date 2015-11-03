
//
//  RoundLabel.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/11/03.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class RoundLabel: UILabel {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.width / 2;
        self.clipsToBounds = true;
    }
}
