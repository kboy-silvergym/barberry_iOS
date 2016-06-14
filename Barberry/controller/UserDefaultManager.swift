//
//  UserDefaultManager.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/23.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class UserDefaultManager: NSObject {
    
    //シングルトンってやつ
    static var sharedInstance: UserDefaultManager = {
        return UserDefaultManager()
    }()
    
    // NSUserDefaults のインスタンス
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    
    //アプリ内に保存したログイン系のユーザーデータを取得
    func getLoginUserData() -> UserModel{
        
        let userModel = UserModel()
        userModel.name = userDefaults.objectForKey("name") as! String
        userModel.password = userDefaults.objectForKey("password") as! String
        return userModel
    }
    
    //すでに会員登録している？
    func isRegister() -> Bool{
        return userDefaults.boolForKey("isRegister")
    }
    
    //アプリ内にログイン系のユーザーデータを保存する
    func saveLoginUserData(userModel: UserModel){
        userDefaults.setBool(true, forKey: "isRegister")
        userDefaults.setObject(userModel.name, forKey: "name")
        userDefaults.setObject(userModel.password, forKey: "password")
        userDefaults.synchronize()
        
    }
    
    //アプリ内にユーザーの情報を取り出す
    func getUserData() -> UserModel {
        let userModel = UserModel()
        userModel.name = userDefaults.objectForKey("name") as! String
        userModel.imgUrl = userDefaults.objectForKey("imgUrl") as! String
        userModel.height = userDefaults.objectForKey("height") as! Int
        userModel.weight = userDefaults.objectForKey("weight") as! Int
        
        
        return userModel
    }
    
    //アプリ内にユーザーの情報を保存する
//    func saveUserData(userModel: UserModel){
//        
//        //userDefaults.setObject(userModel.name, forKey: "name")
//        userDefaults.setObject(userModel.imgUrl, forKey: "imgUrl")
//        userDefaults.setObject(userModel.height, forKey: "height")
//        userDefaults.setObject(userModel.weight, forKey: "weight")
//        
//    }
    
    
    
    
    
}
