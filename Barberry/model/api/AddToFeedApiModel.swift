//
//  AddToFeedApiModel.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/28.
//  Copyright © 2016年 藤川慶. All rights reserved.
//
// 筋トレ記録を保存する際に、feedのテーブルにも専用のモデルで突っ込むクラス

import UIKit
import NCMB

class AddToFeedApiModel {
    
    var delegate: InputViewController?
    
    func doDataRequest(workoutModels: [WorkoutModel]){
        
        //くるくるスタート
        delegate!.myActivityIndicator.startAnimating()
        
        let user = NCMBUser.currentUser()
        let userName = user.objectForKey("displayName")
        let userImgUrl = user.objectForKey("imgUrl")
        
        let workoutName = workoutModels[0].name
        
        // クラスのNCMBObjectを作成
        let obj = NCMBObject(className: "Feed")
        obj.setObject(workoutName, forKey: "workoutName")
        obj.setObject(formatDate(), forKey: "date")
        obj.setObject(user, forKey: "user")
        obj.setObject(userName, forKey: "userName")
        obj.setObject(userImgUrl, forKey: "userImgUrl")
        
        // データストアへの保存を実施
        obj.saveInBackgroundWithBlock({(error) in
            if (error != nil) {
                // 保存に失敗した場合の処理
                print(error)
            }else{
                // 保存に成功した場合の処理
                print("フィード保存成功！")
                
            }
        })
        
        //くるくるストップ
        self.delegate!.myActivityIndicator.stopAnimating()
    }
    
    
    
    func formatDate() -> String{
        
        //日付
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") // ロケールの設定
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm" // 日付フォーマットの設定
        return dateFormatter.stringFromDate(NSDate()) // -> 2014/06/25 02:13:18
        
    }
    
    
    
}

