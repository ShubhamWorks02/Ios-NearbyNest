//
//  AppCoordinator.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 07/08/23.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var window: UIWindow
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }
    
    func start() {
        // To be updated
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
    }
}
