//
//  ProfileViewController.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/29.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import SDWebImage
import NCMB

class ProfileViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userId: String?
    var userModel: UserModel?
    var dataSource: ProfileViewDataSource?
    var apiModel: OtherProfileApiModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = ProfileViewDataSource()
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        //tableViewのcellを可変にする
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        registerNib("ProfileCell")
        registerNib("DateHeaderCell")
        registerNib("WorkoutLogCell")
        registerNib("WorkoutLogCell2")
        registerNib("OnlyNameCell")
        
        apiModel = OtherProfileApiModel()
        apiModel?.delegate = self
        apiModel?.doUserDataRequest(userId!)
        
    }
    
    //cellの登録
    func registerNib(identifier: String){
        
        let cell = UINib(nibName: identifier, bundle:nil)
        self.tableView.registerNib(cell, forCellReuseIdentifier: identifier)
        
    }
    
    // 次の画面にtransactionを渡す
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToEditProfile" { //プロフィール編集画面に遷移
            
            let editProfileViewController = segue.destinationViewController as! EditProfileViewController
            editProfileViewController.profileViewController = self
            editProfileViewController.userModel = self.userModel
            
        }
    }

}

