//
//  NewsViewDataSource.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/12.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class NewsViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate  {
    
    var delegate: TopViewController?
    var newsModels: [NewsModel]?
    
    
    /*
     セクションの数を返す.
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    /*
     1セクションに表示する配列の総数を返す.
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModels?.count != nil ? (newsModels?.count)! : 0
    }
    
    
    /*
     セルの中身
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell",forIndexPath: indexPath) as! NewsCell
        cell.newsModel = self.newsModels![indexPath.row]
        return cell
    }
    
    
    //セルがタップされた時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
       
        //画面遷移(ご意見ご要望フォーム)
         delegate!.performSegueWithIdentifier("goToInquiry", sender: self)
        
    }
    
    
    
    
}
