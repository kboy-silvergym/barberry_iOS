//
//  MultiSetView.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/17.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class MultiSetView: UIView {
    
    var delegate: InputViewController?
    var dataSource: MultiSetTableDataSource?
    
    @IBOutlet weak var deletButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var workoutModels = [WorkoutModel]() {
        
        didSet {
            
            let log = UINib(nibName: "WorkoutLogCell", bundle:nil)
            self.tableView.registerNib(log, forCellReuseIdentifier: "WorkoutLogCell")
            
            let log2 = UINib(nibName: "WorkoutLogCell2", bundle:nil)
            self.tableView.registerNib(log2, forCellReuseIdentifier: "WorkoutLogCell2")
            
            tableView.estimatedRowHeight = 44//だいたいの高さの見積もり
            tableView.rowHeight = UITableViewAutomaticDimension
            
            let footer = UIView(frame: CGRectZero)
            footer.backgroundColor = UIColor.groupTableViewBackgroundColor()
            tableView.tableFooterView = footer
            
            dataSource = MultiSetTableDataSource()
            dataSource?.delegate = delegate
            dataSource?.workoutModels = self.workoutModels
            tableView.delegate = dataSource
            tableView.dataSource = dataSource
            tableView.reloadData()
            
        }
        
    }
    
    //編集
    @IBAction func editButton(sender: AnyObject) {
        
        delegate!.editButtonFlg = true
        delegate!.performSegueWithIdentifier("goToEdit", sender: self)
        
    }

    //プラスボタン
    @IBAction func plusButton(sender: AnyObject) {
        
        let newModel = WorkoutModel()
        let copy = workoutModels[(workoutModels.count) - 1]
        newModel.name = copy.name
        newModel.kg = copy.kg
        newModel.reps = copy.reps
        newModel.set = (workoutModels.count) + 1
        
        workoutModels.append(newModel)
        dataSource?.workoutModels = workoutModels
        
        tableView.reloadData()
        delegate!.setButton.setTitle("×" + (workoutModels.count).description, forState: .Normal)
        
    }
    
    //ゴミ箱
    @IBAction func deleteButton(sender: AnyObject) {
        
        if workoutModels.count != 1 {
            workoutModels.removeLast()
        }
        dataSource?.workoutModels = workoutModels
        
        tableView.reloadData()
        
        delegate!.setButton.setTitle("×" + (workoutModels.count).description, forState: .Normal)
        
    }
    
}
