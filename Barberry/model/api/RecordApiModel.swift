//
//  RecordApiModel.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/16.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import NCMB

class RecordApiModel {
    
    
    var delegate: InputViewController?
    
    func doDataRequest(workoutModels: [WorkoutModel]){
        
        //くるくるスタート
        delegate!.myActivityIndicator.startAnimating()
        
        let user = NCMBUser.currentUser()
    
        //.reverse()で逆順に回している
        for model in workoutModels.reverse() {
            
            //0.3秒待つ
            usleep(300000)
            
            // クラスのNCMBObjectを作成
            let obj = NCMBObject(className: "Log")
            obj.setObject(model.name, forKey: "name")
            obj.setObject(model.kg, forKey: "kg")
            obj.setObject(model.reps, forKey: "reps")
            obj.setObject(model.interval, forKey: "interval")
            obj.setObject(model.set, forKey: "set")
            
            obj.setObject(formatDate(), forKey: "date")
            obj.setObject(user, forKey: "user")
            
            //obj.setObject(1, forKey: "number")
            //obj.setObject(["A", "B", "C"], forKey: "array")
            
            // データストアへの保存を実施
            obj.saveInBackgroundWithBlock({(error) in
                if (error != nil) {
                    // 保存に失敗した場合の処理
                    print("エラー")
                }else{
                    // 保存に成功した場合の処理
                    print("成功！")
                    
                }
            })

            
        }
        
        delegate!.setView?.dataSource?.workoutModels?.removeAll()
        delegate!.setView?.tableView.reloadData()
        
        //くるくるストップ
        self.delegate!.myActivityIndicator.stopAnimating()
        
    }
    
    func formatDate() -> String{
        
        //日付
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") // ロケールの設定
        dateFormatter.dateFormat = "yyyy/MM/dd" // 日付フォーマットの設定
        return dateFormatter.stringFromDate(NSDate()) // -> 2014/06/25 02:13:18
        
    }

    
    
}
