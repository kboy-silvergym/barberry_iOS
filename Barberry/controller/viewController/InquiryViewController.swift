//
//  InquiryViewController.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/29.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import SDWebImage
import NCMB

class InquiryViewController: ViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    
    var inquiryApiModel: InquiryApiModel?
    
    //view表示前に呼ばれる
    override func viewWillAppear(animated: Bool) {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //タップしたらキーボード消す
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "donePicker:")
        view.addGestureRecognizer(tap)
       
        textView.inputAccessoryView = myKeyboard
        
    }
    
    //pickerやtextViewを閉じる
    override func donePicker(sender: UIButton) {
        
        textView.resignFirstResponder()
        
    }
    
    //キーボードによりtextViewが隠されてしまうのを防ぐ処理
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        var txtLimit:CGFloat = 0
        txtLimit = textView.frame.origin.y + textView.frame.height + 8.0
        
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height - 80
        
        if txtLimit >= kbdLimit {
            scrollView.contentOffset.y = txtLimit - kbdLimit
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        scrollView.contentOffset.y = 0
    }

    
    //送信ボタン
    @IBAction func sendButton(sender: AnyObject) {
        
        inquiryApiModel = InquiryApiModel()
        inquiryApiModel?.delegate = self
        inquiryApiModel?.doDataRequest(textView.text)
        
    }
}
