//
//  OtherProfileApiModel.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/30.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import NCMB

class OtherProfileApiModel {
    
    var delegate: ProfileViewController?
    var workoutModels: [WorkoutModel]?
    var userModel: UserModel?
    
    func doUserDataRequest(userId: String){
        
        //くるくるスタート
        delegate!.myActivityIndicator.startAnimating()
        
        let query = NCMBUser.query()
        
        /** 条件を入れる場合はここに書きます **/
        query.whereKey("objectId", equalTo: userId)
        
        // データストアの検索を実施
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if (error != nil){
                // 検索失敗時の処理
                print(error)
                
            }else{
                print("success")
                
                self.userModel = UserModel()
                self.userModel!.name = objects[0].objectForKey("displayName") as! String
                self.userModel!.imgUrl = objects[0].objectForKey("imgUrl") as! String
                self.userModel!.height = objects[0].objectForKey("height") as! Int
                self.userModel!.weight = objects[0].objectForKey("weight") as! Int
                self.userModel!.word = objects[0].objectForKey("word") as! String
                
                self.delegate!.navigationItem.title = self.userModel!.name
                self.doDataRequest(objects[0] as! NCMBUser)
            }
            
        })
    }

    
    
    func doDataRequest(user: NCMBUser){
        
        // TestClassクラスを検索するNCMBQueryを作成
        let query = NCMBQuery(className: "Log")
        
        /** 条件を入れる場合はここに書きます **/
        
        //対象のログだけに絞る
        let userQuery =  NCMBUser.query()
        userQuery.whereKey("objectId", equalTo: user.objectId)
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
                
                self.delegate!.dataSource?.delegate = self.delegate
                self.delegate?.userModel = self.userModel
                self.delegate!.dataSource?.userModel = self.userModel
                self.delegate!.dataSource?.workoutModels = self.workoutModels
                self.delegate!.dataSource?.createSections()
                self.delegate!.tableView.reloadData()
                
                //くるくるストップ
                self.delegate!.myActivityIndicator.stopAnimating()
            }
        })
        
    }
    
    
    
}

