//
//  AlreadyMemberLoginViewController.swift
//  Barberry
//
//  Created by 藤川慶 on 2016/06/14.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import NCMB

class AlreadyMemberLoginViewController: ViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    let userModel = UserModel()
    
    override func viewWillAppear(animated: Bool) {
        //self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idTextField.inputAccessoryView =  myKeyboard
        passTextField.inputAccessoryView =  myKeyboard
        
    }
    
    //完了ボタン押した時
    override func donePicker(sender: UIButton) {
        idTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
    }
    
    //ログインボタン
    @IBAction func nextButton(sender: AnyObject) {
        userModel.name = idTextField.text!
        userModel.password = passTextField.text!
        backGroundLogin()
    }
    
    //NCMBでログインを試みる
    func backGroundLogin(){
        
        myActivityIndicator.startAnimating()
        
        sleep(1)
        
        NCMBUser.logInWithUsernameInBackground(userModel.name, password: userModel.password, block: {(user: NCMBUser!, error: NSError!) in
            
            if error != nil {
                // ログイン失敗時の処理
                print(error)
                self.myActivityIndicator.stopAnimating()
                self.showCustomDialog(
                    "確認", message: error.localizedDescription,positiveButtonText: "OK",
                    closure:OnDialogEventClosure(
                        onClickPositive: {() -> Void in
                            //self.performSegueWithIdentifier("goToTop", sender: self)
                        },
                        onClickNegative: {() -> Void in
                    })
                )

            }else{
                // ログイン成功時の処理
                //すでに会員になっていたので、ログインさせる。
                //アプリ内に保存
                UserDefaultManager.sharedInstance.saveLoginUserData(self.userModel)
                //TOPへ
                self.myActivityIndicator.stopAnimating()
                self.performSegueWithIdentifier("goToTop", sender: self)
            }
        })
        
    }
    
    
}

