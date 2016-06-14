//
//  RepsSelectionView.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/08.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import Foundation
import UIKit

class RepsSelectionView: UIView {
    
    var delegate: InputViewController?
    
    @IBAction func button10(sender: AnyObject) {
        delegate?.repsTextField.text = "10"
        done()
    }
    
    @IBAction func button8(sender: AnyObject) {
        delegate?.repsTextField.text = "8"
        done()
    }
    
    @IBAction func button6(sender: AnyObject) {
        delegate?.repsTextField.text = "6"
        done()
    }
    
    @IBAction func othersButton(sender: AnyObject) {
        delegate?.showPickerView()
    }
    
    func done(){
        
        UIView.animateWithDuration( 0.1, animations: {
            self.delegate!.repsView!.frame.origin.y = self.delegate!.screenHeight
        })
        
        self.delegate!.repsButton.selected = false
        self.delegate!.repsBackGround.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        delegate!.checkIsEnoughInfo()
        //delegate!.reset()
    }
    
}
