//
//  MainTabBarController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 26/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

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
//        tabBar.unselectedItemTintColor = UIColor.green
//        tabBar.tintColor = UIColor.red
    }

    private func setupControllers() {
        viewControllers = [
            buildHomeController(),
            buildHistoryController()
        ]
    }

    private func buildHomeController() -> UINavigationController {
        let viewController = Provider.get.instanceOf(HomeViewController.self)
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.tabBarItem.image = UIImage(systemName: "house")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        return navigationController
    }

    private func buildHistoryController() -> UINavigationController {
        let viewController = UIViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.tabBarItem.image = UIImage(systemName: "archivebox")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "archivebox.fill")
        return navigationController
    }

}

extension MainTabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

}
