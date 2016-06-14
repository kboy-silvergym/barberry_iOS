//
//  AppDelegate.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/01.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import NCMB
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let APPLICATION_KEY = ""
    let CLIENT_KEY = ""
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //********** SDKの初期化 **********
        NCMB.setApplicationKey(APPLICATION_KEY, clientKey: CLIENT_KEY)
        
        //********** 例）データストアにデータを保存 **********
        let query = NCMBQuery(className: "TestClass")
        query.whereKey("message", equalTo: "Hello, NCMB!")
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if (error == nil) {
                if(objects.count > 0) {
                    let message = objects[0].objectForKey("message") as! NSString
                    print("[FIND] \(message)")
                } else {
                    var saveError: NSError?
                    let obj = NCMBObject(className: "TestClass")
                    obj.setObject("Hello, NCMB!", forKey: "message")
                    obj.save(&saveError)
                    if(saveError == nil) {
                        print("[SAVE] Done.")
                    } else {
                        print("[SAVE ERROR] \(saveError)")
                    }
                }
            } else {
                print(error.localizedDescription)
            }
        })
        
        //スプラッシュ時間
        //sleep(3)
        
        //navigationBarTitleの色
        //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.hex("ffffff", alpha: 1.0)]
        
//        return true
        
        /** 追加② **/
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        /** 追加① **/
        FBSDKAppEvents.activateApp()
    }
    
    /** 追加③ **/
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?,annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

