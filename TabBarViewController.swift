//
//  TabBarViewController.swift
//  GiphyClient
//
//  Created by Robin Mehta on 5/30/17.
//  Copyright © 2017 robin. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

        let tabOne = UINavigationController(rootViewController: FeedViewController())
        let tabOneBarItem = UITabBarItem(title: "Browse", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: ""))
        tabOne.tabBarItem = tabOneBarItem

        let tabTwo = UINavigationController(rootViewController: StartViewController())
        let tabTwoBarItem = UITabBarItem(title: "Check In", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: ""))

        tabOne.tabBarItem = tabOneBarItem
        tabTwo.tabBarItem = tabTwoBarItem

        self.viewControllers = [tabOne, tabTwo]
//        self.viewControllers = [tabOne]
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
}
