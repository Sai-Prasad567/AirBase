//
//  AirBaseCoinBaseConnection.swift
//  AirBase
//
//  Created by Sai Prasad on 24/06/24.
//

import CoinbaseWalletSDK

class AirBaseCoinBaseConnection {
    
    private let cbwallet = CoinbaseWalletSDK.shared
    var address = ""
    weak var delegate: AirBaseTransactionUpdates?
    init() {
        
    }
    
    func initiateHandshake() {
        cbwallet.initiateHandshake(
            initialActions: [
                Action(jsonRpc: .eth_requestAccounts)
            ]
        ) { result, account in
            switch result {
            case .success(let response):
                print("CoinBase Response is... \(response)")
                guard let account = account else { return }
                self.address = account.address
                print("From Address is... \(self.address)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func makeCoinbaseRequests(receiverAddress:String, weiValue: String) {
        cbwallet.makeRequest(
            Request(actions: [
                Action(jsonRpc: .eth_sendTransaction(fromAddress: self.address, toAddress: receiverAddress, weiValue: weiValue, data: "0x", nonce: nil, gasPriceInWei: "1", maxFeePerGas: "1", maxPriorityFeePerGas: "1", gasLimit: "50000", chainId: "8453"))
            ])) { result in
                print("The result is \(result)")
                let ab = result.map { ab in
                    self.delegate?.setTransactionId(ab.uuid.uuidString)
                }
            }
    }
}
