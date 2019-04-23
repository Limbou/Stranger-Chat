//
//  LandingViewController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MultipeerConnectivity

final class LandingViewController: UIViewController, PeerSessionDelegate {
    func peerConnected(peerID: MCPeerID) {
        print("😱connected: \(peerID) - \(clientSession?.mcSession.connectedPeers)")
    }

    func peerConnecting(peerID: MCPeerID) {
        print("😱connecting: \(peerID) - \(clientSession?.mcSession.connectedPeers)")
    }

    func peerDisconnected(peerID: MCPeerID) {
        print("😱disconnected: \(peerID) - \(clientSession?.mcSession.connectedPeers)")
    }

    func peerDiscovered(peerID: MCPeerID) {
        print("😱discovered: \(peerID)")
        peerToConnect = peerID
    }

    func peerLost(peerID: MCPeerID) {
        print("😱PEER GOT LOST: \(peerID)")
        peerToConnect = nil
    }

    func peerReceived(data: Data, from peerID: MCPeerID) {
        print("❤️")
    }

    func peerConnectionError(_ error: Error) {
        print("😥 \(error)")
    }

    func connectionReady() {

    }

    func connectionClosed() {

    }

    func invitationReceived(from peerID: MCPeerID) {

    }


    private var peerToConnect: MCPeerID?
    private var clientSession: PeerClientSession?
    private var hostSession: PeerHostSession?
    private var peerId: MCPeerID?
    private let bag = DisposeBag()
    internal let interactor: LandingInteractor
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!

    init(interactor: LandingInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonsActions()
        clientSession = PeerClientSession(displayName: "abcdef", delegate: self)
        hostSession = PeerHostSession(displayName: "abc", delegate: self)
        if UIDevice.current.name == "iPhone X" {
            hostSession?.connect()
        } else {
            clientSession?.connect()
        }
    }

    private func setupButtonsActions() {
        loginButton.rx.tap.subscribe(onNext: { _ in

        }, onError: nil, onCompleted: nil, onDisposed: nil)
        registerButton.rx.tap.subscribe(onNext: { (_) in
            self.send()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }

    func connectedWithPeer(peerID: MCPeerID) {

    }

//    private func invite() {
//        if let peer = peerToConnect {
//            manager.browser.invitePeer(peer, to: manager.session, withContext: nil, timeout: 30)
//        }
//    }

    private func send() {
        if let url = URL(string: "https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500") {
            do {
                let data = try Data(contentsOf: url)
                hostSession?.send(data: data)
            } catch (let error) {
                print(error)
            }
        }
    }

}
