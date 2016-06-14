//
//  SearchViewDataSource.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/12.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class SearchViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate  {
    
    var delegate: TopViewController?
    
    
    /*
     セクションの数を返す.
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //        return mSections.count != 0 ? (mSections.count) : 1
        return 1
    }
    
    //セルの高さ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.size.height - 64 - 48
    }
    
    
    /*
     1セクションに表示する配列の総数を返す.
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return workoutModels?.count != nil ? (workoutModels?.count)! : 0
        //return mSections.count != 0 ? (mMapIndexer[section].count) : 0
        return 1
    }
    
    /*
     セルの中身
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ComingSoonCell") as! ComingSoonCell
        cell.delegate = delegate
        return cell
    }
    
    //セルがタップされた時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        
        
    }
    
    
    
    
}
