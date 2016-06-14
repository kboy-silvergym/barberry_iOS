//
//  InputViewController.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/01.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import NCMB

class InputViewController: ViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nameBackGround: UIView!
    @IBOutlet weak var repsBackGround: UIView!
    @IBOutlet weak var weightBackGround: UIView!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var repsButton: UIButton!
    @IBOutlet weak var workoutNameButton: UIButton!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var inputWeightButton: UIButton!
    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var defaultConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var legsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var frontButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: TopViewController?
    var dataSource: BodyCollectionViewDataSource?
    var tableDataSource: SelectionTableViewDataSource?
    var pickerDataSource: PickerViewDataSource?
    var barConstraint: NSLayoutConstraint!
    var firstFlg = false
    var apiModel: WorkoutApiModel?
    var recordApiModel: RecordApiModel?
    var feedApiModel: AddToFeedApiModel?
    var keyboardView: CustomKeyboardView?
    var repsView: RepsSelectionView?
    var setView: MultiSetView?
    var pickerView: UIPickerView?
    var transaction = [WorkoutModel]()
    var selectedIndexPath: NSIndexPath?
    var editButtonFlg = false
    let keyboardHeight: CGFloat = UIScreen.mainScreen().bounds.size.height - 64 - 56 - 140 - 92
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //タップしたらキーボード消す
        //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        //        view.addGestureRecognizer(tap)
        
        //種目名のtextfield
        workoutNameTextField.delegate = self
        
        let frontCellNib = UINib(nibName: "FrontBodyCell", bundle: nil)
        self.collectionView!.registerNib(frontCellNib, forCellWithReuseIdentifier: "FrontBodyCell")
        let backCellNib = UINib(nibName: "BackBodyCell", bundle: nil)
        self.collectionView!.registerNib(backCellNib, forCellWithReuseIdentifier: "BackBodyCell")
        let legsCellNib = UINib(nibName: "LegsBodyCell", bundle: nil)
        self.collectionView!.registerNib(legsCellNib, forCellWithReuseIdentifier: "LegsBodyCell")
        
        let muscleDefault = UINib(nibName: "MuscleDefaultCell", bundle: nil)
        self.tableView!.registerNib(muscleDefault, forCellReuseIdentifier: "MuscleDefaultCell")
        let manualCell = UINib(nibName: "ManualCell", bundle: nil)
        self.tableView!.registerNib(manualCell, forCellReuseIdentifier: "ManualCell")
        
        //一番上のボタン
        frontButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        backButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        legsButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        //api
        apiModel = WorkoutApiModel()
        apiModel!.delegate = self
        
        //コレクションビューとテーブルビュー
        setTableAndCollection()
        
        //デフォルトはfront
        buttonSwitch(frontButton)
        
        //保存ボタン
        saveButton.enabled = false
        saveButton.backgroundColor = UIColor.lightGrayColor()
        
        //複数セットボタン
        setButton.enabled = false
        
        //workoutName背景色
        //nameBackGround.backgroundColor = UIColor.hex("fac9d3", alpha: 1.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        editButtonFlg = false
    }
    
    //×ボタン
    @IBAction func dismissButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        //自分を更新する状態にしとく
        delegate!.personalApiFlg = true
        //飛ばすのはフィード
        delegate!.tabBar(delegate!.tabBar, didSelectItem: delegate!.feedTabButton)
        delegate!.tabBar.selectedItem = delegate!.tabBar.items![0]
        delegate!.tableView.reloadData()
        
    }
    
    //frontBodyボタン
    @IBAction func frontButton(sender: UIButton) {
        let index = NSIndexPath(forItem: 0, inSection: 0)
        collectionView.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        
        dataSource!.frontCell!.resetMuscle()
        
        buttonSwitch(frontButton)
    }
    
    //backBodyボタン
    @IBAction func backButton(sender: AnyObject) {
        let index = NSIndexPath(forItem: 1, inSection: 0)
        collectionView.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        
        if dataSource!.backCell != nil {
            dataSource!.backCell!.resetMuscle()
        }
        
        buttonSwitch(backButton)
    }
    
    //legsBodyボタン
    @IBAction func legsButton(sender: AnyObject) {
        let index = NSIndexPath(forItem: 2, inSection: 0)
        collectionView.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        
        if dataSource!.legsCell != nil {
            dataSource!.legsCell!.resetMuscle()
        }
        
        buttonSwitch(legsButton)
        
    }
    
    //ボタンのselectedのスイッチ
    func buttonSwitch(button: UIButton){
        
        //一回全てOFF
        frontButton.selected = false
        backButton.selected = false
        legsButton.selected = false
        
        //選択されたのだけON
        button.selected = true
        
        //barのアニメーション
        setConstraintForBarView(button)
    }
    
    //ボタンしたの棒のアニメーション
    func setConstraintForBarView(button: UIButton){
        
        //前の制約を外す
        if !firstFlg {
            menuView.removeConstraint(defaultConstraint)
            firstFlg = true
        }else{
            menuView.removeConstraint(barConstraint)
        }
        
        //barを動かすための制約
        barConstraint = NSLayoutConstraint(
            item: button,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: self.barView,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0
        )
        
        //新たに制約をつける
        menuView.addConstraint(barConstraint)
        
        //アニメーション
        UIView.animateWithDuration( 0.2, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    //workoutNameTextFieldのマニュアル入力で「完了」を押した時
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        checkIsEnoughInfo()
        return true
    }
    
    //トレーニング名の上のボタン
    @IBAction func workoutNameButton(sender: AnyObject) {
        
        resetKeyboard()
        
        //まわりをfalseに
        inputWeightButton.selected = false
        repsButton.selected = false
        setButton.selected = false
        
        //nameBackGround.backgroundColor = UIColor.hex("fac9d3", alpha: 1.0)
        
        //クリックすると、順に筋肉ボタンを押していく。
        //今度
        
        //checkIsEnoughInfo()
    }

    
    //重量(kg)の入力ボタン
    @IBAction func InputWeightButton(sender: AnyObject) {
        
        resetKeyboard()
        
        //まわりをfalseに
        workoutNameButton.selected = false
        repsButton.selected = false
        setButton.selected = false
        
        //もし選択されていなければ
        if !inputWeightButton.selected {
            
            weightBackGround.backgroundColor = UIColor.hex("fac9d3", alpha: 1.0)
            
            //カスタムキーボードの追加
            if keyboardView == nil {
                keyboardView = UINib(nibName: "CustomKeyboard", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? CustomKeyboardView
                keyboardView!.delegate = self
                keyboardView!.frame = CGRectMake(0, screenHeight, screenWidth, keyboardHeight)
                self.view.addSubview(keyboardView!)
            }
            
            UIView.animateWithDuration( 0.1, animations: {
                //self.view.layoutIfNeeded()
                self.keyboardView!.frame.origin.y = self.screenHeight - self.keyboardHeight
            })
            
            //選択状態にする
            inputWeightButton.selected = true
            
        }else{
            //閉じる
            resetKeyboard()
            inputWeightButton.selected = false
        }

    }
    
    //repsの入力ボタン
    @IBAction func repsButton(sender: AnyObject) {
        
        resetKeyboard()
        
        //まわりをfalseに
        workoutNameButton.selected = false
        inputWeightButton.selected = false
        setButton.selected = false
        
        //もし選択されていなければ
        if !repsButton.selected {
            
            repsBackGround.backgroundColor = UIColor.hex("fac9d3", alpha: 1.0)
            
            let repsViewHeight: CGFloat = self.keyboardHeight
            
            //カスタムキーボードの追加
            if repsView == nil {
                repsView = UINib(nibName: "RepsSelectionView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? RepsSelectionView
                repsView!.delegate = self
                repsView!.frame = CGRectMake(0, screenHeight, screenWidth, repsViewHeight)
                self.view.addSubview(repsView!)
            }
            
            UIView.animateWithDuration( 0.1, animations: {
                self.repsView!.frame.origin.y = self.screenHeight - repsViewHeight
            })
            
            //選択状態にする
            repsButton.selected = true
        }else{
            //閉じる
            resetKeyboard()
            repsButton.selected = false
        }
    }
    
    //ドラムピッカーを出す
    func showPickerView(){
        
        let pickerViewHeight: CGFloat = self.keyboardHeight - 36
        let myKeybordHeight: CGFloat = 36
        
        if pickerView == nil {
            pickerView = UIPickerView()
            pickerView!.frame = CGRectMake(0, screenHeight, screenWidth, pickerViewHeight)
            pickerView?.backgroundColor = UIColor.groupTableViewBackgroundColor()
            
            pickerDataSource = PickerViewDataSource()
            pickerDataSource?.delegate = self
            pickerDataSource?.makingNumbers(50)
            pickerView!.delegate = pickerDataSource
            pickerView!.dataSource = pickerDataSource
            
            //ボタンを追加するためのViewを生成します。
            myKeyboard = UIView(frame: CGRectMake(0, screenHeight, screenWidth, myKeybordHeight))
            myKeyboard!.backgroundColor = UIColor.darkGrayColor()
            myKeyboard?.alpha = 1
            //完了ボタンの生成
            let myButton = UIButton(frame: CGRectMake(screenWidth - 70, 5, 70, 26))
            myButton.setTitle("完了", forState: .Normal)
            myButton.addTarget(self, action: "donePicker:", forControlEvents: .TouchUpInside)
            myKeyboard!.addSubview(myButton)
            
            
            self.view.addSubview(pickerView!)
            self.view.addSubview(myKeyboard!)
        }
        
        UIView.animateWithDuration( 0.1, animations: {
            self.pickerView!.frame.origin.y = self.screenHeight - pickerViewHeight
            self.myKeyboard!.frame.origin.y = self.screenHeight - pickerViewHeight - myKeybordHeight
        })
    }
    
    //pickerを閉じる
    override func donePicker(sender: UIButton) {
        
        UIView.animateWithDuration( 0.1, animations: {
            self.pickerView!.frame.origin.y = self.screenHeight
            self.myKeyboard!.frame.origin.y = self.screenHeight
             self.repsView!.frame.origin.y = self.screenHeight
        })
        
        repsButton.selected = false
        repsBackGround.backgroundColor = UIColor.groupTableViewBackgroundColor()
        checkIsEnoughInfo()
    }
    
    //複数セット入力ボタン
    @IBAction func setButton(sender: AnyObject) {
        
        resetKeyboard()
        
        //周りをfalseに
        workoutNameButton.selected = false
        inputWeightButton.selected = false
        repsButton.selected = false
        
        //もし選択されていなければ
        if !setButton.selected {
            
            setButton.backgroundColor = UIColor.hex("fac9d3", alpha: 1.0)
            
            let setViewHeight: CGFloat = self.keyboardHeight
            
            createTransaction()
            
            //カスタムキーボードの追加
            if setView == nil {
                setView = UINib(nibName: "MultiSetView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? MultiSetView
                setView!.delegate = self
            }
            setView!.workoutModels = transaction
            setView!.frame = CGRectMake(0, screenHeight, screenWidth, setViewHeight)
            self.view.addSubview(setView!)
            
            UIView.animateWithDuration( 0.1, animations: {
                self.setView!.frame.origin.y = self.screenHeight - setViewHeight
            })
            
            //選択状態にする
            setButton.selected = true
        }else{
            //閉じる
            resetKeyboard()
            setButton.selected = false
            setButton.setTitle("×1", forState: .Normal)
        }
        
    }
    
    //キーボードを閉じる
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    //ボタンの状態やViewなどをリセットする
    func resetKeyboard(){
        
        //背景色
        nameBackGround.backgroundColor = UIColor.groupTableViewBackgroundColor()
        weightBackGround.backgroundColor = UIColor.groupTableViewBackgroundColor()
        repsBackGround.backgroundColor = UIColor.groupTableViewBackgroundColor()
        setButton.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        //種目名のマニュアル入力でキーボードが開いていたら閉じる
        if workoutNameTextField.isFirstResponder(){
            workoutNameTextField.resignFirstResponder()
        }
        
        UIView.animateWithDuration( 0.1, animations: {
            //self.view.layoutIfNeeded()
            if self.keyboardView != nil {
                self.keyboardView!.frame.origin.y = self.screenHeight
            }
            
            if self.repsView != nil {
                self.repsView!.frame.origin.y = self.screenHeight
            }
            
            if self.pickerView != nil {
                self.pickerView!.frame.origin.y = self.screenHeight
                self.myKeyboard!.frame.origin.y = self.screenHeight
            }
            
            if self.setView != nil {
                self.setView!.frame.origin.y = self.screenHeight
            }
            
        })
        
    }
    
    //チェックして種目名、重量、回数が埋まっていたら保存ボタンをenabledにしてセット数選択に飛ばす
    func checkIsEnoughInfo(){
        
        if workoutNameTextField.text == "" {
            enableSaveButton(false)
            //キーボード全部閉じる
            resetKeyboard()
        }else if weightTextField.text == "" {
            enableSaveButton(false)
            //重量選択に飛ばす
            InputWeightButton(inputWeightButton)
        }else if repsTextField.text == "" {
            enableSaveButton(false)
            //reps選択に飛ばす
            repsButton(repsButton)
        }else{
            enableSaveButton(true)
            //セット数選択に飛ばす
            self.setButton(setButton)
        }
        
    }
    
    func enableSaveButton(enable: Bool) {
        setButton.enabled = enable
        saveButton.enabled = enable
        
        if enable {
            saveButton.backgroundColor = UIColor.hex("C00000", alpha: 1)
        }else{
            saveButton.backgroundColor = UIColor.lightGrayColor()
            
        }
    }
    
    //保存ボタンのクリックイベント
    @IBAction func saveButton(sender: AnyObject) {
        
        if NCMBAnonymousUtils.isLinkedWithUser(NCMBUser.currentUser()) {
            // 匿名ユーザーでログインしている時の処理
            self.dismissViewControllerAnimated(true, completion: nil)
            delegate!.performSegueWithIdentifier("goToLogin", sender: self)
        }else{
            
            self.showCustomDialog(
                "確認", message: "保存しますか？",positiveButtonText: "はい", negativeButtonText: "いいえ",
                closure:OnDialogEventClosure(
                    onClickPositive: {() -> Void in
                        
                        //トランザクションに保存
                        self.transaction = (self.setView?.workoutModels)!
                        
                        
                        //APIリクエスト
                        if self.recordApiModel == nil {
                            self.recordApiModel = RecordApiModel()
                            self.recordApiModel?.delegate = self
                            
                            self.feedApiModel = AddToFeedApiModel()
                            self.feedApiModel?.delegate = self
                        }
                        self.recordApiModel?.doDataRequest(self.transaction)
                        self.feedApiModel?.doDataRequest(self.transaction)
                        
                        //OKボタン
                        self.showCustomDialog(
                            "確認", message: "保存しました。",positiveButtonText: "OK",
                            closure:OnDialogEventClosure(
                                onClickPositive: {() -> Void in
                                    //すべて初期に戻す
                                    self.clearAll()
                                },
                                onClickNegative: {() -> Void in
                            })
                        )
                        
                        
                    },
                    onClickNegative: {() -> Void in
                        //「いいえ」を押した時のアクション
                })
            )
        }
    }
    
    //トランザクションを作る
    func createTransaction(){
        
        transaction.removeAll()
        transaction.append(WorkoutModel())
        
        //名前
        transaction[0].name = workoutNameTextField.text!
        
        //kg
        if weightTextField.text! == "自重" {
            transaction[0].kg = 0
        }else{
            transaction[0].kg = Int(weightTextField.text!)!
        }
        
        //reps
        transaction[0].reps = Int(repsTextField.text!)!
        
    }
    
    //初期状態にする
    func clearAll(){
        workoutNameTextField.text = ""
        weightTextField.text = ""
        repsTextField.text = ""
        setButton.setTitle("×1", forState: .Normal)
        
        checkIsEnoughInfo()
        resetKeyboard()
        tableView.reloadData()
    }
    
    
    
    //tableViewとCollectionViewのセット
    func setTableAndCollection(){
        
        //コレクションビュー
        dataSource = BodyCollectionViewDataSource()
        dataSource!.delegate = self
        dataSource?.apiModel = apiModel
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.reloadData()
        
        //テーブルビュー
        tableDataSource = SelectionTableViewDataSource()
        tableDataSource?.delegate = self
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
        tableView.estimatedRowHeight = 44//だいたいの高さの見積もり
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
        
    }
    
    // 次の画面にtransactionを渡す
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToEdit" {
            
            let editViewController = segue.destinationViewController as! EditViewController
            editViewController.delegate = self
            editViewController.transaction = self.setView?.workoutModels
            
            if !editButtonFlg {
                editViewController.selectedIndexPath = selectedIndexPath
            }
        }
        
    }
    
    
    
}



