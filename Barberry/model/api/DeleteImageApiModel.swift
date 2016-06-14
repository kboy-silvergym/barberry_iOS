//
//  DeleteImageApiModel.swift
//  Barberry
//
//  Created by 藤川慶 on 2016/06/13.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import NCMB
import SDWebImage

class DeleteImageApiModel {
    
    var delegate: ImageUploadApiModel?
    
    func deleteImage(imgUrl: String){
        
        // ファイルストアを検索するクエリを作成
        let query = NCMBFile.query()
        // 検索するファイル名を設定
        query.whereKey("fileName", equalTo: imgUrl)
        // ファイルストアの検索を実行
        query.findObjectsInBackgroundWithBlock { (files: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                // 検索失敗時の処理
            } else {
                // 検索成功時の処理
                for file in files {
                    file.getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                        if error != nil {
                            // ファイル取得失敗時の処理
                        } else {
                            // ファイル取得成功時の処理
                        }
                    })
                }
            }
        }
        
        
    }
    
    
    
}
