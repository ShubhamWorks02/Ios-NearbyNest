//
//  Coordinator.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 07/08/23.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
    func finish()
}
