//
//  NewsCell.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/14.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var newsText: UILabel!
    
    var newsModel = NewsModel() {
        
        
        didSet{
            
            name.text = newsModel.name
            newsText.text = newsModel.news
            date.text = newsModel.date
            
        }
        
    }
    
}
