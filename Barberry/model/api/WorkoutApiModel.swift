//
//  ChestWorkoutApiModel.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/05.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import NCMB

class WorkoutApiModel {
    
    //var workoutModels: [WorkoutModel]?
    
    var workoutModels: [WorkoutModel]?
    
    var delegate: InputViewController?
    //var partsEnum: PartsEnum?
    
    enum PartsEnum: Int {
        
        case CHEST = 0
        case BICEPS = 3
        case ABS = 2
        case TRICEPS = 4
        case SHOULDER = 1
        case LAT = 5
        case SPINAE = 6
        case TRAPEZIUS = 7
        case HIP = 8
        case QUADRICEPS = 10
        case HAM = 9
        case CALF = 11
        
    }
    
    func doDataRequest(partsEnum: PartsEnum){
        
        //くるくるスタート
        delegate!.myActivityIndicator.startAnimating()
        
        // TestClassクラスを検索するNCMBQueryを作成
        let query = NCMBQuery(className: "Workouts")
        
        /** 条件を入れる場合はここに書きます **/
        
        //部位を検索
        query.whereKey("part", equalTo: partsEnum.rawValue)
        
        //ジャンルの順番（0から昇順）
        query.orderByAscending("genre")
        
        // データストアの検索を実施
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if (error != nil){
                // 検索失敗時の処理
                
            }else{
                               
                self.workoutModels = []
                
                for i in 0 ..< objects.count {
//                    let id = objects[i].objectForKey("id") as! Int
                    let name = objects[i].objectForKey("name") as! String
                    let genre = objects[i].objectForKey("genre") as! Int
                    let workoutModel = WorkoutModel()
//                    workoutModel.id = id
                    workoutModel.name = name
                    workoutModel.genre = genre
                    
                    self.workoutModels?.append(workoutModel)
                }
                
                self.delegate!.tableDataSource?.workoutModels = self.workoutModels
                self.delegate!.tableDataSource?.createSections()
                self.delegate!.tableView.reloadData()
                self.delegate!.workoutNameButton((self.delegate?.workoutNameButton)!)
                
                //くるくるストップ
                self.delegate!.myActivityIndicator.stopAnimating()
            }
        })
        
    }
    
}
