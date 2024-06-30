//
//  AirBaseViewController.swift
//  AirBase
//
//  Created by Sai Prasad on 22/06/24.
//

import NearbyConnections
import UIKit

class AirBaseViewController: UIViewController, AirBaseNearbyDelegates, AirBaseShowDevicesDelegates {
    
    var sendButton = UIButton()
    var receiveButton = UIButton()
    var startButton = UIButton()
    var getAddressButton = UIButton()
    var isTrue : Bool = false
    var sendMoneyCtrl: SendMoneyViewController?
    var discover: AirBaseSender?
    var advertiser: AirBaseReceiver?
    var receiveMoneyCtrl: ReceiveMoneyViewController?
    var nearbyDevicesView: AirBaseShowNearbyDevicesView?
    weak var delegate: AirBaseShowDevicesDelegates?
    var coinbaseConnection = AirBaseCoinBaseConnection()
    let welcomeString = "Welcome "
    var userName = ""
    var receiverUserName = ""
    var transactionCompleteView: AirBaseTransactionView?
    
    lazy var addTaskField: AirBaseTextField = {
        let textField = AirBaseTextField()
        textField.placeholder = "Enter Username"
        textField.layer.cornerRadius = 40 / 2
        textField.layer.borderWidth = 1
        textField.layer.borderColor = AirBaseBgColors.shared.blueColor.cgColor
        textField.backgroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
        textField.textColor = AirBaseBgColors.shared.blueColor
        textField.returnKeyType = .done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = AirBaseBgColors.shared.whiteColor
        return label
    }()
    
    lazy var sendLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textColor = AirBaseBgColors.shared.whiteColor
        label.text = "Send"
        return label
    }()
    
    lazy var ReceiveLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textColor = AirBaseBgColors.shared.whiteColor
        label.text = "Receive"
        return label
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.setButtonViews()
        self.setAllViews()
        self.navigationItem.title = "AirBase"
        let attrs = [
            NSAttributedString.Key.foregroundColor: AirBaseBgColors.shared.whiteColor,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonViews() {
        sendButton.configuration = .bordered()
        sendButton.addTarget(self, action: #selector(sendTransactions(_:)), for: .touchUpInside)
        sendButton.configuration?.image = UIImage(named: "send")
        sendButton.configuration?.imagePadding = 4
        sendButton.configuration?.imagePlacement = .top
        sendButton.configuration?.baseBackgroundColor = AirBaseBgColors.shared.blueColor
        sendButton.configuration?.cornerStyle = .capsule
        
        receiveButton.configuration = .bordered()
        receiveButton.addTarget(self, action: #selector(receiveTransactions(_:)), for: .touchUpInside)
        receiveButton.configuration?.image = UIImage(named: "receiveIcon")
        receiveButton.configuration?.imagePadding = 4
        receiveButton.configuration?.imagePlacement = .top
        receiveButton.configuration?.baseBackgroundColor = AirBaseBgColors.shared.blueColor
        receiveButton.configuration?.cornerStyle = .capsule
        
        startButton.configuration = .bordered()
        startButton.addTarget(self, action: #selector(startTransactions(_:)), for: .touchUpInside)
        startButton.configuration?.cornerStyle = .capsule
        startButton.configuration?.title = "Start"
        startButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        startButton.configuration?.baseBackgroundColor = AirBaseBgColors.shared.blueColor
        startButton.configuration?.baseForegroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
        
        getAddressButton.configuration = .bordered()
        getAddressButton.addTarget(self, action: #selector(getCoinbaseAddress(_:)), for: .touchUpInside)
        getAddressButton.configuration?.cornerStyle = .capsule
        getAddressButton.configuration?.title = "Get Coinbase Address"
        getAddressButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        getAddressButton.configuration?.baseBackgroundColor = AirBaseBgColors.shared.blueColor
        getAddressButton.configuration?.baseForegroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
        
        sendButton.isHidden = true
        receiveButton.isHidden = true
        startButton.isHidden = true
        addTaskField.isHidden = true
        ReceiveLabel.isHidden = true
        sendLabel.isHidden = true
        
        if let name = AirBaseUserDefaults.value(forKey: "Name") as? String {
            headerLabel.text = welcomeString + name
            let size = name.getSizeOfatributedString(neededFont: headerLabel.font)
            headerLabel.frame.size = size
        }
        else {
            headerLabel.isHidden = true
        }
    }
    
    func setAllViews() {
        self.view.addSubview(sendButton)
        self.view.addSubview(receiveButton)
        self.view.addSubview(startButton)
        self.view.addSubview(getAddressButton)
        self.view.addSubview(addTaskField)
        self.view.addSubview(headerLabel)
        self.view.addSubview(sendLabel)
        self.view.addSubview(ReceiveLabel)
        
        self.view.backgroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
        
        headerLabel.addConstraint(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 0),centerX: view.centerXAnchor)
        getAddressButton.addConstraint(top: headerLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 200, height: 60),centerX: view.centerXAnchor)
        addTaskField.addConstraint(top: getAddressButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 40))
        sendButton.addConstraint(top: startButton.topAnchor, leading: nil, bottom: nil, trailing: startButton.leadingAnchor,padding: UIEdgeInsets(top: -120, left: 20, bottom: 0, right: -30),size: CGSize(width: 80, height: 80))
        receiveButton.addConstraint(top: startButton.topAnchor, leading: sendButton.trailingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: -120, left: 40, bottom: 0, right: 0),size: CGSize(width: 80, height: 80))
        sendLabel.addConstraint(top: sendButton.bottomAnchor, leading: sendButton.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0), size: CGSize(width: 90, height: 15))
        ReceiveLabel.addConstraint(top: receiveButton.bottomAnchor, leading: receiveButton.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0),size: CGSize(width: 90, height: 15))
        startButton.addConstraint(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil,padding: UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0),size: CGSize(width: 110, height: 50),centerX: view.centerXAnchor)
    }
    
    @objc func getCoinbaseAddress(_ button: UIButton){
        coinbaseConnection.initiateHandshake()
    }
    
    
    @objc func startTransactions(_ button: UIButton){
        if sendButton.isHidden && receiveButton.isHidden {
            sendButton.alpha = 1
            sendButton.isHidden = false
            receiveButton.alpha = 1
            receiveButton.isHidden = false
            ReceiveLabel.isHidden = false
            sendLabel.isHidden = false
        }
        else {
            sendButton.isHidden = true
            receiveButton.isHidden = true
            ReceiveLabel.isHidden = true
            sendLabel.isHidden = true
        }
    }
    
    @objc func sendTransactions(_ button: UIButton){
        self.discover = AirBaseSender(coinbaseConnection: coinbaseConnection)
        self.discover?.delegate = self
        self.nearbyDevicesView = AirBaseShowNearbyDevicesView()
        self.nearbyDevicesView?.delegate = self
        self.nearbyDevicesView?.delegate1 = self
        self.delegate = nearbyDevicesView
        nearbyDevicesView?.modalPresentationStyle = .popover
        let nav =  UINavigationController.init(rootViewController: nearbyDevicesView!)
        nav.popoverPresentationController?.backgroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
        self.present(nav, animated: false)
    }
    
    func stopDiscovery() {
        discover?.discoverer.stopDiscovery()
    }
    
    @objc func receiveTransactions(_ button: UIButton){
        self.advertiser = AirBaseReceiver(coinbaseConnection: coinbaseConnection)
        advertiser?.delegate = self
        receiveMoneyCtrl = ReceiveMoneyViewController()
        receiveMoneyCtrl?.delegate = self
        receiveMoneyCtrl?.isConnecting = true
        self.showCustomizeController(ctrl: receiveMoneyCtrl ?? UIViewController())
    }
    
    func stopAdvertiser() {
        advertiser?.advertiser.stopAdvertising()
    }
    
    func showTransactionViewToSender(name: String, amount: String) {
        transactionCompleteView = AirBaseTransactionView(name: name, amount: amount)
        transactionCompleteView?.modalPresentationStyle = .fullScreen
        self.present(transactionCompleteView ?? UIViewController(), animated: true)
    }
    
    func showCustomizeController(ctrl: UIViewController) {
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    func showNearbyDevices(endpointID: EndpointID, data: String, deviceName: String) {
        delegate?.showNearbyDevices(endpointID: endpointID, data: data, deviceName: deviceName)
    }
    
    func showToast(message: String) {
        let promptView =  AirBaseAlertWindow(message: message)
        promptView.show(viewCtrl: self)
    }
}

extension AirBaseViewController: AirBaseTransactionUpdates {
    func setTransactionId(_ id: String) {
//        transactionCompleteView?.transactionID.text = id
//        receiveMoneyCtrl?.transactionID.text = id
//        receiveMoneyCtrl?.headerLabel.text = "Received"
    }
}

extension AirBaseViewController:  UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if validateUsername() {
            self.showToast(message: "\(userName) is successfully created")
            startButton.isHidden = false
            addTaskField.isHidden = true
        }
        return true
    }
    
    func validateUsername() -> Bool{
        if let username = addTaskField.text, !username.isEmpty {
            AirBaseUserDefaults.set(username, forKey: "Name")
            self.userName = username
            headerLabel.text = welcomeString + username
            headerLabel.isHidden = false
            return true
        } else {
            let alert = UIAlertController(title: "Error", message: "Username Cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return false
        }
    }
}

extension AirBaseViewController: AirBaseCoinBaseDelegates {
    func callCoinBaseApp(weiValue: String) {
        self.discover?.coinbaseConnection.makeCoinbaseRequests(receiverAddress: self.discover?.receiverAddress ?? "", weiValue: weiValue)
    }
}

extension AirBaseViewController: AirBaseNearbyDevicesDelegate {
    func setNearByData(toAddress: String) {
        self.sendMoneyCtrl = SendMoneyViewController(name: toAddress)
        self.sendMoneyCtrl?.delegate = self
        self.sendMoneyCtrl?.coinbaseDelegate = self
        self.showCustomizeController(ctrl: sendMoneyCtrl ?? UIViewController())
//        self.discover?.coinbaseConnection.makeCoinbaseRequests(receiverAddress: toAddress)
    }
}

