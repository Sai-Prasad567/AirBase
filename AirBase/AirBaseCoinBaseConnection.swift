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
        print("makeCoinbaseRequests.. \(receiverAddress)... \(self.address)")
        cbwallet.makeRequest(
            Request(actions: [
                Action(jsonRpc: .eth_sendTransaction(fromAddress: self.address, toAddress: receiverAddress, weiValue: weiValue, data: "0x", nonce: 1, gasPriceInWei: nil, maxFeePerGas: nil, maxPriorityFeePerGas: nil, gasLimit: nil, chainId: "8453"))
            ])) { result in
                print(result)
            }
    }
}
