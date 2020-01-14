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
    static let logout = "logout.tabbar.title"
    static let logoutTitle = "logout.alert.title"
    static let logoutBody = "logout.alert.body"
}

final class MainTabBarController: UITabBarController {

    private let currentUserRepository: CurrentUserRepository

    init(currentUserRepository: CurrentUserRepository) {
        self.currentUserRepository = currentUserRepository
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
            buildArchiveController(),
            buildLogout()
        ]
    }

    private func buildHomeController() -> UINavigationController {
        let viewController = Provider.get.instanceOf(HomeViewController.self)
        let navigationController = MainNavigationController(rootViewController: viewController)
        viewController.tabBarItem.image = UIImage(systemName: "message")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "message.fill")
        viewController.tabBarItem.title = Constants.chat.localized()
        viewController.navigationItem.title = Constants.startChatting.localized()
        viewController.tabBarItem.tag = 0
        return navigationController
    }

    private func buildArchiveController() -> UINavigationController {
        let viewController = Provider.get.instanceOf(ArchiveViewController.self)
        let navigationController = MainNavigationController(rootViewController: viewController)
        viewController.tabBarItem.image = UIImage(systemName: "archivebox")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "archivebox.fill")
        viewController.title = Constants.archive.localized()
        viewController.navigationItem.title = Constants.previousConversations.localized()
        viewController.tabBarItem.tag = 1
        return navigationController
    }

    private func buildLogout() -> UIViewController {
        let viewController = UIViewController()
        viewController.tabBarItem.image = UIImage(systemName: "escape")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "escape")
        viewController.tabBarItem.title = Constants.logout.localized()
        viewController.tabBarItem.tag = 2
        return viewController
    }

    private func presentLogoutAlert() {
        let alert = AlertBuilder.shared.buildYesNoAlert(with: Constants.logoutTitle.localized(),
                                                        message: Constants.logoutBody.localized(),
                                                        yesHandler: { _ in
            self.currentUserRepository.logout()
            self.goToLanding()
        }, noHandler: nil)
        present(alert, animated: true, completion: nil)
    }

    private func goToLanding() {
        let landingViewController = Provider.get.instanceOf(LandingViewController.self)
        let navigationController = MainNavigationController(rootViewController: landingViewController)
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        window.rootViewController = navigationController
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }

}

extension MainTabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController is UINavigationController
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 {
            presentLogoutAlert()
        }
    }

}
