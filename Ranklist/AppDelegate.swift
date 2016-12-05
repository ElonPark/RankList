//
//  AppDelegate.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 8..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Types
    enum ShortcutIdentifier: String {
        case First
        case Second
        
        
        // MARK: Initializers
        init?(fullType: String) {
            guard let last = fullType.components(separatedBy: ".").last else { return nil }
            
            self.init(rawValue: last)
        }
        
        // MARK: Properties
        var type: String {
            return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
        }
    }
    
    // MARK: Static Properties
    static let applicationShortcutUserInfoIconKey = "applicationShortcutUserInfoIconKey"
    
    // MARK: Properties
    var window: UIWindow?
    
    /// Saved shortcut item used as a result of an app launch, used later when app is activated.
    var launchedShortcutItem: UIApplicationShortcutItem?
    
    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        
        // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
        
        guard let shortCutType = shortcutItem.type as String? else { return false }
        
        switch (shortCutType) {
        case ShortcutIdentifier.First.type:
            // Handle shortcut 1 (static).
            handled = true
            break
        case ShortcutIdentifier.Second.type:
            // Handle shortcut 2 (static).
            handled = true
            break
        default:
            break
        }
        return handled
    }
    
    // MARK: Application Life Cycle
    func applicationDidBecomeActive(_ application: UIApplication) {
//        guard let shortcut = launchedShortcutItem else { return }
//        handleShortCutItem(shortcut)
//        launchedShortcutItem = nil
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        var shouldPerformAdditionalDelegateHandling = true
        
        // If a shortcut was launched, display its information and take the appropriate action
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            launchedShortcutItem = shortcutItem
            
            // This will block "performActionForShortcutItem:completionHandler" from being called.
            shouldPerformAdditionalDelegateHandling = true //false를 true로 바꾸었더니 뷰가 겹치지 않고 잘됨 ???
        }
        
        
        return shouldPerformAdditionalDelegateHandling
    }
    
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void) {
            completionHandler(handleShortcut(shortcutItem))
    }
    fileprivate func handleShortcut(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = ShortcutIdentifier(fullType: shortcutType) else {
            return false
        }
        
        return selectForIdentifier(shortcutIdentifier)
    }
    
    fileprivate func selectForIdentifier(_ identifier: ShortcutIdentifier) -> Bool {
        
        guard let vController = self.window?.rootViewController as? ViewController else {
            return false
        }
        
                
        switch (identifier) {
        case .First:
            
            let me = vController.storyboard!.instantiateViewController(withIdentifier: "melonVC")
            me.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            vController.dismiss(animated: true, completion: nil)
            vController.present(me, animated: true, completion: nil)
            
            return true
        case .Second:
            let mo = vController.storyboard!.instantiateViewController(withIdentifier: "movieVC")
            mo.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            vController.dismiss(animated: true, completion: nil)
            vController.present(mo, animated: true, completion: nil)
            return true
        }
    }
}




