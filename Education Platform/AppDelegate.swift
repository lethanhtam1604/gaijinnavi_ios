
//
//  AppDelegate.swift
//  Education Platform
//
//  Created by Duy Cao on 11/26/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import CoreData
import PureLayout
import IQKeyboardManager
import Fabric
import Crashlytics
import Localize_Swift
import FacebookCore
import Google
import UserNotifications
import Alamofire
import ESPullToRefresh
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.black
        self.window?.makeKeyAndVisible()
        
        if UserDefaultManager.getInstance().getCurrentLanguage() == 0 {
            Localize.setCurrentLanguage("en")
            UserDefaultManager.getInstance().setLanguageCode(value: "en")
        }
        else {
            let language = LanguageManager.getInstance().languages[UserDefaultManager.getInstance().getCurrentLanguage()!]
            Localize.setCurrentLanguage(language.code)
        }
        
        self.window?.rootViewController = SplashScreenViewController()
        
        //Crashlytics
        Fabric.with([Crashlytics.self])
        
        //set light status bar for whole ViewController
        UIApplication.shared.statusBarStyle = .lightContent
        
        // keyboard
        let keyboardManager = IQKeyboardManager.shared()
        keyboardManager.isEnabled = true
        keyboardManager.previousNextDisplayMode = .alwaysShow
        keyboardManager.shouldShowTextFieldPlaceholder = false
        
        //FB
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Google
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        
        //Local Notification
        
        if #available(iOS 10.0, *){
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert, .sound]
            center.requestAuthorization(options: options) {
                (granted, error) in
                if !granted {
                }
            }
        }
        else{
            let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
        
        let userNotificationTypes: UIUserNotificationType = [.alert, .badge, .sound]
        let settings = UIUserNotificationSettings(types: userNotificationTypes , categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        //change orientation
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        return true
    }
    
    var isInit = false
    func rotated() {
        if isInit {
            return
        }
  
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            Global.SCREEN_WIDTH = UIScreen.main.bounds.size.height
            Global.SCREEN_HEIGHT = UIScreen.main.bounds.size.width
            isInit = true
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            Global.SCREEN_WIDTH = UIScreen.main.bounds.size.width
            Global.SCREEN_HEIGHT = UIScreen.main.bounds.size.height
            isInit = true
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        WebSocketServices.shared.Disconnect()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let currentUser = UserDefaultManager.getInstance().getCurrentUser()
        
        if currentUser == nil {
            return
        }
        
        if(currentUser?.User.Id != 0) {
            WebSocketServices.shared.Connect(UserId: (currentUser?.User.Id)!, Token: (currentUser?.User.Token)!)
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadMessages"), object: nil)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options) || GIDSignIn.sharedInstance().handle(url,sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return SDKApplicationDelegate.shared.application(application,
                                                         open: url,
                                                         sourceApplication: sourceApplication,
                                                         annotation: annotation)
    }
}

