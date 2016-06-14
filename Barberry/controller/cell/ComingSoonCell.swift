//
//  ProfileCell.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/11.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class ComingSoonCell: UITableViewCell{
    
    var delegate: TopViewController?
    
    @IBAction func sendButton(sender: AnyObject) {
        
        //画面遷移(ご意見ご要望フォーム)
        delegate!.performSegueWithIdentifier("goToInquiry", sender: self)
    }
    
    
}
