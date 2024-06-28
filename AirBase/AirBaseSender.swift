//
//  AirBaseSender.swift
//  AirBase
//
//  Created by Sai Prasad on 22/06/24.
//

import Foundation
import NearbyConnections

class AirBaseSender {
    let connectionManager: ConnectionManager
    let discoverer: Discoverer
    weak var delegate: AirBaseShowDevicesDelegates?
    var coinbaseConnection: AirBaseCoinBaseConnection
    var receiverAddress = ""
    var userName = ""
    
    init(coinbaseConnection: AirBaseCoinBaseConnection) {
        self.coinbaseConnection = coinbaseConnection
        connectionManager = ConnectionManager(serviceID: "com.sai.AirBase.AirBase", strategy: .pointToPoint)
        discoverer = Discoverer(connectionManager: connectionManager)
        
        discoverer.startDiscovery()
        connectionManager.delegate = self
        discoverer.delegate = self
    }
}

extension AirBaseSender: DiscovererDelegate {
    func discoverer(
        _ discoverer: Discoverer, didFind endpointID: EndpointID, with context: Data) {
            // An endpoint was found.
            discoverer.requestConnection(to: endpointID, using: context)
        }
    
    func discoverer(_ discoverer: Discoverer, didLose endpointID: EndpointID) {
        // A previously discovered endpoint has gone away.
    }
}

extension AirBaseSender: ConnectionManagerDelegate {
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
            print("Data is \(data)")
            if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                if let address = dict["address"], let name = dict["name"] {
                    receiverAddress = address
                    userName = name
                }
            }
            print("receiverAddress is... \(receiverAddress)")
            delegate?.showNearbyDevices(endpointID: endpointID, data: receiverAddress, deviceName: userName)
            // A simple byte payload has been received. This will always include the full data.
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
                print("Connected to \(endpointID)")
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
