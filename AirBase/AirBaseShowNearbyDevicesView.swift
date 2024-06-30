//
//  AirBaseShowNearbyDevicesView.swift
//  AirBase
//
//  Created by Sai Prasad on 24/06/24.
//

import NearbyConnections
import UIKit

class AirBaseShowNearbyDevicesView: UIViewController, AirBaseShowDevicesDelegates {
    
    private var devicesList : [String] = []
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .insetGrouped)
        tableView.layer.cornerRadius = 6
        tableView.backgroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
        tableView.layer.borderColor = AirBaseBgColors.shared.blueColor.cgColor
        tableView.estimatedRowHeight = 21
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var startButton = UIButton()
    var selectedButton : [Int:Bool] = [:]
    var count = 0
    var dictIndex = 0
    weak var delegate: AirBaseNearbyDelegates?
    weak var delegate1: AirBaseNearbyDevicesDelegate?
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Near By Devices"
        let attrs = [
            NSAttributedString.Key.foregroundColor: AirBaseBgColors.shared.whiteColor,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        var image = UIImage.init(named: "cancel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            image = image?.imageFlippedForRightToLeftLayoutDirection()
        }
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(tapDismiss))
        setButtonViews()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonViews() {
        startButton.configuration = .bordered()
        startButton.addTarget(self, action: #selector(startTransactions(_:)), for: .touchUpInside)
        startButton.configuration?.cornerStyle = .capsule
        startButton.configuration?.title = "Let's Connect"
        startButton.configuration?.baseBackgroundColor = AirBaseBgColors.shared.blueColor
        startButton.configuration?.baseForegroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
        startButton.isHidden = true
    }
    
    func setUpViews() {
        self.view.backgroundColor = AirBaseBgColors.shared.bGColorW_bGColorD
        self.view.addSubview(tableView)
        self.view.addSubview(startButton)
        
        tableView.addConstraint(top: self.view.topAnchor, leading:  self.view.leadingAnchor, bottom: self.startButton.bottomAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 40, left: 0, bottom: 50, right: 0))
        startButton.addConstraint(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil,padding: UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0),size: CGSize(width: 170, height: 60),centerX: view.centerXAnchor)
        tableView.register(AirBaseTableViewCell.self, forCellReuseIdentifier: "dictCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func startTransactions(_ button: UIButton){
        delegate1?.setNearByData(toAddress: devicesList[dictIndex])
        self.dismiss(animated: true)
    }
    
    @objc func tapDismiss() {
        delegate?.stopDiscovery()
        self.dismiss(animated: true)
    }
}

extension AirBaseShowNearbyDevicesView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return devicesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : AirBaseTableViewCell?
        cell = AirBaseTableViewCell(text: devicesList[indexPath.row], style: .default, reuseIdentifier: "\(indexPath.row+10)")
        cell?.backgroundColor = AirBaseBgColors.shared.blueColor
        cell?.label.text = devicesList[indexPath.row]
        cell?.button.setImage(UIImage(named: "Checkboxempty"), for: .normal)
        cell?.button.addTarget(self, action: #selector(selectedButton(button:)), for: .touchUpInside)
        cell?.button.tag = indexPath.row
        selectedButton[indexPath.row] = false
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func selectedButton(button: UIButton){
        self.startButton.isHidden = false
        self.count = count + 1
        if let abd = selectedButton[button.tag] {
            dictIndex = button.tag
            selectedButton[button.tag] = true
        }
        else {
            selectedButton[button.tag] = false
        }
        if count > 1 {
            for (key,value) in selectedButton {
                if value == true {
                    if button.tag != key {
                        count = count - 1
                        let cell = tableView.cellForRow(at: IndexPath(row: key, section: 0)) as? AirBaseTableViewCell
                        if ((cell?.button.isSelected) != nil) {
                            cell?.button.setImage(UIImage(named: "Checkboxempty"), for: .normal)
                            cell?.button.isSelected = false
                        }
                    }
                }
            }
        }
        if button.isSelected {
            button.setImage(UIImage(named: "Checkboxempty"), for: .normal)
            button.isSelected = false
        }
        else {
            button.setImage(UIImage(named: "Checkboxfilled"), for: .normal)
            button.isSelected = true
        }
    }
    
    func showNearbyDevices(endpointID: EndpointID, data: String, deviceName: String) {
        self.devicesList.append(deviceName)
        self.tableView.reloadData()
    }
}
