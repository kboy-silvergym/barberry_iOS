//
//  MultiPickerViewDataSource.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/19.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class MultiPickerViewDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var delegate: EditViewController?
    var numbers = [String]()
    var numbers2 = [String]()
    
    //表示列
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //表示個数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return numbers.count
        }else{
            return numbers2.count
        }
    }
    
    //表示内容
    //    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        return numbers[row]
    //    }
    
    // pickerに表示するUIViewを返す
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(32)
        //中央寄せ
        label.textAlignment = NSTextAlignment.Center
        label.frame = CGRectMake(0, 0, 200, 30)
        if component == 0 {
            label.text = numbers[row] + "kg"
        }else{
            label.text = numbers2[row] + "reps"
        }
        return label
    }
    
    //選択時
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if component == 0 {
            //kg
            delegate!.transaction![(delegate?.selectedIndexPath?.row)!].kg = Int(numbers[row])!
        }else{
            //reps
            delegate!.transaction![(delegate?.selectedIndexPath?.row)!].reps = Int(numbers2[row])!
        }
        delegate?.dataSource?.workoutModels = delegate!.transaction
        delegate!.tableView.reloadData()
    }
    
    //配列numbersを作る
    func makingNumbers(number: Int){
        
        for i in 0...number {
            let str = i.description
            numbers.append(str)
        }
    }
    
    //配列numbers2を作る
    func makingNumbers2(number: Int){
        
        for i in 0...number {
            let str = i.description
            numbers2.append(str)
        }
    }

    
    
}

