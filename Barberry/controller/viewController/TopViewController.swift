//
//  TopViewController.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/11.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import FontAwesomeKit
import NCMB

class TopViewController: ViewController,UITabBarDelegate {

    var feedDataSource: FeedViewDataSource?
    var searchDataSource: SearchViewDataSource?
    var newsDataSource: NewsViewDataSource?
    var myPageDataSource: ProfileViewDataSource?
    var firstFlg = true
    var userModel = UserModel()
    var feedApiModel: GetFeedApiModel?
    var newsApiModel: NewsApiModel?
    var pesonalApiModel: PersonalLogApiModel?
    var personalApiFlg = true
    
    var selectedUserId: String?
    
    
    @IBOutlet weak var goToInputButton: UIButton!
    @IBOutlet weak var profileTabButton: UITabBarItem!
    @IBOutlet weak var feedTabButton: UITabBarItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var inputModal: UITabBarItem!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //「プッシュ通知よろしいですか？のやつ。」permissionの設定.
//        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge, categories: nil)
//        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        //バッジの数の設定.
        //UIApplication.sharedApplication().applicationIconBadgeNumber = 2
        
        //dataSourceのインスタンス化
        initDataSources()
        
        //cellの登録
        registerCells()
        
        //tableViewのcellを可変にする
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //tabBarの設定
        tabBarSetting()
        
        //最後
        firstFlg = false
    }
    
    //dataSourceのインスタンス化
    func initDataSources(){
        
        //フィード
        feedDataSource = FeedViewDataSource()
        feedDataSource?.delegate = self
        
        //検索
        searchDataSource = SearchViewDataSource()
        searchDataSource?.delegate = self
        
        //お知らせ
        newsDataSource = NewsViewDataSource()
        newsDataSource?.delegate = self
        
        //自分
        myPageDataSource = ProfileViewDataSource()
        myPageDataSource?.delegate = self
        myPageDataSource?.userModel = getUserModelByNCMBUser()
        
    }
    
    //タブバーをセットする
    func tabBarSetting(){
        
        tabBar.delegate = self
        
        let itemSize = CGSize(width: 30, height: 30)
        tabBar.tintColor = UIColor.hex("D11E23", alpha: 1.0)
        tabBar.selectedItem = tabBar.items![0]
        tabBar.items![0].image = FAKFontAwesome.homeIconWithSize(25).imageWithSize(itemSize)
        tabBar.items![0].title = "ジム"
//        tabBar.items![1].image = FAKFontAwesome.searchIconWithSize(25).imageWithSize(itemSize)
//        tabBar.items![1].title = "検索"
        
        //let inputImage = FAKFontAwesome.pencilIconWithSize(25).imageWithSize(itemSize)
//        let inputImage = UIImage(named: "barberry_icon320")
//        goToInputButton.setImage(inputImage, forState: .Normal)
        goToInputButton.contentMode = UIViewContentMode.ScaleToFill
        
//        tabBar.items![3].image = FAKFontAwesome.bellIconWithSize(22).imageWithSize(itemSize)
//        tabBar.items![3].title = "お知らせ"
        tabBar.items![2].image = FAKFontAwesome.userIconWithSize(25).imageWithSize(itemSize)
        tabBar.items![2].title = "自分"
        
        //デフォルトは一番左
        self.tabBar(self.tabBar, didSelectItem: self.feedTabButton)
        
    }
    
    //タブバーのクリックイベント
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        switch item.tag {
        case 1:
            self.navigationItem.title = "ジム"
            feedDataSource?.feedModels = []
            tableView.dataSource = feedDataSource
            tableView.delegate = feedDataSource
            feedApiModel = GetFeedApiModel()
            feedApiModel?.delegate = self
            feedApiModel?.doDataRequest(0)
        case 2:
            self.navigationItem.title = "検索"
            tableView.dataSource = searchDataSource
            tableView.delegate = searchDataSource
            tableView.reloadData()
        case 3:
            //入力画面へ画面遷移
            //self.performSegueWithIdentifier("goToInput", sender: self)
            break
        case 4:
            self.navigationItem.title = "お知らせ"
            tableView.dataSource = newsDataSource
            tableView.delegate = newsDataSource
            newsApiModel = NewsApiModel()
            newsApiModel?.delegate = self
            newsApiModel?.doDataRequest()
            tableView.reloadData()
        case 5:
            
            if NCMBAnonymousUtils.isLinkedWithUser(NCMBUser.currentUser()) {
                // 匿名ユーザーでログインしている時の処理
                self.performSegueWithIdentifier("goToLogin", sender: self)
            }else{
                // 匿名ユーザーでログインしていない時の処理
                self.navigationItem.title = "自分"
                tableView.dataSource = myPageDataSource
                tableView.delegate = myPageDataSource
                if personalApiFlg {
                    pesonalApiModel = PersonalLogApiModel()
                    pesonalApiModel?.delegate = self
                    pesonalApiModel?.doDataRequest()
                    self.personalApiFlg = false
                }else{
                    tableView.reloadData()
                }
            }
            
        default:
            break
        }
        
        if tableView.numberOfSections > 0 && tableView.numberOfRowsInSection(0) > 0 {
            scrollTop()
        }
        
    }
    
    func scrollTop(){
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
    }
    
    //goToInputButton
    @IBAction func goToInputButton(sender: AnyObject) {
        //入力画面へ画面遷移
        self.performSegueWithIdentifier("goToInput", sender: self)
    }
        
    
    //xibのセルをテーブルビューに登録していく
    func registerCells(){
        
        registerNib("ComingSoonCell")
        registerNib("CustomSectionHeader")
        registerNib("DateHeaderCell")
        registerNib("NewsCell")
        registerNib("ProfileCell")
        registerNib("WorkoutLogCell")
        registerNib("WorkoutLogCell2")
        registerNib("OnlyNameCell")
        registerNib("FeedCell")
        
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
            editProfileViewController.delegate = self
            editProfileViewController.userModel = self.userModel
            
        }else if segue.identifier == "goToInput" { //筋トレ入力画面へ遷移
            
            let inputViewController = segue.destinationViewController as! InputViewController
            inputViewController.delegate = self
            
        }else if segue.identifier == "goToOtherProfile" { //他人のプロフィール画面へ遷移
            
            let otherProfileViewController = segue.destinationViewController as! ProfileViewController
                otherProfileViewController.userId = selectedUserId!
        }else if segue.identifier == "goToLogin" { //登録してない場合のログイン画面へ
            
            let loginAskViewController = segue.destinationViewController as! LoginAskViewController
            loginAskViewController.delegate = self
        }
        
    }
    
    func getUserModelByNCMBUser() -> UserModel{
        
        let user = NCMBUser.currentUser()
        
        if NCMBAnonymousUtils.isLinkedWithUser(NCMBUser.currentUser()) {
            // 匿名ユーザーでログインしている時の処理
            
        }else{
            //ユーザーモデルにセット
            userModel.id = user.objectId
            userModel.name = user.objectForKey("displayName") as! String
            userModel.imgUrl = user.objectForKey("imgUrl") as! String
            userModel.height = user.objectForKey("height") as! Int
            userModel.weight = user.objectForKey("weight") as! Int
            userModel.word = user.objectForKey("word") as! String
            userModel.isOpen = user.objectForKey("isOpen") as! Bool
        }
        
        return userModel
    }
    

}