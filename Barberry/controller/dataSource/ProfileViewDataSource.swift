//
//  MyPageViewDataSource.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/12.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import NCMB

class ProfileViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate  {
    
    var delegate: ViewController?
    var workoutModels: [WorkoutModel]?
    var mSections: [String] = []
    var mMapIndexer:[[WorkoutModel]] = [[]]
    var scrollBeginingPoint: CGPoint = CGPointMake(0, 0)
    var userModel: UserModel?
    
    
    /*
     セクションの数を返す.
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mSections.count != 0 ? (mSections.count) + 1 : 1
    }
    
    //headerの高さ
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 26
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            return UIView(frame: CGRectZero)
        }else{
            let header = tableView.dequeueReusableCellWithIdentifier("DateHeaderCell") as! DateHeaderCell
            header.date.text = mSections[section - 1]
            return header
            
        }
    }
    
    
    /*
     1セクションに表示する配列の総数を返す.
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return workoutModels?.count != nil ? (workoutModels?.count)! : 0
        
        if userModel == nil {
            return 0
        }else if mSections.count == 0 {
            return 1
        }else{
            if section == 0{
                return 1
            }else{
                return mMapIndexer[section - 1].count
            }
        }
    }
    
    /*
     セルの中身
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell",forIndexPath: indexPath) as! ProfileCell
            cell.delegate = delegate
            cell.userModel = userModel!
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        default:
            
            var before = ""
            
            if indexPath.row != 0 {
                before = mMapIndexer[indexPath.section - 1][indexPath.row - 1].name
            }
            
            let now = mMapIndexer[indexPath.section - 1][indexPath.row].name
            
            if before != now {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("OnlyNameCell",forIndexPath: indexPath) as! OnlyNameCell
                cell.name?.text = mMapIndexer[indexPath.section - 1][indexPath.row].name
                cell.name?.textColor = UIColor.hex("2b2b2b", alpha: 1.0)
                
                let set = mMapIndexer[indexPath.section - 1][indexPath.row].set
                cell.set?.text = set.description + "."
                cell.set?.textColor = UIColor.lightGrayColor()
                
                let kg = mMapIndexer[indexPath.section - 1][indexPath.row].kg
                let reps = mMapIndexer[indexPath.section - 1][indexPath.row].reps
                
                if kg == 0{
                    cell.kg?.text = "自重"
                }else{
                    cell.kg?.text = kg.description
                }
                
                cell.reps?.text = reps.description
                
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WorkoutLogCell2",forIndexPath: indexPath) as! WorkoutLogCell2
                
                let set = mMapIndexer[indexPath.section - 1][indexPath.row].set
                cell.name?.text = set.description + "."
                cell.name?.textColor = UIColor.lightGrayColor()
                
                let kg = mMapIndexer[indexPath.section - 1][indexPath.row].kg
                let reps = mMapIndexer[indexPath.section - 1][indexPath.row].reps
                
                if kg == 0{
                    cell.kg?.text = "自重"
                }else{
                    cell.kg?.text = kg.description
                }
                
                cell.reps?.text = reps.description
                
                return cell
            }
            
        }
        
    }
    
    //セルがタップされた時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        
    }
    
//    //削除ボタン
//    func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
//        
//        if indexPath.section != 0 {
//            
//            var before = ""
//            
//            if indexPath.row != 0 {
//                before = mMapIndexer[indexPath.section - 1][indexPath.row - 1].name
//            }
//            
//            let now = mMapIndexer[indexPath.section - 1][indexPath.row].name
//            
//            if before != now {
//                return true
//            }else{
//                return false
//            }
//        }
//        
//        return false
//        
//    }
//    
//    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String?{
//        return "削除"
//    }
//    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Delete {
//            
//        }
//    }
    
    
    //セクションのリストを作るメソッド
    func createSections(){
        
        mSections = []
        mMapIndexer = [[]]
        
        var beforeSectionName = ""
        var sectionNumber = 0
        
        for i in 0 ..< workoutModels!.count {
            let workoutModel = workoutModels![i]
            let sectionName = workoutModel.date
            
            if (beforeSectionName != sectionName) {
                mSections.append(sectionName)
                beforeSectionName = sectionName
                if(i != 0){
                    sectionNumber += 1
                    mMapIndexer.append([WorkoutModel]())
                }
            }
            mMapIndexer[sectionNumber].append(workoutModel)
        }
    }
    
    //    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    //        scrollBeginingPoint = scrollView.contentOffset;
    //    }
    //
    //    func scrollViewDidScroll(scrollView: UIScrollView) {
    //        let currentPoint = scrollView.contentOffset;
    //        if(scrollBeginingPoint.y < currentPoint.y){
    //            print("下へスクロール")
    //            if currentPoint.y > 200 {
    //                delegate!.navigationController?.setNavigationBarHidden(true, animated: true)
    //            }
    //
    //        }else{
    //            print("上へスクロール")
    //            delegate!.navigationController?.setNavigationBarHidden(false, animated: true)
    //        }
    //    }
    
    
    
    
    
    
}
