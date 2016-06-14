//
//  EditProfileViewController.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/24.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import SDWebImage
import NCMB

class EditProfileViewController: ViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: TopViewController?
    var profileViewController: ProfileViewController?
    var userModel: UserModel?
    var pickerView: UIPickerView?
    var pickerDataSource: EditPickerDataSource?
    var imageApiModel: ImageUploadApiModel?
    var imageChangeFlg = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var heightWeightTextField: UITextField!
    
    //view表示前に呼ばれる
    override func viewWillAppear(animated: Bool) {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //タップしたらキーボード消す
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "donePicker:")
        view.addGestureRecognizer(tap)
        
        
        if userModel!.imgUrl != ""{
            let imgUrl = NSURL(string: userModel!.imgUrl)
            userImage.sd_setImageWithURL(imgUrl)
        }else{
            userImage.image = UIImage(named: "afa_profile_blank_icon")
        }
        
        //画像タップしたとき
        userImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pressCameraRoll:"))
        
        nameTextField.text = userModel?.name
        
        let height = userModel?.height.description
        let weight = userModel?.weight.description
        heightWeightTextField.text = height! + "cm/" + weight! + "kg"
        
        bmiLabel.text = ((Double(weight!)! * 10000 / (Double(height!)! * Double(height!)!)).description as NSString).substringToIndex(4)
        
        wordTextField.text = userModel?.word
        
        onSwitch.on = (userModel?.isOpen)!
        
        //pickerViewを作る
        makePickerView()
        
    }
    
    @IBAction func openSwitch(sender: AnyObject) {
        
        if onSwitch.on {
            //ONのとき
            userModel!.isOpen = true
        }else{
            //OFFのとき
            userModel!.isOpen = false
        }
        
    }
    
    @IBAction func changeButton(sender: AnyObject) {
        
        if imageChangeFlg{
            //画像の送信
            imageApiModel = ImageUploadApiModel()
            imageApiModel!.delegate = self
            imageApiModel?.onUpload(userModel!,image: userImage.image!)
        }else{
            //編集のAPIリクエスト
            editRequest()
        }
        
    }
    
    //キーボードによりtextViewが隠されてしまうのを防ぐ処理
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        var txtLimit:CGFloat = 0
        //        if textViewFlg {
        txtLimit = wordTextField.frame.origin.y + wordTextField.frame.height + 8.0
        //        }else{
        //            txtLimit = 0
        //        }
        
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height - 80
        
        if txtLimit >= kbdLimit {
            scrollView.contentOffset.y = txtLimit - kbdLimit
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        scrollView.contentOffset.y = 0
    }
    
    
    //身長体重のピッカービュー
    func makePickerView(){
        
        let pickerViewHeight: CGFloat = 200
        
        if pickerView == nil {
            pickerView = UIPickerView()
            pickerView!.frame = CGRectMake(0, screenHeight, screenWidth, pickerViewHeight)
            pickerView?.backgroundColor = UIColor.groupTableViewBackgroundColor()
            
            pickerDataSource = EditPickerDataSource()
            pickerDataSource?.delegate = self
            pickerDataSource?.makingNumbers(200)
            pickerDataSource?.makingNumbers2(150)
            pickerView!.delegate = pickerDataSource
            pickerView!.dataSource = pickerDataSource
            
            //default値
            pickerView?.selectRow((userModel?.height)!, inComponent: 0, animated: false)
            pickerView?.selectRow((userModel?.weight)!, inComponent: 1, animated: false)
            
            //身長体重のtextViewの設定
            heightWeightTextField.delegate = self
            heightWeightTextField.inputView = pickerView
            heightWeightTextField.inputAccessoryView = myKeyboard
            nameTextField.inputAccessoryView = myKeyboard
            wordTextField.inputAccessoryView = myKeyboard
            
        }
        
    }
    
    //pickerやtextViewを閉じる
    override func donePicker(sender: UIButton) {
        
        nameTextField.resignFirstResponder()
        heightWeightTextField.resignFirstResponder()
        wordTextField.resignFirstResponder()
        
    }
    
    //テキストフィールドにフォーカスが当たったときに呼ばれる。
    func textFieldShouldBeginEditing(textField:UITextField) -> Bool {
        
        if textField == heightWeightTextField {
            let height = pickerDataSource?.numbers[(pickerView?.selectedRowInComponent(0))!]
            let weight = pickerDataSource?.numbers2[(pickerView?.selectedRowInComponent(1))!]
            heightWeightTextField.text = height! + "cm/" + weight! + "kg"
        }else if textField == wordTextField {
            
        }
        return true
    }
    
    //NCMBUserを編集するAPIリクエスト
    func editRequest(){
        
        myActivityIndicator.startAnimating()
        
        let user = NCMBUser.currentUser()
        userModel!.name = self.nameTextField.text!
        userModel!.word = self.wordTextField.text!
        user.setObject(self.userModel?.name, forKey: "displayName")
        user.setObject(self.userModel?.imgUrl, forKey: "imgUrl")
        user.setObject(userModel?.height, forKey: "height")
        user.setObject(userModel?.weight, forKey: "weight")
        user.setObject(userModel?.word, forKey: "word")
        user.setObject(userModel?.isOpen, forKey: "isOpen")
        
        //会員情報の編集
        user.saveInBackgroundWithBlock{(error: NSError!) in
            if error != nil {
                // 登録失敗時の処理
                print(error)
                self.myActivityIndicator.stopAnimating()
                self.errorMessage(error.localizedDescription)
            }else{
                self.myActivityIndicator.stopAnimating()
                // 登録成功時の処理
                self.showCustomDialog(
                    "確認", message: "変更しました！",positiveButtonText: "OK",
                    closure:OnDialogEventClosure(
                        onClickPositive: {() -> Void in
                            // 前の画面に戻る
                            
                            if self.profileViewController == nil{
                                self.delegate!.pesonalApiModel?.doDataRequest()
                                self.delegate?.tableView.reloadData()
                            }else{
                                self.profileViewController!.apiModel?.doDataRequest(user)
                                self.profileViewController?.tableView.reloadData()
                            }
                            self.navigationController?.popViewControllerAnimated(true)
                        },
                        onClickNegative: {() -> Void in
                    })
                )
                
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
    
    
}
