//
//  SelectionTableViewDataSource.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/03.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
class SelectionTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate  {
    
    var delegate: InputViewController?
    var workoutModels: [WorkoutModel]?
    var mSections: [String] = []
    var mMapIndexer:[[String]] = [[]]
    
    /*
     セクションの数を返す.
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mSections.count != 0 ? (mSections.count) : 1
    }
    
    /*
     セクションのタイトルを返す.
     */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mSections.count != 0 ? (mSections[section]) : ""
    }
    
    /*
     1セクションに表示する配列の総数を返す.
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return workoutModels?.count != nil ? (workoutModels?.count)! : 0
        
        //最後のsectionだけ一個多くしたい。
        
        if section == mMapIndexer.count - 1 {
            return (mMapIndexer[section].count) != 0 ? (mMapIndexer[section].count) + 1 : 1
        }else{
            return (mMapIndexer[section].count) != 0 ? (mMapIndexer[section].count) : 1
        }
    }
    
    /*
     セルの中身
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (mMapIndexer[0].count) == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("MuscleDefaultCell") as! MuscleDefaultCell
            return cell
        }else if indexPath.section == mMapIndexer.count - 1 && indexPath.row == mMapIndexer[mMapIndexer.count - 1].count {
            let cell = tableView.dequeueReusableCellWithIdentifier("ManualCell") as! ManualCell
            return cell
        }else{
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell.textLabel!.text = mMapIndexer[indexPath.section][indexPath.row]
            return cell
        }
    }
    
    //セルがタップされた時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        
        if indexPath.section == mMapIndexer.count - 1 && indexPath.row == mMapIndexer[mMapIndexer.count - 1].count {
            //マニュアル入力(キーボードを開く)
            delegate!.workoutNameTextField.becomeFirstResponder()
        }else{
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let name = cell?.textLabel?.text
            self.delegate!.workoutNameTextField.text = name
            self.delegate!.checkIsEnoughInfo()
        }
        
    }
    
    //セクションのリストを作るメソッド
    func createSections(){
        
        mSections = []
        mMapIndexer = [[]]
        
        var sectionName1 = ""
        var sectionName2 = ""
        var sectionName3 = ""
        var sectionName4 = ""
        var lastFlg = false
        
        var sectionNumber = 0
        
        for i in 0 ..< workoutModels!.count {
            let workoutModel = workoutModels![i]
            let genreName = workoutModel.getGenreName()
            
            if (genreName != sectionName1 && genreName != sectionName2 && genreName != sectionName3 && genreName != sectionName4) {
                mSections.append(genreName)
                
                if sectionName1 == "" {
                    sectionName1 = genreName
                }else if sectionName2 == "" {
                    sectionName2 = genreName
                }else if sectionName3 == "" {
                    sectionName3 = genreName
                }else if sectionName4 == "" {
                    sectionName4 = genreName
                }
                
                if(i != 0 && !lastFlg){
                    sectionNumber += 1
                    mMapIndexer.append([String]())
                    
                    if sectionName4 != "" {
                        lastFlg = true
                    }
                }
            }
            //ここも変えれる
            if genreName == sectionName1 {
                mMapIndexer[0].append(workoutModel.name)
            }else if genreName == sectionName2 {
                mMapIndexer[1].append(workoutModel.name)
            }else if genreName == sectionName3 {
                mMapIndexer[2].append(workoutModel.name)
            }else if genreName == sectionName4 {
                mMapIndexer[3].append(workoutModel.name)
            }else{
                mMapIndexer[sectionNumber].append(workoutModel.name)
            }
            
        }
    }
    
}
