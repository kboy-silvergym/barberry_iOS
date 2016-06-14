//
//  TabBarDelegate.swift
//  barbellyApp
//
//  Created by 藤川慶 on 2016/05/12.
//  Copyright © 2016年 藤川慶. All rights reserved.
//

import UIKit

class TabBarDelegate: NSObject, UITabBarControllerDelegate{
    
    var delegete: TopViewController?
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        //画面遷移
        delegete!.performSegueWithIdentifier("goToInputView", sender: delegete!)
    }

    
}
