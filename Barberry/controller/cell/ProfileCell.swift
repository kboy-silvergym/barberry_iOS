//
//  ProfileCell.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/14.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import SDWebImage
import NCMB

class ProfileCell: UITableViewCell {
    
    var delegate: ViewController?
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    
    var userModel = UserModel(){
        
        didSet{
            
            if userModel.imgUrl != ""{
                let imgUrl = NSURL(string: userModel.imgUrl)
                userImage.sd_setImageWithURL(imgUrl)
                
//                let data = NSData(contentsOfURL:imgUrl!)
//                if data != nil {
//                    userImage?.image = UIImage(data:data!)
//                }
                
            }else{
                userImage.image = UIImage(named: "afa_profile_blank_icon")
            }
            
            nameLabel.text = userModel.name
            
            let height = userModel.height
            let weight = userModel.weight
            
            heightLabel.text = height.description + "cm"
            weightLabel.text = weight.description + "kg"
            
            wordLabel.text = userModel.word
            
            
            bmiLabel.text = ((Double(weight) * 10000 / (Double(height) * Double(height))).description as NSString).substringToIndex(4)
            
            
            var myName = ""
            if NCMBAnonymousUtils.isLinkedWithUser(NCMBUser.currentUser()) {
                // 匿名ユーザーでログインしている時の処理
            }else{
                let user = NCMBUser.currentUser()
                myName = user.objectForKey("displayName") as! String
            }
            
            if myName == userModel.name {
                editButton.hidden = false
            }else{
                editButton.hidden = true
            }
        }
        
    }
    
    @IBAction func editButton(sender: AnyObject) {
        
        //プロフィール編集画面へ遷移
        delegate!.performSegueWithIdentifier("goToEditProfile", sender: self)
    }
}