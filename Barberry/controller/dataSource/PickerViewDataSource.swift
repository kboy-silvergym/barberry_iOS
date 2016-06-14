//
//  PickerViewDataSource.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/09.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class PickerViewDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var delegate: InputViewController?
    var numbers = [String]()
    
    //表示列
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //表示個数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
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
        
        label.text = numbers[row]
        
        return label
    }
    
    //選択時
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        delegate!.repsTextField.text = numbers[row]
    }
    
    //配列numbersを作る
    func makingNumbers(number: Int){
        
        for i in 0...number {
            let str = i.description
            numbers.append(str)
    
        }
        
        
    }
    
    
}
