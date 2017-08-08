//
//  NetwrokServiceManager.swift
//  mesh
//
//  Created by Victor Chien on 11/27/16.
//  Copyright © 2016 Victor Chien. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol NetworkServiceManagerDelegate {
    func connectedDevicesChanged(_ manager : NetworkServiceManager, connectedDevices: [String])
    func updateData(_ manager : NetworkServiceManager, dataString: String)
}

class NetworkServiceManager: NSObject {
    fileprivate let NetworkServiceType = "mesh-network"
    //change below for custom username
    fileprivate let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    fileprivate var serviceAdvertiser : MCNearbyServiceAdvertiser
    fileprivate var serviceBrowser : MCNearbyServiceBrowser
    var delegate : NetworkServiceManagerDelegate?
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: NetworkServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: NetworkServiceType)
        
        super.init()
        self.serviceAdvertiser.delegate = self
        self.serviceBrowser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    lazy var session: MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.required)
        session.delegate = self
        return session
    }()
    
    //to send the list of coordinates with tags
    func sendInformation(_ info : String, _ names : [String]) {
        NSLog("%@", "sendData: \(info)")
        
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(info.data(using: String.Encoding.utf8, allowLossyConversion: false)!, toPeers: filterConnectedPeers(names), with: MCSessionSendDataMode.reliable)
            } catch let error as NSError {
                NSLog("%@", "\(error)")
            }
        }
    }
    
    private func filterConnectedPeers(_ names: [String]) -> [MCPeerID]{
        var result: [MCPeerID] = []
        for id in session.connectedPeers {
            if names.contains(id.displayName) {
                result.append(id)
            }
        }
        return result
    }
    
    func refresh() {
        self.serviceAdvertiser.startAdvertisingPeer()
        self.serviceBrowser.startBrowsingForPeers()
    }
}

//accepts all incoming connections
extension NetworkServiceManager : MCNearbyServiceAdvertiserDelegate {
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }

    internal func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error){
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
}

extension NetworkServiceManager : MCNearbyServiceBrowserDelegate {
    internal func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error){
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
        
    internal func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
        
        let tempNewContact = ["newContact": peerID.displayName]
        SharingManager.sharedInstance.directConnections.append(peerID.displayName)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewConnectionFound"), object: nil, userInfo: tempNewContact)
    }

    internal func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
}
    
extension MCSessionState {
    func stringValue() -> String {
            switch(self) {
            case .notConnected: return "NotConnected"
            case .connecting: return "Connecting"
            case .connected: return "Connected"
        }
    }
}
    
extension NetworkServiceManager : MCSessionDelegate {
        func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
            NSLog("%@", "peer \(peerID) didChangeState: \(state.stringValue())")
            self.delegate?.connectedDevicesChanged(self, connectedDevices: session.connectedPeers.map({$0.displayName}))
        }
    
        func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
            NSLog("%@", "didReceiveData: \(data.count) bytes")
            let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            self.delegate?.updateData(self, dataString: str)
        }
        
        func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
            NSLog("%@", "didReceiveStream")
        }
    
        func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
            NSLog("%@", "didFinishReceivingResourceWithName")
        }
        
        func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
            NSLog("%@", "didStartReceivingResourceWithName")
        }
    }

    


