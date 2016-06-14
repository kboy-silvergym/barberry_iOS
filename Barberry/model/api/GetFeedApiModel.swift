//
//  GetFeedApiModel.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/28.
//  Copyright © 2016年 藤川慶. All rights reserved.
//
// feedを受け取るクラス

import UIKit
import NCMB

class GetFeedApiModel {
    
    //var feedModels: [FeedModel]?
    
    var delegate: TopViewController?
    
    func doDataRequest(page: Int32) {
        
        //くるくるスタート(くるくるしてなかったら)
        if !delegate!.myActivityIndicator.isAnimating() {
            delegate!.myActivityIndicator.startAnimating()
            
            // TestClassクラスを検索するNCMBQueryを作成
            let query = NCMBQuery(className: "Feed")
            
            //公開にしている人のみに絞る
            let userQuery = NCMBUser.query()
            userQuery.whereKey("isOpen", equalTo: true)
            query.whereKey("user", matchesQuery: userQuery)
            
            //ジャンルの順番（0から昇順）
            query.orderByDescending("createDate")
            
            //50件まで取得
            query.limit = 50
            
            //ページングで使う。最初は0ページ
            query.skip = (10 * page)
            
            // データストアの検索を実施
            query.findObjectsInBackgroundWithBlock({(objects, error) in
                if (error != nil){
                    // 検索失敗時の処理
                    self.delegate!.myActivityIndicator.stopAnimating()
                }else{
                    
                    //self.feedModels = []
                    
                    for i in 0 ..< objects.count {
                        
                        let user = objects[i].objectForKey("user") as! NCMBUser
                        let userName = objects[i].objectForKey("userName") as! String
                        let imgUrl = objects[i].objectForKey("userImgUrl") as! String
                        
                        let workoutName = objects[i].objectForKey("workoutName") as! String
                        let date = objects[i].objectForKey("date") as! String
                        
                        let feedModel = FeedModel()
                        
                        feedModel.userId = user.objectId
                        feedModel.name = userName
                        feedModel.imgUrl = imgUrl
                        feedModel.date = date
                        feedModel.workoutName = workoutName
                        
                        self.delegate!.feedDataSource?.feedModels.append(feedModel)
                    }
                    
                    self.delegate!.feedDataSource?.createSections()
                    self.delegate!.tableView.reloadData()
                    
                    //くるくるストップ
                    self.delegate!.myActivityIndicator.stopAnimating()
                }
            })
            
        }
    }
}

