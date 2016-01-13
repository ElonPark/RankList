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
            guard let last = fullType.componentsSeparatedByString(".").last else { return nil }
            
            self.init(rawValue: last)
        }
        
        // MARK: Properties
        var type: String {
            return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
        }
    }
    
    // MARK: Static Properties
    static let applicationShortcutUserInfoIconKey = "applicationShortcutUserInfoIconKey"
    
    // MARK: Properties
    var window: UIWindow?
    
    /// Saved shortcut item used as a result of an app launch, used later when app is activated.
    var launchedShortcutItem: UIApplicationShortcutItem?
    
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
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
    func applicationDidBecomeActive(application: UIApplication) {
        guard let shortcut = launchedShortcutItem else { return }
        
        handleShortCutItem(shortcut)
        
        launchedShortcutItem = nil
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        var shouldPerformAdditionalDelegateHandling = true
        
        // If a shortcut was launched, display its information and take the appropriate action
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            
            launchedShortcutItem = shortcutItem
            
            // This will block "performActionForShortcutItem:completionHandler" from being called.
            shouldPerformAdditionalDelegateHandling = true //false를 true로 바꾸었더니 뷰가 겹치지 않고 잘됨 ???
        }
        
        
        return shouldPerformAdditionalDelegateHandling
    }
    
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem,
        completionHandler: (Bool) -> Void) {
            completionHandler(handleShortcut(shortcutItem))
    }
    private func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = ShortcutIdentifier(fullType: shortcutType) else {
            return false
        }
        
        return selectForIdentifier(shortcutIdentifier)
    }
    
    private func selectForIdentifier(identifier: ShortcutIdentifier) -> Bool {
        
        guard let vController = self.window?.rootViewController as? ViewController else {
            return false
        }
        
                
        switch (identifier) {
        case .First:
            
            let me = vController.storyboard!.instantiateViewControllerWithIdentifier("melonVC")
            me.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            vController.dismissViewControllerAnimated(true, completion: nil)
            vController.presentViewController(me, animated: true, completion: nil)
            
            return true
        case .Second:
            let mo = vController.storyboard!.instantiateViewControllerWithIdentifier("movieVC")
            mo.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            vController.dismissViewControllerAnimated(true, completion: nil)
            vController.presentViewController(mo, animated: true, completion: nil)
            return true
        }
    }
}




