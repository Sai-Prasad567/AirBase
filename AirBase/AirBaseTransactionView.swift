//
//  AirBaseTransactionView.swift
//  AirBase
//
//  Created by Sai Prasad on 29/06/24.
//

import UIKit

class AirBaseTransactionView: UIViewController {
    
    let successStr = "Successfully sent to "
    let money = "$"
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 24)
        label.textColor = AirBaseBgColors.shared.whiteColor
        return label
    }()
    
    lazy var transactionID: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 24)
        label.textColor = AirBaseBgColors.shared.whiteColor
        return label
    }()
    
    lazy var transactionAmount: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 35)
        label.textColor = AirBaseBgColors.shared.blueColor
        return label
    }()
    
    var sendButt = UIButton()
    
    init(name: String, amount: String) {
        super.init(nibName: nil, bundle: nil)
        headerLabel.text = successStr + name
        transactionAmount.text = money + amount
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(transactionID)
        self.view.addSubview(transactionAmount)
        self.view.addSubview(sendButt)
        
        sendButt.configuration = .bordered()
        sendButt.addTarget(self, action: #selector(doneButton(_:)), for: .touchUpInside)
        sendButt.configuration?.cornerStyle = .capsule
        sendButt.configuration?.title = "Done"
        sendButt.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 1)
        sendButt.configuration?.baseBackgroundColor = AirBaseBgColors.shared.blueColor
        sendButt.configuration?.baseForegroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
        
        headerLabel.addConstraint(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0),centerX: self.view.centerXAnchor)
        
        transactionAmount.addConstraint(top: headerLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0),centerX: self.view.centerXAnchor)
        
        transactionID.addConstraint(top: transactionID.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0),centerX: self.view.centerXAnchor)
        
        sendButt.addConstraint(top: nil, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 30, right: 10), size: CGSize(width: 0, height: 60))
        
        let size = headerLabel.text!.getSizeOfatributedString(neededFont: headerLabel.font)
        headerLabel.frame.size = size
    }
    
    @objc func doneButton(_ button: UIButton) {
        self.dismiss(animated: true)
    }
}
