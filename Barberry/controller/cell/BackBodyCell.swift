//
//  BackBodyImage.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/02.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class BackBodyCell: UICollectionViewCell {
    
    
    @IBOutlet weak var muscleNameLabel: UILabel!
    @IBOutlet weak var trapMuscle: UIButton!
    @IBOutlet weak var latMuscle: UIButton!
    @IBOutlet weak var spinaeMuscle: UIButton!
    
    var apiModel: WorkoutApiModel?
    
    //広背筋のクリックイベント
    @IBAction func latClick(sender: AnyObject) {
        resetMuscle()
        latMuscle.selected = true
        muscleNameLabel.text = "広背筋"
        muscleNameLabel.font = UIFont.boldSystemFontOfSize(30)
        apiModel?.doDataRequest(WorkoutApiModel.PartsEnum.LAT)
    }
    
    //脊柱起立筋のクリックイベント
    @IBAction func spinaeClick(sender: AnyObject) {
        resetMuscle()
        spinaeMuscle.selected = true
        muscleNameLabel.text = "脊柱起立筋"
        muscleNameLabel.font = UIFont.boldSystemFontOfSize(24)
        apiModel?.doDataRequest(WorkoutApiModel.PartsEnum.SPINAE)
    }
    
    //僧帽筋のクリックイベント
    @IBAction func trapClick(sender: AnyObject) {
        resetMuscle()
        trapMuscle.selected = true
        muscleNameLabel.text = "僧帽筋"
        muscleNameLabel.font = UIFont.boldSystemFontOfSize(30)
        apiModel?.doDataRequest(WorkoutApiModel.PartsEnum.TRAPEZIUS)
    }
    
    //筋肉をリセット
    func resetMuscle(){
        latMuscle.selected = false
        spinaeMuscle.selected = false
        trapMuscle.selected = false
        
        muscleNameLabel.text = ""
    }
}

