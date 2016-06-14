//
//  CustomKeyboard.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/08.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import Foundation
import UIKit

class CustomKeyboardView: UIView {
    
    var delegate: InputViewController?
    var digit1 = "0"
    var digit2 = ""
    var digit3 = ""
    
    var sum = 0
    var outPut = ""
    
    @IBOutlet weak var doneButton: UIButton!
    
    //0
    @IBAction func btn0(sender: AnyObject) {
        setText("0")
    }
    //1
    @IBAction func btn1(sender: AnyObject) {
        setText("1")
    }
    //2
    @IBAction func btn2(sender: AnyObject) {
        setText("2")
    }
    //3
    @IBAction func btn3(sender: AnyObject) {
        setText("3")
    }
    //4
    @IBAction func btn4(sender: AnyObject) {
        setText("4")
    }
    //5
    @IBAction func btn5(sender: AnyObject) {
        setText("5")
    }
    //6
    @IBAction func btn6(sender: AnyObject) {
        setText("6")
    }
    //7
    @IBAction func btn7(sender: AnyObject) {
        setText("7")
    }
    //8
    @IBAction func btn8(sender: AnyObject) {
        setText("8")
    }
    //9
    @IBAction func btn9(sender: AnyObject) {
        setText("9")
    }
    
    //自重
    @IBAction func btnPoint(sender: AnyObject) {
//        setText("自重")
        delegate!.weightTextField.text = "自重"
        doneBtn(doneButton)
    }
    
    //一文字削除
    @IBAction func deleteBtn(sender: AnyObject) {
        
        if digit2 == "" && digit3 == "" {
            digit1 = "0"
        }else if digit3 == "" {
            digit2 = ""
        }else {
            digit3 = ""
        }
        
        delegate!.weightTextField.text = getOutPut()
    }
    
    //クリア
    @IBAction func clearBtn(sender: AnyObject) {
        clear()
    }
    
    func clear(){
        digit1 = "0"
        digit2 = ""
        digit3 = ""
        
        if delegate!.weightTextField.text != "" {
            outPut = getSum().description
            delegate!.weightTextField.text = ""
        }
    }
    
    //完了(次へ)
    @IBAction func doneBtn(sender: AnyObject) {
        
        //キーボードを閉じる
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        UIView.animateWithDuration( 0.1, animations: {
            //self.view.layoutIfNeeded()
            self.frame.origin.y = screenHeight
        })
        
        //チェック
        delegate!.checkIsEnoughInfo()
        
    }
    
    
    func setText(i: String){
        
        //合計
        if digit1 == "0" && digit2 == "" && digit3 == "" {
            digit1 = i
        }else if digit2 == "" && digit3 == "" {
            digit2 = i
        }else {
            digit3 = i
        }
        
        delegate!.weightTextField.text = getOutPut()
    }

    
    func getSum() -> Int {
        
        //合計
        if digit2 == "" && digit3 == "" {
            sum = Int(digit1)!
        }else if digit3 == "" {
            let ten = Int(digit1)! * 10
            let one = Int(digit2)!
            sum = (ten + one)
        }else {
            let hundred = Int(digit1)! * 100
            let ten = Int(digit2)! * 10
            let one = Int(digit3)!
            sum = (hundred + ten + one)
        }
        return sum
    }
    
    func getOutPut() -> String{
        if getSum() == 0 {
            outPut = ""
        }else{
            outPut = getSum().description
        }
        return outPut
    }
    
    
}
