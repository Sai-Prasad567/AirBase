//
//  AppDelegate.swift
//  AirBase
//
//  Created by Sai Prasad on 23/06/24.
//

import UIKit
import NearbyConnections
import CoinbaseWalletSDK
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.swizzleOpenURL()
        CoinbaseWalletSDK.configure(
            callback: URL(string: "airbase://mycallback")!
        )
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: AirBaseViewController())
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (try? CoinbaseWalletSDK.shared.handleResponse(url)) == true {
            let keyWindow = (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).topViewController
            if let vc = keyWindow as? AirBaseViewController {
                vc.showToast(message: "Coinbase address is registered")
                if AirBaseUserDefaults.value(forKey: "Name") == nil {
                    vc.addTaskField.isHidden = false
                }
                else {
                    vc.startButton.isHidden = false
                }
            }
            return true
        }
        // handle other types of deep links
        return false
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

extension UIApplication {
    static func swizzleOpenURL() {
        guard
            let original = class_getInstanceMethod(UIApplication.self, #selector(open(_:options:completionHandler:))),
            let swizzled = class_getInstanceMethod(UIApplication.self, #selector(swizzledOpen(_:options:completionHandler:)))
        else { return }
        method_exchangeImplementations(original, swizzled)
    }
    
    @objc func swizzledOpen(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?) {
        logWalletSegueMessage(url: url)
        
        // it's not recursive. below is actually the original open(_:) method
        self.swizzledOpen(url, options: options, completionHandler: completion)
    }
    func logWalletSegueMessage(url: URL, function: String = #function) {
        let keyWindow = (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).topViewController
        if let vc = keyWindow as? AirBaseViewController {
            vc.getAddressButton.isHidden = true
        }
    }
}





