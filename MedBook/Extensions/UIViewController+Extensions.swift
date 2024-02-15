//
//  UIViewController+Extensions.swift
//  MedBook
//
//  Created by deq on 14/02/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    static func load<T: UIViewController>() -> T {
        T(nibName: String(describing: T.self), bundle: nil)
    }
    
    func hideNavigationBar(shouldHide: Bool = true) {
        navigationController?.navigationBar.isHidden = shouldHide
    }
    
    func dissMissController(withCompletion: Bool = false, completion: (() -> Void)? = nil) {
        dismiss(animated: true) {
            if withCompletion { completion?() }
        }
    }
    
    func logoutAndSetRoot() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = storyboard.instantiateViewController(identifier: "LandingViewController") as! LandingViewController

                let navigationController = UINavigationController(rootViewController: homeViewController)

                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                   let window = sceneDelegate.window {
                    window.rootViewController = navigationController
                    window.makeKeyAndVisible()
                }
        UserDefaults.isLogedIn = false
        UserDefaults.userEmail = ""
    }
    
}

extension UIViewController {
    
    func push(_ controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func present(_ controller: UIViewController, _ animated: Bool = true) {
        present(controller, animated: animated, completion: nil)
    }
    
    func dismiss(_ animated: Bool = true) {
        dismiss(animated: animated, completion: nil)
    }
    
}

extension UIViewController {
    
    /* To check if a view controller is presented modally or pushed
     onto a navigation controller stack */
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}
