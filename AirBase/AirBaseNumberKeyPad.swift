//
//  AirBaseNumberKeyPad.swift
//  AirBase
//
//  Created by Sai Prasad on 26/06/24.
//

import Foundation
import UIKit

class AirBaseNumberKeyPad: UIView {
    
    private let numProp = AirBaseNumProp.shared
    private let deleteButton = UIButton()
    var numStr = String()
    weak var delegate: AirBaseInputViewDelegate?
    
    
    init() {
        super.init(frame: .zero)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        self.backgroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
        
        let numpadOriginX: CGFloat = 50
        let numpadOriginY: CGFloat = 20
        
        for i in 0..<12 {
            if (i == 9) {
                let button = UIButton()
                button.frame = CGRect(x: numpadOriginX + (numProp.buttonGap + numProp.buttonSize) * CGFloat(i % 3), y: numpadOriginY + (numProp.buttonGap + numProp.buttonSize) * CGFloat(i / 3), width: numProp.buttonSize, height: numProp.buttonHeight)
                button.setTitle(".", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                self.addSubview(button)
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
            else if (i == 11) {
                let button = UIButton()
                button.frame = CGRect(x: numpadOriginX + (numProp.buttonGap + numProp.buttonSize) * CGFloat(i % 3), y: numpadOriginY + (numProp.buttonGap + numProp.buttonSize) * CGFloat(i / 3), width: numProp.buttonSize, height: numProp.buttonHeight)
                self.addSubview(button)
                button.setImage(UIImage(named: "back"), for: .normal)
                button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
            }
            else {
                let button = UIButton()
                button.frame = CGRect(x: numpadOriginX + (numProp.buttonGap + numProp.buttonSize) * CGFloat(i % 3), y: numpadOriginY + (numProp.buttonGap + numProp.buttonSize) * CGFloat(i / 3), width: numProp.buttonSize, height: numProp.buttonHeight)
                self.addSubview(button)
                button.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 24)
                button.titleLabel?.textColor = AirBaseBgColors.shared.whiteColor
                if i == 10 {
                    button.setTitle(String(0), for: .normal)
                }
                else {
                    button.setTitle(String(i+1), for: .normal)
                }
                button.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
            }
        }
    }
    
    @objc private func buttonPressed(button: UIButton) {
        if button.titleLabel?.text != nil {
            if numStr.isEmpty && button.titleLabel?.text == "0" {
                return
            }
            numStr += button.titleLabel?.text ?? "1"
            delegate?.textInputView(text: numStr)
        }
    }
    
    @objc private func deleteButtonPressed() {
        if numStr.count == 0 {
            return
        }
        numStr = numStr.substring(to: numStr.index(numStr.startIndex, offsetBy: numStr.count - 1))
        delegate?.deleteButtonPressed(text: numStr)
    }
}

class AirBaseNumProp {
    
    let buttonSize: CGFloat = 68
    let buttonHeight: CGFloat = 48
    let buttonGap: CGFloat = 45
    
    static let shared = AirBaseNumProp()
}
