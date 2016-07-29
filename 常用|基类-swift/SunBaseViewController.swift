//
//  SBaseViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/7/14.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit

//屏幕尺寸
let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height

//系统判断
let IOS8 = Float(UIDevice.currentDevice().systemVersion) >= 8.0 ? true:false
let IOS9 = Float(UIDevice.currentDevice().systemVersion) >= 9.0 ? true:false
let IOS10 = Float(UIDevice.currentDevice().systemVersion) >= 10.0 ? true:false


//MARK:字体
/** 系统字体 */
func ksystemFont(size:CGFloat)->UIFont{
    return UIFont.systemFontOfSize(size)
}
/** 加粗字体 */
func kSystemBlodFont(size:CGFloat)->UIFont{
    return UIFont.boldSystemFontOfSize(size)
}

//MARK:颜色
/** r、g、b颜色 */
func kRGB(r:CGFloat,g:CGFloat,b:CGFloat)->UIColor{
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}
/** 十六进制转化字体 */
func kHexColor(hex:NSInteger)->UIColor{

    return UIColor(red: CGFloat((hex & 0xFF0000) >> 16)/255.0, green: CGFloat((hex & 0xFF00) >> 8)/255.0, blue: CGFloat(hex & 0xFF)/255.0, alpha: 1.0)
}


class SunBaseViewController: UIViewController {

    // pop
    func popToViewController(controller:AnyClass)->Void{
        for temp in self.navigationController!.viewControllers{
            if temp.isKindOfClass(controller) {
                self.navigationController?.popToViewController(temp, animated: true)
            }
        }
    }
    
    //navBar appearance
    func applyNavBarAppearance(color:UIColor,font:UIFont) -> Void {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:color,NSFontAttributeName:font]
    }
    //设置导航栏的背景颜色为透明的
    func navBarApperanceAlpha() -> Void {
        self.navigationController?.navigationBar.subviews.first?.alpha = 0
    }
    //隐藏导航栏下的边线
    func navBarHiddemLine(){
    
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = false
    
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()


    }


}
