//
//  NewsApiModel.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/28.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import NCMB

class NewsApiModel {
    
    var newsModels: [NewsModel]?
    
    var delegate: TopViewController?
    
    func doDataRequest(){
        
        //くるくるスタート
        delegate!.myActivityIndicator.startAnimating()
        
        // TestClassクラスを検索するNCMBQueryを作成
        let query = NCMBQuery(className: "News")
        
        //上から新しい順
        query.orderByDescending("createDate")
        
        // データストアの検索を実施
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if (error != nil){
                // 検索失敗時の処理
                
            }else{
                
                self.newsModels = []
                
                for i in 0 ..< objects.count {
                    
                    let name = objects[i].objectForKey("name") as! String
                    let news = objects[i].objectForKey("news") as! String
                    let date = objects[i].objectForKey("date") as! String
                    
                    
                    let newsModel = NewsModel()
                    newsModel.name = name
                    newsModel.news = news
                    newsModel.date = date
                    
                    self.newsModels?.append(newsModel)
                }
                
                self.delegate!.newsDataSource?.newsModels = self.newsModels
                self.delegate!.tableView.reloadData()
                
                //くるくるストップ
                self.delegate!.myActivityIndicator.stopAnimating()
            }
        })
        
    }
    
}


