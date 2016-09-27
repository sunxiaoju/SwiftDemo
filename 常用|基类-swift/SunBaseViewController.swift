//
//  SBaseViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/7/14.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


//屏幕尺寸
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

//系统判断
let IOS8 = Float(UIDevice.current.systemVersion) >= 8.0 ? true:false
let IOS9 = Float(UIDevice.current.systemVersion) >= 9.0 ? true:false
let IOS10 = Float(UIDevice.current.systemVersion) >= 10.0 ? true:false


//MARK:字体
/** 系统字体 */
func ksystemFont(_ size:CGFloat)->UIFont{
    return UIFont.systemFont(ofSize: size)
}
/** 加粗字体 */
func kSystemBlodFont(_ size:CGFloat)->UIFont{
    return UIFont.boldSystemFont(ofSize: size)
}

//MARK:颜色
/** r、g、b颜色 */
func kRGB(_ r:CGFloat,g:CGFloat,b:CGFloat)->UIColor{
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}
/** 十六进制转化字体 */
func kHexColor(_ hex:NSInteger)->UIColor{

    return UIColor(red: CGFloat((hex & 0xFF0000) >> 16)/255.0, green: CGFloat((hex & 0xFF00) >> 8)/255.0, blue: CGFloat(hex & 0xFF)/255.0, alpha: 1.0)
}


class SunBaseViewController: UIViewController {

    // pop
    func popToViewController(_ controller:AnyClass)->Void{
        for temp in self.navigationController!.viewControllers{
            if temp.isKind(of: controller) {
                self.navigationController?.popToViewController(temp, animated: true)
            }
        }
    }
    
    //navBar appearance
    func applyNavBarAppearance(_ color:UIColor,font:UIFont) -> Void {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:color,NSFontAttributeName:font]
    }
    //设置导航栏的背景颜色为透明的
    func navBarApperanceAlpha() -> Void {
        self.navigationController?.navigationBar.subviews.first?.alpha = 0
    }
    //隐藏导航栏下的边线
    func navBarHiddemLine(){
    
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
    
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    
   

}
