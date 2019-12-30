//
//  MainTabBarController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 26/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

private enum Constants {
    static let chat = "chat.tabbar.title"
    static let archive = "archive.tabbar.title"
    static let startChatting = "chat.title"
    static let previousConversations = "archive.title"
}

final class MainTabBarController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabBar()
        setupControllers()
    }

    private func setupTabBar() {
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.8)
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = Color.darkBlue
    }

    private func setupControllers() {
        viewControllers = [
            buildHomeController(),
            buildArchiveController()
        ]
    }

    private func buildHomeController() -> UINavigationController {
        let viewController = Provider.get.instanceOf(HomeViewController.self)
        let navigationController = MainNavigationController(rootViewController: viewController)
        viewController.tabBarItem.image = UIImage(systemName: "message")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "message.fill")
        viewController.tabBarItem.title = Constants.chat.localized()
        viewController.navigationItem.title = Constants.startChatting.localized()
        return navigationController
    }

    private func buildArchiveController() -> UINavigationController {
        let viewController = Provider.get.instanceOf(ArchiveViewController.self)
        let navigationController = MainNavigationController(rootViewController: viewController)
        viewController.tabBarItem.image = UIImage(systemName: "archivebox")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "archivebox.fill")
        viewController.title = Constants.archive.localized()
        viewController.navigationItem.title = Constants.previousConversations.localized()
        return navigationController
    }

}

extension MainTabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

}
