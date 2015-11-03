
//
//  SexLabel.swift
//  MatchDiagnosis
//
//  Created by 石部達也 on 2015/11/03.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class SexLabel: UILabel {

    func setTextColor (sex :Sex) {
        switch sex {
        case .Man:
            setBoyColor()
        case .Woman:
            setGirlColor()
        }
    }
    
    func setGirlColor () {
        self.textColor = UIColor(red: 0.957, green: 0.553, blue: 0.592, alpha: 1.0)
    }
    
    func setBoyColor () {
        self.textColor = UIColor(red: 0.443, green: 0.769, blue: 0.784, alpha: 1.0)

    }

}
