//
//  feedCell.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/28.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import SDWebImage

class FeedCell: UITableViewCell {
    
    var delegate: TopViewController?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var feedModel = FeedModel() {
        
        didSet{
            
            
            if feedModel.imgUrl != ""{
                let imgUrl = NSURL(string: feedModel.imgUrl)
                userImage.sd_setImageWithURL(imgUrl)
            }else{
                userImage.image = UIImage(named: "afa_profile_blank_icon")
            }
            
            name.text = feedModel.name
            
            date.text = feedModel.date
            
        }
    }
    
    var menuCount = 0 {
        
        didSet{
            
            if menuCount == 1 {
                word.text = feedModel.workoutName +  "を行いました。"
            }else{
                word.text = feedModel.workoutName + "他" + (menuCount - 1).description + "種目を行いました。"
            }
        }
    }
    
    
    
}
