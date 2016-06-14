//
//  LoginConfirmViewController.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/22.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import NCMB
import FBSDKLoginKit
import FBSDKCoreKit
import SDWebImage

class LoginConfirmViewController: ViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    var userProfile : NSDictionary?
    var userModel: UserModel?
    var pickerView: UIPickerView?
    var pickerDataSource: HeightWeightPickerDataSource?
    var imageApiModel: ImageUploadApiModel?
    var imageChangeFlg = false
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ユーザーモデル作成
        if userModel == nil {
            userModel = UserModel()
            userModel!.name = "name"
        }
        
        userModel?.height = 170
        userModel?.weight = 70
        //userModel!.email = "fujikei22funk@gmail.com"
        
        //ユーザー情報の表示
        returnUserData()
        
        //pickerViewを作る
        makePickerView()
        
        //デフォルトはtrue
        onSwitch.on = true
        
        //画像タップしたとき
        userImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pressCameraRoll:"))
        
    }
    
    //ユーザー情報を取得してuserModelに保存する
    func returnUserData(){
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me",
                                                                 parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil){
                // エラー処理
                print("Facebook情報取得エラー")
            }
            else{
                // プロフィール情報をディクショナリに入れる
                self.userProfile = result as? NSDictionary
                print(self.userProfile)
                
                // プロフィール画像の表示
                let profileImageURL : String = self.userProfile!.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String
                let imgUrl = NSURL(string: profileImageURL)
                self.userImage.sd_setImageWithURL(imgUrl)
                
                //名前を表示
                self.userNameTextField.text = self.userProfile!.objectForKey("name") as? String
                
                //userModelに保存
                self.userModel!.imgUrl = profileImageURL
                self.userModel!.name = (self.userProfile!.objectForKey("name") as? String)!
                //self.userModel!.email = (self.userProfile!.objectForKey("email") as? String)!
                let token = FBSDKAccessToken.currentAccessToken()
                self.userModel!.password = token.userID
                
            }
        })
        
    }
    
    //身長体重のピッカービュー
    func makePickerView(){
        
        let pickerViewHeight: CGFloat = 200
        
        if pickerView == nil {
            pickerView = UIPickerView()
            pickerView!.frame = CGRectMake(0, screenHeight, screenWidth, pickerViewHeight)
            pickerView?.backgroundColor = UIColor.groupTableViewBackgroundColor()
            
            pickerDataSource = HeightWeightPickerDataSource()
            pickerDataSource?.delegate = self
            pickerDataSource?.makingNumbers(200)
            pickerDataSource?.makingNumbers2(150)
            pickerView!.delegate = pickerDataSource
            pickerView!.dataSource = pickerDataSource
            
            //default値
            pickerView?.selectRow(170, inComponent: 0, animated: false)
            pickerView?.selectRow(70, inComponent: 1, animated: false)
            
            //身長体重のtextViewの設定
            heightTextField.delegate = self
            heightTextField.inputView = pickerView
            heightTextField.inputAccessoryView = myKeyboard
            userNameTextField.inputAccessoryView = myKeyboard
            
        }
        
    }
    
    //pickerやtextViewを閉じる
    override func donePicker(sender: UIButton) {
        
        heightTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
        
    }
    
    //テキストフィールドにフォーカスが当たったときに呼ばれる。
    func textFieldShouldBeginEditing(textField:UITextField) -> Bool {
        
        if textField == heightTextField {
            let height = pickerDataSource?.numbers[(pickerView?.selectedRowInComponent(0))!]
            let weight = pickerDataSource?.numbers2[(pickerView?.selectedRowInComponent(1))!]
            heightTextField.text = height! + "cm/" + weight! + "kg"
        }
        return true
    }
    
    //NCMBUserをつくる
    func createNCMBUser(){
        
        myActivityIndicator.startAnimating()
        
        let user = NCMBUser()
        
        user.userName = self.userModel!.name
        user.password = self.userModel!.password
        //user.mailAddress = self.userModel!.email
        
        //テキストフィールドに入力した名前をdisplayNameとして登録する
        user.setObject(self.userNameTextField.text!, forKey: "displayName")
        user.setObject(self.userModel?.imgUrl, forKey: "imgUrl")
        user.setObject(userModel?.height, forKey: "height")
        user.setObject(userModel?.weight, forKey: "weight")
        user.setObject("よろしく", forKey: "word")
        user.setObject(userModel?.isOpen, forKey: "isOpen")
        //アクセス権限
        user.ACL.setPublicReadAccess(true)
        user.ACL.setPublicWriteAccess(true)
        
        user.signUpInBackgroundWithBlock{(error: NSError!) in
            if error != nil {
                // 新規登録失敗時の処理
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
                // 新規登録成功時の処理
                UserDefaultManager.sharedInstance.saveLoginUserData(self.userModel!)
                self.myActivityIndicator.stopAnimating()
                // 次の画面に遷移
                self.performSegueWithIdentifier("goToTop", sender: self)
            }
        }
        
    }
    
    /**
     カメラロールボタンを押した時
     */
    func pressCameraRoll(sender: UIButton) {
        pickImageFromLibrary()  //ライブラリから写真を選択する
    }
    
    
    /**
     ライブラリから写真を選択する
     */
    func pickImageFromLibrary() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
            let controller = UIImagePickerController()
            controller.delegate = self
            
            //.Cameraを指定した場合はカメラを呼び出しができる
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    /**
     写真を選択した時に呼ばれる
     :param: picker:
     :param: didFinishPickingMediaWithInfo:
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo: [String: AnyObject]) {
        
        if didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] != nil {
            userImage.image = didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] as? UIImage
            
            imageChangeFlg = true
        }
        
        //写真選択後にカメラロール表示ViewControllerを引っ込める動作
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    
    //公開非公開
    @IBAction func openSwitch(sender: AnyObject) {
        if onSwitch.on {
            //ONのとき
            userModel!.isOpen = true
        }else{
            //OFFのとき
            userModel!.isOpen = false
        }
    }
    
    @IBAction func registerButton(sender: AnyObject) {
        
        self.myActivityIndicator.startAnimating()
        
        if imageChangeFlg{
            //画像の送信
            imageApiModel = ImageUploadApiModel()
            imageApiModel!.loginConfirmView = self
            imageApiModel?.onUpload(userModel!,image: userImage.image!)
        }else{
            createNCMBUser()
        }

        
        
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        let loginManager : FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}
