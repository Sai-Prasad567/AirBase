//
//  SendMoneyViewController.swift
//  AirBase
//
//  Created by Sai Prasad on 22/06/24.
//

import Foundation
import UIKit

class SendMoneyViewController: UIViewController {
    
    lazy var addTaskField: AirBaseTextField = {
        let textField = AirBaseTextField()
        textField.text = "$0"
        textField.font = UIFont(name: "Charter-Bold", size: 40)
        textField.backgroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
        textField.textColor = AirBaseBgColors.shared.blueColor
        textField.textAlignment = .center
        textField.inputView = numberKeyPad
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var sendButt = UIButton()
    var receiverName = String()
    
    weak var delegate: AirBaseNearbyDelegates?
    weak var coinbaseDelegate: AirBaseCoinBaseDelegates?
    let numberKeyPad = AirBaseNumberKeyPad()
    let divider = UIView()
    
    init(name: String){
        super.init(nibName: nil, bundle: nil)
        self.receiverName = name
        self.setTransactionViews()
        setButtonViews()
        var image = UIImage.init(named: "back")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            image = image?.imageFlippedForRightToLeftLayoutDirection()
        }
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonPressed))
        numberKeyPad.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonViews() {
        sendButt.configuration = .bordered()
        sendButt.addTarget(self, action: #selector(callCoinbase(_:)), for: .touchUpInside)
        sendButt.configuration?.cornerStyle = .capsule
        sendButt.configuration?.title = "Send"
        sendButt.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 1)
        sendButt.configuration?.baseBackgroundColor = AirBaseBgColors.shared.blueColor
        sendButt.configuration?.baseForegroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
        
        divider.backgroundColor = AirBaseBgColors.shared.whiteColor
        sendButt.alpha = 0.5
        sendButt.isUserInteractionEnabled = false
        numberKeyPad.backgroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
    }
    
    private func setTransactionViews() {
        self.view.addSubview(addTaskField)
        self.view.addSubview(sendButt)
        self.view.addSubview(divider)
        self.view.addSubview(numberKeyPad)
        self.view.backgroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
        
        addTaskField.addConstraint(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 150))
        divider.addConstraint(top: self.addTaskField.bottomAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 1))
        numberKeyPad.addConstraint(top: self.divider.bottomAnchor, leading: self.view.leadingAnchor, bottom: sendButt.topAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0), size: CGSize(width: 0, height: 0))
        sendButt.addConstraint(top: nil, leading: self.view.leadingAnchor, bottom: view.bottomAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 30, right: 10), size: CGSize(width: 0, height: 60))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Transfer Money"
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: AirBaseBgColors.shared.whiteColor,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
    }
    
    @objc func backButtonPressed(){
        delegate?.stopDiscovery()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func callCoinbase(_ button: UIButton) {
        let alertController = UIAlertController(title: "Confirmation", message: "Do you want to proceed?", preferredStyle: .alert)
        // Action Required, Choose an action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.addTaskField.text?.removeFirst()
            var amo = ""
            if let text = self.addTaskField.text, text != "" {
                amo = text
                self.coinbaseDelegate?.callCoinBaseApp(weiValue: text)
            }
            
            self.addTaskField.text = "$0"
            self.sendButt.alpha = 0.5
            self.sendButt.isUserInteractionEnabled = false
            self.numberKeyPad.numStr = ""
            self.delegate?.showTransactionViewToSender(name: self.receiverName, amount: amo)
            self.backButtonPressed()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            alertController.dismiss(animated: true)
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SendMoneyViewController: AirBaseInputViewDelegate {
    func textInputView(text: String) {
        let str = "$"
        if addTaskField.text == "$0" {
            addTaskField.text?.removeLast()
            addTaskField.text?.append(text)
        }
        else {
            addTaskField.text = str + text
        }
        if !text.isEmpty {
            self.sendButt.alpha = 1
            self.sendButt.isUserInteractionEnabled = true
        }
    }
    
    func deleteButtonPressed(text: String) {
        let str = "$"
        if addTaskField.text != "$0" && addTaskField.text!.count > 2 {
            addTaskField.text = str + text
        }
        else if addTaskField.text?.count == 2 {
            addTaskField.text = "$0"
            self.sendButt.alpha = 0.5
            self.sendButt.isUserInteractionEnabled = false
        }
        
    }
}
