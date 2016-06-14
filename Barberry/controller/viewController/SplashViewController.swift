//
//  SplashViewController.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/23.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import NCMB
import FBSDKLoginKit
import FBSDKCoreKit

class SplashViewController: ViewController {
    
    var splashView: UIView!
    var logoImageView: UIImageView!
    var userProfile : NSDictionary?
    var userModel: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //スプラッシュの画像
        splashView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        self.splashView.backgroundColor = UIColor.whiteColor()
        self.logoImageView = UIImageView(frame: CGRectMake(0, 0, 160, 147))
        self.logoImageView.center = self.splashView.center
        self.logoImageView.image = UIImage(named: "barberry_icon320")
        self.splashView.addSubview(self.logoImageView)
        self.navigationController?.view.addSubview(self.splashView)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //少し縮小するアニメーション
        UIView.animateWithDuration(0.3,
                                   delay: 1.0,
                                   options: UIViewAnimationOptions.CurveEaseOut,
                                   animations: { () in
                                    self.logoImageView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            }, completion: { (Bool) in
                
        })
        
        //拡大させて、消えるアニメーション
        UIView.animateWithDuration(0.2,
                                   delay: 1.3,
                                   options: UIViewAnimationOptions.CurveEaseOut,
                                   animations: { () in
                                    self.logoImageView.transform = CGAffineTransformMakeScale(3.0, 3.0)
                                    self.logoImageView.alpha = 0
            }, completion: { (Bool) in
                self.splashView.removeFromSuperview()
        })
        
        if (UserDefaultManager.sharedInstance.isRegister()) {
            print("User Already Logged In")
            //既にログインしていた場合,強制ログインさせ、Topに飛ぶ
            backGroundLogin()
        } else {
            //まだログインしていない場合は、ログイン画面へ
            self.performSegueWithIdentifier("goToLogin", sender: self)
        }

    }
    
    //自動でNCMBでログインさせる
    func backGroundLogin(){
        
        let userModel = UserDefaultManager.sharedInstance.getLoginUserData()
            
            NCMBUser.logInWithUsernameInBackground(userModel.name, password: userModel.password, block:{(user: NCMBUser!, error: NSError!) in
                if error != nil {
                    // ログイン失敗時の処理
                    print(error.localizedDescription)
                    //ログイン画面へ
                    self.performSegueWithIdentifier("goToLogin", sender: self)
                }else{
                    // ログイン成功時の処理
                    //TOPへ
                    self.performSegueWithIdentifier("goToTop", sender: self)
                }
            })
    }
    
}
