//
//  EditViewController.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/19.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class EditViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    var delegate: InputViewController?
    var transaction: [WorkoutModel]?
    var dataSource: EditViewDataSource?
    var pickerView: UIPickerView?
    var pickerDataSource: MultiPickerViewDataSource?
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let log = UINib(nibName: "WorkoutLogCell", bundle:nil)
        tableView.registerNib(log, forCellReuseIdentifier: "WorkoutLogCell")
        
        let log2 = UINib(nibName: "WorkoutLogCell2", bundle:nil)
        self.tableView.registerNib(log2, forCellReuseIdentifier: "WorkoutLogCell2")
        
        dataSource = EditViewDataSource()
        dataSource?.delegate = self
        dataSource?.workoutModels = transaction
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        let footer = UIView(frame: CGRectZero)
        footer.backgroundColor = UIColor.groupTableViewBackgroundColor()
        tableView.tableFooterView = footer
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //前画面で選択してきたセルをタップした状態にする
        if selectedIndexPath != nil {
            self.tableView.selectRowAtIndexPath(self.selectedIndexPath, animated: true, scrollPosition: .None)
            
            showPickerView()
            let model = transaction![selectedIndexPath!.row]
            pickerView?.selectRow(model.kg, inComponent: 0, animated: true)
            pickerView?.selectRow(model.reps, inComponent: 1, animated: true)
            
        }
    }
    
    //ドラムピッカーを出す
    func showPickerView(){
        
        let pickerViewHeight: CGFloat = 216
        
        if pickerView == nil {
            pickerView = UIPickerView()
            pickerView!.frame = CGRectMake(0, screenHeight, screenWidth, pickerViewHeight)
            pickerView?.backgroundColor = UIColor.groupTableViewBackgroundColor()
            
            pickerDataSource = MultiPickerViewDataSource()
            pickerDataSource?.delegate = self
            pickerDataSource?.makingNumbers(200)
            pickerDataSource?.makingNumbers2(50)
            pickerView!.delegate = pickerDataSource
            pickerView!.dataSource = pickerDataSource
            
            self.view?.addSubview(myKeyboard!)
            self.view.addSubview(pickerView!)
        }
        
        UIView.animateWithDuration( 0.1, animations: {
            self.pickerView!.frame.origin.y = self.screenHeight - pickerViewHeight
            self.myKeyboard!.frame.origin.y = self.screenHeight - pickerViewHeight - 40
        })
      
    }
    
    
    override func donePicker(sender: UIButton) {
        
        UIView.animateWithDuration( 0.1, animations: {
            self.pickerView!.frame.origin.y = self.screenHeight
            self.myKeyboard!.frame.origin.y = self.screenHeight
        })

    }

    
    //戻る
    @IBAction func doneButton(sender: AnyObject) {
        delegate?.transaction = transaction!
        delegate?.setView?.workoutModels = transaction!
        delegate?.setView?.tableView.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //プラスボタン
    @IBAction func plusButton(sender: AnyObject) {
        
        let newModel = WorkoutModel()
        let copy = transaction![(transaction?.count)! - 1]
        newModel.name = copy.name
        newModel.kg = copy.kg
        newModel.reps = copy.reps
        newModel.set = (transaction?.count)! + 1
        
        transaction?.append(newModel)
        dataSource?.workoutModels = transaction
        
        tableView.reloadData()
        
        delegate!.setButton.setTitle("×" + (transaction!.count).description, forState: .Normal)
    }
    
    //ゴミ箱
    @IBAction func deleteButton(sender: AnyObject) {
        
        if transaction!.count != 1 {
            transaction?.removeLast()
        }
        dataSource?.workoutModels = transaction
        
        tableView.reloadData()
        
        delegate!.setButton.setTitle("×" + (transaction!.count).description, forState: .Normal)
        
    }

    
}
