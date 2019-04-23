////
////  MPCManager.swift
////  Stranger-Chat
////
////  Created by Jakub Danielczyk on 15/04/2019.
////  Copyright © 2019 Jakub Danielczyk. All rights reserved.
////
//
//import UIKit
//import MultipeerConnectivity
//
//protocol MPCManagerDelegate: AnyObject {
//    func foundPeer()
//    func lostPeer()
//    func invitationWasReceived(fromPeer: String)
//    func connectedWithPeer(peerID: MCPeerID)
//}
//
//typealias InvitationHandler = ((Bool, MCSession?) -> Void)
//
//private struct Constants {
//    static let serviceType = "ttemsctoy"
//}
//
//final class MPCManager: NSObject {
//
//    weak var delegate: MPCManagerDelegate?
//    private var peer: MCPeerID
//     var session: MCSession
//     var browser: MCNearbyServiceBrowser
//     var advertiser: MCAdvertiserAssistant
//    private var invitationHandler: InvitationHandler?
//     var foundPeers = [MCPeerID]()
//
//    override init() {
//        peer = MCPeerID(displayName: "abcd")
//        session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: .none)
//        browser = MCNearbyServiceBrowser(peer: peer, serviceType: Constants.serviceType)
//        advertiser = MCAdvertiserAssistant(serviceType: Constants.serviceType, discoveryInfo: nil, session: session)
//        super.init()
//        session.delegate = self
//        browser.delegate = self
//    }
//
//}
//
//extension MPCManager: MCSessionDelegate {
//
//    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
//        if state == .connected {
//            print("😍")
//            delegate?.connectedWithPeer(peerID: foundPeers[0])
//        } else if state == .connecting {
//            print("🤔")
//        } else {
//            print("🤮")
//        }
//    }
//
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        print("❤️")
//    }
//
//    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
//
//    }
//
//    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
//
//    }
//
//    func session(_ session: MCSession,
//                 didFinishReceivingResourceWithName resourceName: String,
//                 fromPeer peerID: MCPeerID,
//                 at localURL: URL?,
//                 withError error: Error?) {
//
//    }
//
//}
//
//extension MPCManager: MCNearbyServiceBrowserDelegate {
//
//    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
//        foundPeers.append(peerID)
//        delegate?.foundPeer()
//    }
//
//    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
//        if let index = foundPeers.index(of: peerID) {
//            foundPeers.remove(at: index)
//        }
//        delegate?.lostPeer()
//    }
//
//    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
//        print(error.localizedDescription)
//    }
//
//}
//
//extension MPCManager: MCNearbyServiceAdvertiserDelegate {
//
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
//                    didReceiveInvitationFromPeer peerID: MCPeerID,
//                    withContext context: Data?,
//                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//        invitationHandler(true, session)
//    }
//
//}
