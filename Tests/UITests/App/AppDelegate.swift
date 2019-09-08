//
//  AppDelegate.swift
//  App
//
//  Created by Koji Murata on 2019/09/09.
//

import UIKit
import Macduff

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Config.default = Config(cache: MemoryCache(fallbackCache: nil))
        return true
    }
}

