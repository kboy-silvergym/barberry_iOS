//
//  ImageUploadApiModel.swift
//  Barberry
//
//  Created by 藤川慶 on 2016/06/12.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit
import NCMB
import SDWebImage

class ImageUploadApiModel {
    
    var delegate: EditProfileViewController?
    var loginConfirmView: LoginConfirmViewController?
    let uploadImgUrl = "https://mb.api.cloud.nifty.com/2013-09-01/applications/RmZs0seDzbNeUgNd/publicFiles/"
    
    
    func onUpload(userModel: UserModel, image: UIImage) {
        
        delegate?.myActivityIndicator.startAnimating()
        
        // 画像ファイルをJPEG形式でデータ化
        guard let data = UIImageJPEGRepresentation(image, 0.6) else { return }
        
        let userId = userModel.id
        
        //画像ナンバー
        var presentNumner: Int?
        var nextNumber = "1"
        
        let imgUrl = userModel.imgUrl
        if imgUrl != "" {
            let numberString: String = String(imgUrl[imgUrl.endIndex.predecessor().predecessor().predecessor().predecessor().predecessor()])
            presentNumner = Int(numberString)
            
            if presentNumner != nil{
                nextNumber = (presentNumner! + 1).description
            }
        }
        
        // ※本来ならここでサイズのチェックが必要
        
        // NCMBFileを生成
       
        let fileName = userId + nextNumber + ".jpg"
        let file = NCMBFile.fileWithName(fileName, data: data)
        
        // アップロード
        file.saveInBackgroundWithBlock() { error in
            if let error = error {
                print("File save error : ", error)
            } else {
                print("File save OK: \(fileName)")
                
                //編集リクエスト
                
                if self.delegate != nil {
                    self.delegate?.userModel?.imgUrl = self.uploadImgUrl + userId + nextNumber + ".jpg"
                    self.delegate!.editRequest()
                    self.delegate?.myActivityIndicator.stopAnimating()
                }else if self.loginConfirmView != nil{
                    self.loginConfirmView?.userModel?.imgUrl = self.uploadImgUrl + userId + nextNumber + ".jpg"
                    self.loginConfirmView!.createNCMBUser()
                    self.loginConfirmView?.myActivityIndicator.stopAnimating()
                    
                }
            }
        }
    }
    
    func editRequest(){
        
    }
    
}
