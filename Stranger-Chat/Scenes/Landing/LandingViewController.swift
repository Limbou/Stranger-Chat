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

private enum Constants {
    static let title = "landing.title"
}

final class LandingViewController: UIViewController {

    private let bag = DisposeBag()
    internal let interactor: LandingInteractor
    @IBOutlet var loginButton: RoundButton!
    @IBOutlet var registerButton: RoundButton!
    @IBOutlet var offlineModeButton: RoundButton!

    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var messageToSend: String!

    init(interactor: LandingInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title.localized()
        setupButtonsActions()

        // 1
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showConnectionMenu))

        // 2
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }


    @objc func showConnectionMenu() {
      let ac = UIAlertController(title: "Connection Menu", message: nil, preferredStyle: .actionSheet)
      ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: hostSession))
      ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
      ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      present(ac, animated: true)
    }

    // 1
    func hostSession(action: UIAlertAction) {
      mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ioscreator-chat", discoveryInfo: nil, session: mcSession)
      mcAdvertiserAssistant.start()
    }

    // 2
    func joinSession(action: UIAlertAction) {
      let mcBrowser = MCBrowserViewController(serviceType: "ioscreator-chat", session: mcSession)
      mcBrowser.delegate = self
      present(mcBrowser, animated: true)
    }

    @IBAction func tapSendButton(_ sender: Any) {
    // 1
    messageToSend = "\(peerID.displayName): Hi\n"
      let message = messageToSend.data(using: String.Encoding.utf8, allowLossyConversion: false)

      do {
        // 2
        try self.mcSession.send(message!, toPeers: self.mcSession.connectedPeers, with: .unreliable)
        print(message)
      }
      catch {
        print("Error sending message")
      }
    }


    private func setupButtonsActions() {
        loginButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: interactor.loginPressed)
            .disposed(by: bag)
        registerButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: interactor.registerPressed)
            .disposed(by: bag)
        offlineModeButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: interactor.offlineModePressed)
            .disposed(by: bag)
    }

}

extension LandingViewController: MCSessionDelegate, MCBrowserViewControllerDelegate {


    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
      switch state {
      case .connected:
        print("Connected: \(peerID.displayName)")
        print("lol")
        self.messageToSend = "\(peerID.displayName): Hi\n"
        let message = self.messageToSend.data(using: String.Encoding.utf8, allowLossyConversion: false)

        do {
          // 2
          try self.mcSession.send(message!, toPeers: self.mcSession.connectedPeers, with: .unreliable)
          print(message)
        }
        catch {
          print("Error sending message")
        }
      case .connecting:
        print("Connecting: \(peerID.displayName)")
      case .notConnected:
        print("Not Connected: \(peerID.displayName)")
      @unknown default:
        print("fatal error")
      }
    }

    // 2
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
      DispatchQueue.main.async { [unowned self] in
        // send chat message
        let message = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
        print(message)
      }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }

    // 3
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
      dismiss(animated: true)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
      dismiss(animated: true)
    }


}
