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
    private var currentUserRepository: CurrentUserRepository!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        currentUserRepository = Provider.get.instanceOf(CurrentUserRepository.self)
        configureFirebase()
        configureRootViewController()
        return true
    }

    private func configureFirebase() {
        FirebaseApp.configure()
    }

    private func configureRootViewController() {
        var controller: UIViewController
        if currentUserRepository.currentUser() != nil {
            controller = Provider.get.instanceOf(MainTabBarController.self)
        } else {
            let viewController = Provider.get.instanceOf(LandingViewController.self)
            controller = MainNavigationController(rootViewController: viewController)
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }

}
