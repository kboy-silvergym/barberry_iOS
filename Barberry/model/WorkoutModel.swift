//
//  WorkoutModel.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/03.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class WorkoutModel {
    
    var id = 0//  判別ID
    
    var name = "" //種目名
    
    var genre = 0 //バーベル、ダンベル、マシン自重
    
    var kg = 0 //kg
    
    var reps = 0 //回
    
    var interval = 0 //秒
    
    var set = 1
    
    var date = "" //日付
    
    func getGenreName() -> String{
        
        switch self.genre {
        case 0:
            return "バーベル"
        case 1:
           return  "ダンベル"
        case 2:
            return "マシン"
        case 3:
            return "自重"
        default:
            return ""
        }
        
        
    }
}
