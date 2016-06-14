//
//  LoginViewController.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/11.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import NCMB
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: ViewController, FBSDKLoginButtonDelegate {
    
    var userProfile : NSDictionary?
    var userModel: UserModel?
    var isAlreadyLogin = false
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("User Already Logged In")
            
            //すでにログインしたことある人
            getUserModel()
        } else {
            //何もしない
        }
    }
    
    //ユーザー情報を取得してuserModelに保存する
    func getUserModel(){
        
        userModel = UserModel()
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me",
                                                                 parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil){
                // エラー処理
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

                
            }
            else{
                // プロフィール情報をディクショナリに入れる
                self.userProfile = result as? NSDictionary
                print(self.userProfile)
                
                //name
                self.userModel?.name = (self.userProfile!.objectForKey("name") as? String)!
                
                //pass
                let token = FBSDKAccessToken.currentAccessToken()
                self.userModel!.password = token.userID
                
                //自動ログイン
                self.backGroundLogin()
            }
        })
    }
    
    
    //NCMBでログインを試みる
    func backGroundLogin(){
        
        myActivityIndicator.startAnimating()
        
        sleep(1)
        
        NCMBUser.logInWithUsernameInBackground(userModel!.name, password: userModel!.password, block: {(user: NCMBUser!, error: NSError!) in
            
            if error != nil {
                // ログイン失敗時の処理
                print(error)
                //まだ登録していなかったので、ログイン画面へ
                self.myActivityIndicator.stopAnimating()
                self.performSegueWithIdentifier("goToConfirm", sender: self)
            }else{
                // ログイン成功時の処理
                //すでに会員になっていたので、ログインさせる。
                //アプリ内に保存
                UserDefaultManager.sharedInstance.saveLoginUserData(self.userModel!)
                //TOPへ
                self.myActivityIndicator.stopAnimating()
                self.performSegueWithIdentifier("goToTop", sender: self)
            }
        })
        
    }
    
    
    //facebookログインボタン
    func loginButton(loginButton: FBSDKLoginButton!,didCompleteWithResult
        result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil){
            //エラー処理
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

            
        } else if result.isCancelled {
            //キャンセルされた時
        } else {
            //必要な情報が取れていることを確認(今回はemail必須)
            if result.grantedPermissions.contains("email"){
                // 次の画面に遷移（後で）
                self.performSegueWithIdentifier("goToConfirm", sender: self)
            }
        }
    }
    
    //ログアウトボタン
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    //idとパスワードでログインボタン
    @IBAction func idPasswordLoginButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("goToIdPasswordLogin", sender: self)
    }
    
    
    
    //スキップボタン
    @IBAction func skipButton(sender: AnyObject) {
        print("Skip")
        NCMBUser.logOut()
        // 匿名ユーザーでログイン
        NCMBAnonymousUtils.logInWithBlock{(user: NCMBUser!, error: NSError!) in
            if error != nil {
                // ログイン失敗時の処理
                print(error)
                self.myActivityIndicator.stopAnimating()
                self.showCustomDialog(
                    "確認", message: error.localizedDescription,positiveButtonText: "OK",
                    closure:OnDialogEventClosure(
                        onClickPositive: {() -> Void in
                        },
                        onClickNegative: {() -> Void in
                    })
                )

                //self.performSegueWithIdentifier("goToTop", sender: self)
            }else{
                // ログイン成功時の処理
                 self.performSegueWithIdentifier("goToTop", sender: self)
            }
        }
       
        
    }
    
    //すでに会員の方ボタン
    @IBAction func AlreadyMemberButton(sender: AnyObject) {
        
         self.performSegueWithIdentifier("goToLoginAgain", sender: self)
    }
}


