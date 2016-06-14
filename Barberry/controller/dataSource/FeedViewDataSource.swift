//
//  TopDataSource.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/11.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class FeedViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate  {
    
    var delegate: TopViewController?
    var scrollBeginingPoint: CGPoint = CGPointMake(0, 0)
    var feedModels = [FeedModel]()
    
    var userNames: [String] = []
    var mMapIndexer:[[FeedModel]] = [[]]
    
    var page:Int32 = 1
    
    /*
     セクションの数を返す.
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //        return mSections.count != 0 ? (mSections.count) : 1
        return 1
    }
    
    /*
     1セクションに表示する配列の総数を返す.
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return feedModels?.count != nil ? (feedModels?.count)! : 0
        return userNames.count != 0 ? (userNames.count) : 0
        
    }
    
    /*
     セルの中身
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell") as! FeedCell
        cell.delegate = delegate
        cell.feedModel = mMapIndexer[indexPath.row][0]
        cell.menuCount = mMapIndexer[indexPath.row].count
        return cell
    }
    
    //セルがタップされた時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        if !delegate!.myActivityIndicator.isAnimating(){//animation処理中じゃなければ。
            //プロフィールに遷移させる
            delegate!.selectedUserId = feedModels[indexPath.row].userId
            delegate!.performSegueWithIdentifier("goToOtherProfile", sender: self)
            
        }
    }
    
    //セクションのリストを作るメソッド
    func createSections(){
        
        userNames = []
        mMapIndexer = [[]]
        
        var beforeUserName = ""
        var userNumber = 0
        var beforeDate = "1991/07/15 09:11"
        
        for i in 0 ..< feedModels.count {
            let feedModel = feedModels[i]
            let userName = feedModel.name
            let date = feedModel.date
            
            //「名前違う」または「時間が30分以上違う」場合、次のセルに行く
            if beforeUserName != userName || checkInterval(beforeDate, date2: date) {
                userNames.append(userName)
                beforeUserName = userName
                beforeDate = date
                if(i != 0){
                    userNumber += 1
                    mMapIndexer.append([FeedModel]())
                }
            }
            mMapIndexer[userNumber].append(feedModel)
        }
    }
    
    //2つの日付の時間差が30分以上だったらtrue
    func checkInterval(date1: String, date2: String) -> Bool{
        
        let nsDate1 = formatDate(date1)
        let nsDate2 = formatDate(date2)
        
        let span = nsDate1.timeIntervalSinceDate(nsDate2) // 1209600秒差
        let minuteSpan = span/60
        
        //30分以内だったらtrue
        if minuteSpan > 30 {
            return true
        }else{
            return false
        }
    }
    
    // "yyyy/MM/dd HH:mm" -> NSDate型
    func formatDate(date: String) -> NSDate{
        
        //日付
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        return dateFormatter.dateFromString(date)!
        
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //scrollBeginingPoint = scrollView.contentOffset;
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //一番下までスクロールしたかどうか
        if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)){
            //まだ表示するコンテンツが存在するか判定し存在するなら○件分を取得して表示更新する
            if delegate?.feedDataSource?.feedModels.count > 50 {
                delegate!.feedApiModel?.doDataRequest(page)
                page += 1
            }
            
        }
        
        //            let currentPoint = scrollView.contentOffset;
        //            if(scrollBeginingPoint.y < currentPoint.y){
        //                print("下へスクロール")
        //                if currentPoint.y > 200 {
        //                    delegate!.navigationController?.setNavigationBarHidden(true, animated: true)
        //                }
        //
        //
        //            }else{
        //                print("上へスクロール")
        //                delegate!.navigationController?.setNavigationBarHidden(false, animated: true)
        //            }
    }
    
    
    
}