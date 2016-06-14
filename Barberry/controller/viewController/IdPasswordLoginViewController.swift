//
//  MailLoginViewController.swift
//  Barberry
//
//  Created by 藤川慶 on 2016/06/09.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import NCMB

class IdPasswordLoginViewController: ViewController {
    
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
    
    //次へ（すでに会員だったら、エラー。）
    @IBAction func nextButton(sender: AnyObject) {
        
        userModel.name = idTextField.text!
        userModel.password = passTextField.text!
        validate(userModel)
    }
    
    //validate
    func validate(userModel: UserModel){
        
        //IDのトリム
        let trimedName = (userModel.name).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        //パスワードのトリム
        let trimedPass = (userModel.password).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        //文字数validate
        if trimedName.characters.count == 0{
            //ユーザーIDがO文字だったら
            errorMessage("IDを入力してください")
            return
        }else if trimedName.characters.count > 10{
            //ユーザーIDが10文字以上だったら
            errorMessage("IDは10文字以内でお願いします")
            return
        }else if trimedPass.characters.count < 6 {
            //パスワードが6文字より少なかったら
            errorMessage("パスワードは6文字以上10文字以内でお願いします")
            return
        }else if trimedPass.characters.count > 10 {
            //パスワードが10文字よりも多かったら
            errorMessage("パスワードは6文字以上10文字以内でお願いします")
            return
        }
        
        myActivityIndicator.startAnimating()
        
        let query = NCMBUser.query()
        
        /** 条件を入れる場合はここに書きます **/
        query.whereKey("userName", equalTo: userModel.name)
        
        // データストアの検索を実施
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if (error != nil){
                // 検索失敗時の処理
                print(error)
                self.myActivityIndicator.stopAnimating()
                self.errorMessage(error.localizedDescription)
            }else{
                print("success")
                self.myActivityIndicator.stopAnimating()
                
                if objects.count > 0 {
                    self.errorMessage("すでに使われているユーザーIDです")
                    return
                }else{
                    //validate成功
                    self.performSegueWithIdentifier("goToConfirm", sender: self)
                }
            }
            
        })
        
    }
        
    // 次の画面にtransactionを渡す
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToConfirm" { //プロフィール編集画面に遷移
            
            let confirmViewController = segue.destinationViewController as! LoginConfirmViewController
            confirmViewController.userModel = self.userModel
            
        }
    }


    
}
