//
//  extension.swift
//  常用|基类-swift
//
//  Created by chedao on 16/9/5.
//  Copyright © 2016年 chedao. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIAlertController{

    
    func addActions(_ cancel:String?,others:[String?]?,actionPressed:@escaping (UIAlertAction,Int) -> Void) -> Void {
        
        if cancel != nil {
            let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: { (action) in
                actionPressed(action,0)
            })
            self.addAction(cancelAction)
        }
     
        if others == nil{
            return
        }
        for i in 0..<others!.count {
            let otherAction = UIAlertAction(title: others![i], style: UIAlertActionStyle.default, handler: { (action) in
                if cancel == nil{
                    actionPressed(action,i)
                }else{
                    actionPressed(action,i+1)
                    }
            })
            self.addAction(otherAction)
        }
        
    }

}


extension UIButton{

  fileprivate struct associateKeys{
        static var keys = "btn_enabled"
        static var timer = "time_interval"
        static var ignoreEvent = "ignore_event"
    }
    
    /**
     *btn_enabled true：可以点击 false：不可以点击 
     *结局UIbarButtonItem 上添加UIbutton 的enabled不作用
     */
    var btn_enabled:Bool{
        get {
            if let btn_enabel = objc_getAssociatedObject(self, &associateKeys.keys) as? Bool {
                return btn_enabel
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &associateKeys.keys, newValue as Bool, .OBJC_ASSOCIATION_ASSIGN)
            self.isEnabled = btn_enabled
           self.isUserInteractionEnabled = btn_enabled

        }
    }

    //MARK: runtime 防止UIbutton 连续点击问题
    /** 连续点击事件的最少间隔 */
    var eventTimeInterval:TimeInterval{
        get{
            if let eventTime = objc_getAssociatedObject(self, &associateKeys.timer) as? TimeInterval {
                return eventTime
            }
            return 0
        }
        set{
            objc_setAssociatedObject(self, &associateKeys.timer, newValue as TimeInterval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /** 是否忽略点击 */
    var isIgnoreEvent:Bool{
        set{
            objc_setAssociatedObject(self, &associateKeys.ignoreEvent, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            if let ignoreEvent = objc_getAssociatedObject(self, &associateKeys.ignoreEvent) as? Bool {
                return ignoreEvent
            }
            return false
        }
    
    }
    
    func my_sendAction(_ action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        
        eventTimeInterval = eventTimeInterval == 0 ? 0.5 : eventTimeInterval
        if isIgnoreEvent {
            return
        }else if eventTimeInterval > 0{
            isIgnoreEvent = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(eventTimeInterval)*Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: { 
                self.isIgnoreEvent = false
            })
            my_sendAction(action, to: target, forEvent: event)
        }else{
            my_sendAction(action, to: target, forEvent: event)
        }
    }
    
    open override class func initialize(){
    
        struct Static{
            static var token:Int = 0
        }
     
//        dispatch_once(&Static.token) { 
        
            let originalSelector = #selector(UIButton.sendAction)
            let swizzledSelector = #selector(UIButton.my_sendAction(_:to:forEvent:))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            //运行时为类添加自己的方法
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            print(didAddMethod)
            if didAddMethod{
                //如果添加成功，则交换方法
                class_replaceMethod(self, swizzledSelector , method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            }else{
                //如果添加失败，则交换方法的具体实现
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
            
            
//        }
    }
    
}

//MARK:======== viewController上弹出层的扩展
extension UIViewController{

    struct Static {
        static var httpHUDKey = "http_HUD_key"
    }
    var HUD:MBProgressHUD?{
        set{
        objc_setAssociatedObject(self, &Static.httpHUDKey, newValue! as MBProgressHUD, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
        
            if let hud = objc_getAssociatedObject(self, &Static.httpHUDKey) as? MBProgressHUD {
                return hud
            }
            return nil
        }
    }
    
    
    func showHUD(_ str:String,delay:TimeInterval,view:UIView) -> Void {
        
        let HUD = MBProgressHUD(view: view)
        HUD.label.text = str
        view.addSubview(HUD)
        HUD.show(animated: true)
        HUD.hide(animated: true, afterDelay: delay)
        self.HUD = HUD
        
    }
    
    func showHUDImg(_ imgName:String?, str:String,delay:TimeInterval,view:UIView) -> Void {
        let HUD = MBProgressHUD(view: view)
        HUD.label.text = str
        view.addSubview(HUD)
        HUD.mode = .customView
        if imgName != nil {
            HUD.customView = UIImageView(image: UIImage(named: imgName!))
        }
        HUD.show(animated: true)
        HUD.hide(animated: true, afterDelay: delay)
        self.HUD = HUD
        
    }
    
    func hideHUD() -> Void {
        self.HUD?.hide(animated: true)
    }
    
    

}

