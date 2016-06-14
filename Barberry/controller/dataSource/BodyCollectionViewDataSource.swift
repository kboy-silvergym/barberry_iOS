//
//  BodyCollectionViewDataSource.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/02.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
//import WebImage

class BodyCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var delegate: InputViewController?
    var apiModel: WorkoutApiModel?
    var frontCell: FrontBodyCell?
    var backCell: BackBodyCell?
    var legsCell: LegsBodyCell?
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    
    //var communityModels: [CommunityModel]?
    
    override init () {
        super.init()
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        // Util からでディスプレイサイズ取得
        // Width はそれを使い，高さは適切な値で返してやる
        let returnSize = CGSize(width: screenWidth, height: 140)
        
        return returnSize
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            frontCell = collectionView.dequeueReusableCellWithReuseIdentifier("FrontBodyCell", forIndexPath: indexPath) as! FrontBodyCell
            frontCell!.apiModel = apiModel
            return frontCell!
        case 1:
            backCell = collectionView.dequeueReusableCellWithReuseIdentifier("BackBodyCell", forIndexPath: indexPath) as! BackBodyCell
            backCell!.apiModel = apiModel
            return backCell!
        case 2:
            legsCell = collectionView.dequeueReusableCellWithReuseIdentifier("LegsBodyCell", forIndexPath: indexPath) as! LegsBodyCell
            legsCell!.apiModel = apiModel
            return legsCell!
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    //
    //        switch indexPath {
    //        case 0:
    //            delegate?.buttonSwitch((delegate?.frontButton)!)
    //        case 1:
    //            delegate?.buttonSwitch((delegate?.backButton)!)
    //        case 2:
    //            delegate?.buttonSwitch((delegate?.legsButton)!)
    //        default:
    //            break
    //        }
    //
    //    }
    
    /**
     *  UICollectionViewDelegateFlowLayoutのデリゲートメソッド。セルのサイズを返す
     *
     *  @param collectionView 対象のUICollectionView
     *  @param collectionViewLayout 対象のUICollectionViewLayout
     *  @param indexPath 対象のNSIndexPath
     *  @return セルのサイズ
     */
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //
    //        // １セルあたりのサイズを計算
    //        let screenSize:CGRect = UIScreen.mainScreen().bounds
    //        let space:CGFloat = 7
    //        let listCellSize:CGSize = CGSize(width: (screenSize.size.width-space*3)/2, height: (screenSize.size.width-space*3)/2 + 40)
    //
    //        return listCellSize
    //    }
    
    
}
