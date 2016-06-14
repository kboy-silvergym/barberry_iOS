//
//  PersonalLogApiModel.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/16.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import NCMB

class PersonalLogApiModel {
    
    var delegate: TopViewController?
    var workoutModels: [WorkoutModel]?
    
    func doDataRequest(){
        
        //くるくるスタート
        delegate!.myActivityIndicator.startAnimating()
        
        // TestClassクラスを検索するNCMBQueryを作成
        let query = NCMBQuery(className: "Log")
        
        /** 条件を入れる場合はここに書きます **/
        
        //自分のログだけに絞る
        let userQuery =  NCMBQuery(className: "user")
        userQuery.whereKey("objectId", equalTo: NCMBUser.currentUser().objectId)
        query.whereKey("user", matchesQuery: userQuery)
        
        //ジャンルの順番（0から昇順）
        query.orderByDescending("createDate")
        
        // データストアの検索を実施
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if (error != nil){
                // 検索失敗時の処理
                
            }else{
                
                self.workoutModels = []
                
                for i in 0 ..< objects.count {
                    //let id = objects[i].objectForKey("id") as! Int
                    
                    let date = objects[i].objectForKey("date") as! NSString
                    let strDate = date.substringToIndex(10)

                    let name = objects[i].objectForKey("name") as! String
                    let kg = objects[i].objectForKey("kg") as! Int
                    let reps = objects[i].objectForKey("reps") as! Int
                    let set = objects[i].objectForKey("set") as! Int
                    
                    let workoutModel = WorkoutModel()
                    workoutModel.name = name
                    workoutModel.date = strDate
                    workoutModel.kg = kg
                    workoutModel.reps = reps
                    workoutModel.set = set
                    
                    self.workoutModels?.append(workoutModel)
                }
                
                self.delegate!.myPageDataSource?.workoutModels = self.workoutModels
                self.delegate!.myPageDataSource?.createSections()
                self.delegate!.tableView.reloadData()
                
                //くるくるストップ
                self.delegate!.myActivityIndicator.stopAnimating()
            }
        })
        
    }
    
    
    
}
