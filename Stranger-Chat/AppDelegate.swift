//
//  AppDelegate.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 18/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureFirebase()
        configureRootViewController()
        return true
    }

    private func configureFirebase() {
        FirebaseApp.configure()
        #if DEBUG
        #else
        FirebaseApp.configure()
        #endif
    }

    private func configureRootViewController() {
        let controller = Provider.get.instanceOf(MainTabBarController.self)
        //let navigationController = UINavigationController(rootViewController: controller)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }

}
