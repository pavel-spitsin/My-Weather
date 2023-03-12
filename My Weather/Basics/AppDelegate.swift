//
//  AppDelegate.swift
//  My Weather
//
//  Created by Pavel
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Properties
    
    var window:UIWindow?
    
    //MARK: - App Life Cycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        LocationService.shared.askUserForAuthorisation()
        window?.rootViewController = UINavigationController(rootViewController: PageViewController(transitionStyle: .scroll,
                                                                                                   navigationOrientation: .horizontal))
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}
