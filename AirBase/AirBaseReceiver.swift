//
//  AirBaseReceiver.swift
//  AirBase
//
//  Created by Sai Prasad on 22/06/24.
//

import Foundation
import NearbyConnections

class AirBaseReceiver {
    let connectionManager: ConnectionManager
    let advertiser: Advertiser
    var coinbaseConnection: AirBaseCoinBaseConnection
    var receiverDict:[String:String] = [:]
    var username: String = ""
    weak var delegate: AirBaseNearbyDelegates?
    
    init(coinbaseConnection: AirBaseCoinBaseConnection) {
        self.coinbaseConnection = coinbaseConnection
        if let name = AirBaseUserDefaults.value(forKey: "Name") as? String {
            receiverDict["name"] = name
        }
        receiverDict["address"] = coinbaseConnection.address
        connectionManager = ConnectionManager(serviceID: "com.sai.AirBase.AirBase", strategy: .pointToPoint)
        advertiser = Advertiser(connectionManager: connectionManager)
        
        
        // The endpoint info can be used to provide arbitrary information to the
        // discovering device (e.g. device name or type).
        advertiser.startAdvertising(using: receiverDict["name"]!.data(using: .utf8)!)
        connectionManager.delegate = self
        advertiser.delegate = self
        username = JSONStringForDictionary(dictionary: receiverDict)
    }
    
    func JSONStringForDictionary(dictionary: [String:String]) -> String{
        if let theJsonData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: []
            ),
            let theJsonString = String(data: theJsonData, encoding: .utf8) {
            return theJsonString
        }
        return ""
    }
}


extension AirBaseReceiver: AdvertiserDelegate {
    func advertiser(
        _ advertiser: Advertiser, didReceiveConnectionRequestFrom endpointID: EndpointID,
        with context: Data, connectionRequestHandler: @escaping (Bool) -> Void) {
            // Accept or reject any incoming connection requests. The connection will still need to
            // be verified in the connection manager delegate.
            connectionRequestHandler(true)
        }
}

extension AirBaseReceiver: ConnectionManagerDelegate {
  func connectionManager(
    _ connectionManager: ConnectionManager, didReceive verificationCode: String,
    from endpointID: EndpointID, verificationHandler: @escaping (Bool) -> Void) {
    // Optionally show the user the verification code. Your app should call this handler
    // with a value of `true` if the nearby endpoint should be trusted, or `false`
    // otherwise.
    verificationHandler(true)
  }

  func connectionManager(
    _ connectionManager: ConnectionManager, didReceive data: Data,
    withID payloadID: PayloadID, from endpointID: EndpointID) {
    // A simple byte payload has been received. This will always include the full data.
        print(data)
  }

  func connectionManager(
    _ connectionManager: ConnectionManager, didReceive stream: InputStream,
    withID payloadID: PayloadID, from endpointID: EndpointID,
    cancellationToken token: CancellationToken) {
    // We have received a readable stream.
  }

  func connectionManager(
    _ connectionManager: ConnectionManager,
    didStartReceivingResourceWithID payloadID: PayloadID,
    from endpointID: EndpointID, at localURL: URL,
    withName name: String, cancellationToken token: CancellationToken) {
    // We have started receiving a file. We will receive a separate transfer update
    // event when complete.
  }

  func connectionManager(
    _ connectionManager: ConnectionManager,
    didReceiveTransferUpdate update: TransferUpdate,
    from endpointID: EndpointID, forPayload payloadID: PayloadID) {
    // A success, failure, cancelation or progress update.
  }

  func connectionManager(
    _ connectionManager: ConnectionManager, didChangeTo state: ConnectionState,
    for endpointID: EndpointID) {
    switch state {
    case .connecting:
        print("Connecting to \(endpointID)")
      // A connection to the remote endpoint is currently being established.
    case .connected:
        print("Connected to and sending data \(endpointID)")
        let _ = self.connectionManager.send(Data(username.utf8), to: [endpointID])
      // We're connected! Can now start sending and receiving data.
    case .disconnected:
        print("disconnected to \(endpointID)")
      // We've been disconnected from this endpoint. No more data can be sent or received.
    case .rejected:
        print("rejected to \(endpointID)")
      // The connection was rejected by one or both sides.
    }
  }
}
