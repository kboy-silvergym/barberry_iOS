//
//  EditViewDataSource.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/19.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class EditViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate  {
    
    var workoutModels: [WorkoutModel]?
    var delegate: EditViewController?
    var multiFlg = false
    
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("WorkoutLogCell",forIndexPath: indexPath) as! WorkoutLogCell
        
        if indexPath.row == 0 && !multiFlg {
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
        
        delegate!.showPickerView()
        delegate!.selectedIndexPath = indexPath
        
        let model = workoutModels![indexPath.row]
        delegate!.pickerView?.selectRow(model.kg, inComponent: 0, animated: true)
        delegate!.pickerView?.selectRow(model.reps, inComponent: 1, animated: true)
        
    }
    
}
