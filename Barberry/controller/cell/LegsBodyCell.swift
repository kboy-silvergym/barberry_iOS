//
//  LegsBodyCell.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/02.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class LegsBodyCell: UICollectionViewCell {
    
    @IBOutlet weak var muscleNameLabel: UILabel!
    @IBOutlet weak var hipMuscle: UIButton!
    @IBOutlet weak var quadMuscle: UIButton!
    @IBOutlet weak var hamMuscle: UIButton!
    @IBOutlet weak var calfMuscle: UIButton!
    
    var apiModel: WorkoutApiModel?

    //お尻のクリックイベント
    @IBAction func hipClick(sender: AnyObject) {
        resetMuscle()
        hipMuscle.selected = true
        muscleNameLabel.text = "大臀筋"
        muscleNameLabel.font = UIFont.boldSystemFontOfSize(30)
        apiModel?.doDataRequest(WorkoutApiModel.PartsEnum.HIP)
    }
    
    //ハムストリングスのクリックイベント
    @IBAction func hamClick(sender: AnyObject) {
        resetMuscle()
        hamMuscle.selected = true
        muscleNameLabel.text = "ハムストリングス"
        muscleNameLabel.font = UIFont.boldSystemFontOfSize(22)
        apiModel?.doDataRequest(WorkoutApiModel.PartsEnum.HAM)
    }
    
    //大腿四頭筋のクリックイベント
    @IBAction func quadClick(sender: AnyObject) {
        resetMuscle()
        quadMuscle.selected = true
        muscleNameLabel.text = "大腿四頭筋"
        muscleNameLabel.font = UIFont.boldSystemFontOfSize(30)
        apiModel?.doDataRequest(WorkoutApiModel.PartsEnum.QUADRICEPS)
    }
    
    //ふくらはぎのクリックイベント
    @IBAction func calfClick(sender: AnyObject) {
        resetMuscle()
        calfMuscle.selected = true
        muscleNameLabel.text = "カーフ"
        muscleNameLabel.font = UIFont.boldSystemFontOfSize(30)
        apiModel?.doDataRequest(WorkoutApiModel.PartsEnum.CALF)
    }
    
    //筋肉をリセット
    func resetMuscle(){
        hipMuscle.selected = false
        hamMuscle.selected = false
        quadMuscle.selected = false
        calfMuscle.selected = false
        
        muscleNameLabel.text = ""
    }
}