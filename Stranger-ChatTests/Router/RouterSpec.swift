//
//  RouterSpec.swift
//  Stranger-ChatTests
//
//  Created by Jakub Danielczyk on 20/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

@testable import Stranger_Chat

import Quick
import Nimble

private final class RouterMock: Router {

    var viewController: UIViewController?
    var didPush: Bool = false
    var didPresent: Bool = false
    var didDismiss: Bool = false
    var navigationControllerDidDismiss: Bool = false
    var navigationControllerDidPop: Bool = false

    func push(viewController: UIViewController, animated: Bool = true) {
        guard let navigationController = self.viewController?.navigationController else {
            return
        }
        navigationController.pushViewController(viewController, animated: animated)
        didPush = true
    }

    func present(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard self.viewController != nil else {
            return
        }
        self.viewController?.present(viewController, animated: animated, completion: completion)
        didPresent = true
    }

    func dismiss() {
        guard let navController = viewController?.navigationController else {
            guard viewController != nil else {
                return
            }
            didDismiss = true
            return
        }
        guard navController.viewControllers.count > 1 else {
            navController.dismiss(animated: true)
            navigationControllerDidDismiss = true
            return
        }
        navController.popViewController(animated: true)
        navigationControllerDidPop = true
    }

}

final class RouterSpec: QuickSpec {

    private var routerMock: RouterMock!

    override func spec() {
        beforeEach {
            self.routerMock = RouterMock()
        }
        testPush()
        testPresent()
        testDismiss()
    }

    private func testPush() {
        describe("Router push method functionality") {
            it("Should push to navigation stack", closure: {
                self.routerMock.viewController = UIViewController()
                _ = UINavigationController(rootViewController: self.routerMock.viewController!)
                let pushedViewController = UIViewController()
                self.routerMock.push(viewController: pushedViewController)
                expect(self.routerMock.didPush).to(equal(true))
            })
            it("Should not push - view controller has no navigation controller", closure: {
                self.routerMock.viewController = UIViewController()
                let pushedViewController = UIViewController()
                self.routerMock.push(viewController: pushedViewController)
                expect(self.routerMock.didPush).to(equal(false))
            })
            it("Should not push - router's view controller is nil", closure: {
                let pushedViewController = UIViewController()
                self.routerMock.push(viewController: pushedViewController)
                expect(self.routerMock.didPush).to(equal(false))
            })
        }
    }

    private func testPresent() {
        describe("Router present method functionality") {
            it("Should present", closure: {
                self.routerMock.viewController = UIViewController()
                let presentedViewController = UIViewController()
                self.routerMock.present(viewController: presentedViewController)
                expect(self.routerMock.didPresent).to(equal(true))
            })
            it("Should not present - router's view controller is nil", closure: {
                let presentedViewController = UIViewController()
                self.routerMock.present(viewController: presentedViewController)
                expect(self.routerMock.didPresent).to(equal(false))
            })
        }
    }

    private func testDismiss() {
        describe("Router dismiss method functionality") {
            it("Should pop", closure: {
                self.routerMock.viewController = UIViewController()
                let navigationController = UINavigationController(rootViewController: self.routerMock.viewController!)
                let pushedViewController = UIViewController()
                self.routerMock.push(viewController: pushedViewController)
                expect(navigationController.topViewController).toEventually(equal(pushedViewController))
                self.routerMock.dismiss()
                expect(self.routerMock.navigationControllerDidPop).to(equal(true))
            })
            it("Should dismiss by navigation controller", closure: {
                self.routerMock.viewController = UIViewController()
                _ = UINavigationController(rootViewController: self.routerMock.viewController!)
                self.routerMock.dismiss()
                expect(self.routerMock.navigationControllerDidDismiss).to(equal(true))
            })
            it("Should dismiss by view controller", closure: {
                self.routerMock.viewController = UIViewController()
                self.routerMock.dismiss()
                expect(self.routerMock.didDismiss).to(equal(true))
            })
            it("Should not dismiss - view controller is nil", closure: {
                self.routerMock.dismiss()
                expect(self.routerMock.didDismiss).to(equal(false))
                expect(self.routerMock.navigationControllerDidDismiss).to(equal(false))
                expect(self.routerMock.navigationControllerDidPop).to(equal(false))
            })
        }
    }

}
