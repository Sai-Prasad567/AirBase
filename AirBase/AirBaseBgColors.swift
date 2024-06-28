//
//  AirBaseBgColors.swift
//  AirBase
//
//  Created by Sai Prasad on 24/06/24.
//

import UIKit

class AirBaseBgColors {
    
    static let shared = AirBaseBgColors()
    
    var bGColorW_bGColorD : UIColor
    var blueColor : UIColor
    var whiteColor : UIColor
    init() {
        bGColorW_bGColorD = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0)
        blueColor = UIColor(red: 17 / 255.0, green: 81 / 255.0, blue: 231 / 255.0, alpha: 1.0)
        whiteColor = UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        self.darkModeColors()
    }
    
    func darkModeColors() {
        if #available(iOS 11, *) {
            bGColorW_bGColorD = ZSAppearanceAssetColor.initNamed(name: "bGColorW_bGColorD") ?? bGColorW_bGColorD
            blueColor = ZSAppearanceAssetColor.initNamed(name: "blueColor") ?? blueColor
            whiteColor = ZSAppearanceAssetColor.initNamed(name: "whiteColor") ?? whiteColor
        }
    }
}
