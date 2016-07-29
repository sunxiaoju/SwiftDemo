//
//  SunViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/7/25.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit

let imageName = ""

class SunTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    //MARK:自定义TabBar的背景图片
    func setUpTabBarBackgroundImage(){
        
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage(named: imageName)
    
    }
    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 60
        tabFrame.origin.y = self.view.frame.size.height - 60
        self.tabBar.frame = tabFrame
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
