//
//  MessageCell.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/11.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    var delegate: TopViewController?
    
    @IBAction func workoutDayButton(sender: AnyObject) {
        
        //画面遷移
        delegate!.performSegueWithIdentifier("goToInputView", sender: delegate!)
        
    }
    
    
    
}
