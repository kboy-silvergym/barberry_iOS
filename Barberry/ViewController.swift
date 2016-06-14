//
//  ViewController.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/01.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var myActivityIndicator: UIActivityIndicatorView!
    var myKeyboard: UIView?
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // インジケータを作成する.
        myActivityIndicator = UIActivityIndicatorView()
        myActivityIndicator.frame = CGRectMake(0, 0, 100, 100)
        myActivityIndicator.center = self.view.center
        
        // アニメーションが停止している時もインジケータを表示させる.
       // myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        // アニメーションを開始する.
        //myActivityIndicator.startAnimating()
        
        // インジケータをViewに追加する.
        self.view.addSubview(myActivityIndicator)
        
        
        
        //ボタンを追加するためのViewを生成します。
        myKeyboard = UIView(frame: CGRectMake(0, screenHeight, screenWidth, 36))
        myKeyboard!.backgroundColor = UIColor.lightGrayColor()
        myKeyboard?.alpha = 0.8
        //完了ボタンの生成
        let myButton = UIButton(frame: CGRectMake(screenWidth - 70, 5, 70, 26))
        //myButton.backgroundColor = UIColor.darkGrayColor()
        myButton.setTitle("完了", forState: .Normal)
        //myButton.layer.cornerRadius = 2.0
        myButton.addTarget(self, action: "donePicker:", forControlEvents: .TouchUpInside)
        //Viewに完了ボタンを追加する。
        myKeyboard!.addSubview(myButton)
        
    }

    func donePicker(sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * カスタムダイアログ生成（OKだけ）
     *
     * @param context            呼び出し元ActivityのContext
     * @param title              ダイアログに表示するタイトル
     * @param message            ダイアログに表示するメッセージ
     * @param positiveButtonText ポジティブボタン文言
     * @param Closure           ダイアログのボタンを押した時に処理するClosure
     */
    func showCustomDialog(title: String, message: String, positiveButtonText: String, closure: OnDialogEventClosure?) {
        showCustomDialog(title, message: message, positiveButtonText: positiveButtonText, negativeButtonText: "", closure: closure)
    }
    
    
    
    
    /**
     * カスタムダイアログ生成（はい、いいえ）
     *
     * @param context            呼び出し元ActivityのContext
     * @param title              ダイアログに表示するタイトル
     * @param message            ダイアログに表示するメッセージ
     * @param positiveButtonText ポジティブボタン文言
     * @param negativeButtonText ネガティブボタン文言
     * @param Closure           ダイアログのボタンを押した時に処理するClosure
     */
    func showCustomDialog(title: String, message: String, positiveButtonText: String, negativeButtonText: String, closure: OnDialogEventClosure?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        //いいえを左にするためにnagativeを先にaddAction
        if (!negativeButtonText.isEmpty) {
            alertController.addAction(
                UIAlertAction(title: negativeButtonText,
                    style: UIAlertActionStyle.Default,
                    handler: { (action:UIAlertAction!) -> Void in
                        if closure != nil {
                            closure!.onClickNegative()
                        }
                    }
                )
            )
        }
        
        alertController.addAction(
            UIAlertAction(title: positiveButtonText,
                style: UIAlertActionStyle.Default,
                handler: { (action:UIAlertAction!) -> Void in
                    if closure != nil {
                        closure!.onClickPositive()
                    }
                }
            )
        )
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
     * DialogEventClosure
     */
    class OnDialogEventClosure {
        var onClickPositive: () -> Void?
        var onClickNegative: () -> Void?
        /**
         * コンストラクタ
         */
        init(onClickPositive: (() -> Void)?, onClickNegative: (() -> Void)?) {
            
            self.onClickPositive = onClickPositive!
            
            self.onClickNegative = onClickNegative!
            
        }
    }
    
    
    //messageをエラーとして表示
    func errorMessage(message: String){
        
        self.showCustomDialog(
            "確認", message: message,positiveButtonText: "OK",
            closure:OnDialogEventClosure(
                onClickPositive: {() -> Void in
                    return
                },
                onClickNegative: {() -> Void in
            })
        )
        
    }



}

