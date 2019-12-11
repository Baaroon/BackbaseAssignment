//
//  AppDelegate.swift
//  Backbase
//
//  Created by Zahra Aghajani on 10/16/18.
//  Copyright © 2018 Zahra Aghajani. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            window?.backgroundColor = .systemBackground
        } else
        {
            window?.backgroundColor = .white
        }
        
        let citiesVC = CitiesViewController(dataHandler: DataHandler())
        let nv = UINavigationController(rootViewController: citiesVC)
        nv.navigationBar.isTranslucent = false
        nv.navigationBar.prefersLargeTitles = true
        nv.navigationItem.largeTitleDisplayMode = .always
        nv.navigationBar.tintColor = .red
        
        window?.rootViewController = nv
        window?.makeKeyAndVisible()
        
        return true
    }
}

