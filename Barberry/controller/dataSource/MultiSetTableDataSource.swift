//
//  MultiSetTableDataSource.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/18.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class MultiSetTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate  {
    
    var workoutModels: [WorkoutModel]?
    var multiFlg = false
    var delegate: InputViewController?
    
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
        return workoutModels?.count != nil ? (workoutModels?.count)! : 0
        
    }

    
    /*
     セルの中身
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if workoutModels!.count > 1 {
            multiFlg = true
        }else{
            multiFlg = false
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("WorkoutLogCell") as! WorkoutLogCell
        
        if indexPath.row == 0 && !multiFlg{
            cell.name?.text = workoutModels![indexPath.row].name
            cell.name?.textColor = UIColor.hex("2b2b2b", alpha: 1.0)
        }else{
            cell.name?.text = (indexPath.row + 1).description + "セット目"
            cell.name?.textColor = UIColor.lightGrayColor()
        }
        
        let kg = workoutModels![indexPath.row].kg
        let reps = workoutModels![indexPath.row].reps
        
        cell.kg?.text = kg.description
        cell.reps?.text = reps.description
        
        return cell
    }
    
    //セルがタップされた時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        
        delegate?.selectedIndexPath = indexPath
        delegate?.performSegueWithIdentifier("goToEdit", sender: delegate!)
        
    }
    
}
