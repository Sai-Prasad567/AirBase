//
//  AirBaseDelegates.swift
//  AirBase
//
//  Created by Sai Prasad on 24/06/24.
//

import Foundation
import NearbyConnections
import CoinbaseWalletSDK

protocol AirBaseNearbyDelegates: NSObjectProtocol {
    func stopDiscovery()
    func stopAdvertiser()
    func setReceiverName(name: String)
}

protocol AirBaseShowDevicesDelegates: NSObjectProtocol {
    func showNearbyDevices(endpointID: EndpointID, data: String, deviceName: String)
}

protocol AirBaseNearbyDevicesDelegate: NSObjectProtocol {
    func setNearByData(toAddress: String)
}

protocol AirBaseCoinBaseDelegates: NSObjectProtocol {
    func callCoinBaseApp(weiValue: String)
}

protocol AirBaseInputViewDelegate: NSObjectProtocol {
    func textInputView(text: String)
    func deleteButtonPressed(text: String)
}


