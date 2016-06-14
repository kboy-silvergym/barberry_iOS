//
//  frontBodyCell.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/02.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class FrontBodyCell: UICollectionViewCell {
    
    @IBOutlet weak var rightArmMuscle: UIButton!
    @IBOutlet weak var leftArmMuscle: UIButton!
    @IBOutlet weak var rightShoulderMuscle: UIButton!
    @IBOutlet weak var leftShoulederMuscle: UIButton!
    @IBOutlet weak var absMuscle: UIButton!
    @IBOutlet weak var muscleNameLabel: UILabel!
    @IBOutlet weak var chestMuscle: UIButton!
    @IBOutlet weak var bodyImage: UIImageView!
    
    var apiModel: WorkoutApiModel?
    
    //大胸筋のクリックイベント
    @IBAction func chestClick(sender: AnyObject) {
        resetMuscle()
        chestMuscle.selected = true
        muscleNameLabel.text = "胸筋"
        muscleNameLabel.font = UIFont.boldSystemFontOfSize(30)
        apiModel?.doDataRequest(WorkoutApiModel.PartsEnum.CHEST)
    }
    
    //腹筋のクリックイベント
    @IBAction func absClick(sender: AnyObject) {
        resetMuscle()
        absMuscle.selected = true
        muscleNameLabel.text = "腹筋"
        muscleNameLabel.font = UIFont.boldSystemFontOfSize(30)
        apiModel?.doDataRequest(WorkoutApiModel.PartsEnum.ABS)
    }
    //左肩のクリックイベント
    @IBAction func leftShoulederClick(sender: AnyObject) {
        resetMuscle()
        leftShoulederMuscle.selected = true
        rightShoulderMuscle.selected = true
        muscleNameLabel.text = "三角筋"
        muscleNameLabel.font = UIFont.boldSystemFontOfSize(30)
        apiModel?.doDataRequest(WorkoutApiModel.PartsEnum.SHOULDER)
    }
    //右肩のクリックイベント
    @IBAction func rightShoulederClick(sender: AnyObject) {
        resetMuscle()
        leftShoulederMuscle.selected = true
        rightShoulderMuscle.selected = true
        muscleNameLabel.text = "三角筋"
        muscleNameLabel.font = UIFont.boldSystemFontOfSize(30)
        apiModel?.doDataRequest(WorkoutApiModel.PartsEnum.SHOULDER)
    }
    
    //左腕のクリックイベント
    @IBAction func leftArmClick(sender: AnyObject) {
        resetMuscle()
        leftArmMuscle.selected = true
        muscleNameLabel.text = "上腕三頭筋"
        muscleNameLabel.font = UIFont.boldSystemFontOfSize(24)
        apiModel?.doDataRequest(WorkoutApiModel.PartsEnum.TRICEPS)
    }
    
    //右腕のクリックイベント
    @IBAction func rightArmClick(sender: AnyObject) {
        resetMuscle()
        rightArmMuscle.selected = true
        muscleNameLabel.text = "上腕二頭筋"
        muscleNameLabel.font = UIFont.boldSystemFontOfSize(24)
        apiModel?.doDataRequest(WorkoutApiModel.PartsEnum.BICEPS)
    }
    
    
    //筋肉をリセット
    func resetMuscle(){
        chestMuscle.selected = false
        absMuscle.selected = false
        leftShoulederMuscle.selected = false
        rightShoulderMuscle.selected = false
        leftArmMuscle.selected = false
        rightArmMuscle.selected = false
        
        muscleNameLabel.text = ""
    }
}
