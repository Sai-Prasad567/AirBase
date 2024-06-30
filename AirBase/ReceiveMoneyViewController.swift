//
//  ReceiveMoneyViewController.swift
//  AirBase
//
//  Created by Sai Prasad on 22/06/24.
//

import UIKit

class ReceiveMoneyViewController: UIViewController, AirBaseTransactionUpdates {
    
    weak var delegate: AirBaseNearbyDelegates?
    let connectedString = "Connected To "
    let connectingString = "Waiting for sender to connect..."
    var isConnecting : Bool = false
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 28)
        label.textColor = AirBaseBgColors.shared.whiteColor
        label.text = connectingString
        return label
    }()
    
    lazy var transactionID: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 28)
        label.textColor = AirBaseBgColors.shared.whiteColor
        return label
    }()
    
    lazy var transactionAmount: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 35)
        label.textColor = AirBaseBgColors.shared.blueColor
        return label
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        var image = UIImage.init(named: "back")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            image = image?.imageFlippedForRightToLeftLayoutDirection()
        }
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonPressed))
        self.view.backgroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
        self.setAllViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAllViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(transactionID)
        self.view.addSubview(transactionAmount)
        
        headerLabel.addConstraint(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0),centerX: view.centerXAnchor)
        
        transactionAmount.addConstraint(top: headerLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0),centerX: view.centerXAnchor)
        
        let size = connectingString.getSizeOfatributedString(neededFont: headerLabel.font)
        headerLabel.frame.size = size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Receive Money"
        let attrs = [
            NSAttributedString.Key.foregroundColor: AirBaseBgColors.shared.whiteColor,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
    }
    
    @objc func backButtonPressed(){
        delegate?.stopAdvertiser()
        self.navigationController?.popViewController(animated: true)
    }
    
    func setTransactionId(_ id: String) {
        transactionAmount.text = "$1"
        headerLabel.text = "Received amount from Sai"
    }
}
