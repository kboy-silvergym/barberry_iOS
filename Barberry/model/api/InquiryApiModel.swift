//
//  InquiryApiModel.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/29.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import NCMB

class InquiryApiModel {
    
    var delegate: InquiryViewController?
    
    func doDataRequest(inquiryText: String){
        
        //くるくるスタート
        delegate!.myActivityIndicator.startAnimating()
        
        let user = NCMBUser.currentUser()
        
        // クラスのNCMBObjectを作成
        let obj = NCMBObject(className: "Inquiry")
        obj.setObject(inquiryText, forKey: "inquiry")
        obj.setObject(formatDate(), forKey: "date")
        obj.setObject(user, forKey: "user")
        
        // データストアへの保存を実施
        obj.saveInBackgroundWithBlock({(error) in
            if (error != nil) {
                // 保存に失敗した場合の処理
                print(error)
                //OKボタン
                self.delegate!.showCustomDialog(
                    "Error", message: error.localizedDescription,positiveButtonText: "OK", closure: ViewController.OnDialogEventClosure(
                        onClickPositive: {() -> Void in
                        },
                        onClickNegative: {() -> Void in
                    })
                )
            }else{
                // 保存に成功した場合の処理
                print("お問い合わせ成功！")
                //すべて初期に戻す
                self.delegate?.textView.text = ""
                
                //OKボタン
                self.delegate!.showCustomDialog(
                    "お礼", message: "ご意見ありがとうございます。",positiveButtonText: "OK", closure: ViewController.OnDialogEventClosure(
                        onClickPositive: {() -> Void in
                        },
                        onClickNegative: {() -> Void in
                    })
                )

            }
        })
        
        //くるくるストップ
        self.delegate!.myActivityIndicator.stopAnimating()
    }
    
    
    
    func formatDate() -> String{
        
        //日付
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") // ロケールの設定
        dateFormatter.dateFormat = "yyyy/MM/dd" // 日付フォーマットの設定
        return dateFormatter.stringFromDate(NSDate()) // -> 2014/06/25 02:13:18
        
    }
    
    
    
}


