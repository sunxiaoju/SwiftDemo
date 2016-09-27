//
//  SunScoket.swift
//  常用|基类-swift
//
//  Created by chedao on 16/8/3.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit

class SunSocket: NSObject,GCDAsyncSocketDelegate {
    
    var asySocket:asy?
    var port:UInt16?
    
    
    
    class var share:SunSocket {
        struct Static {
            static var onceToken:dispatch_once_t = 0
            static var instance:SunSocket? = nil
        }
        
        dispatch_once(&Static.onceToken) { 
            Static.instance = SunSocket()
        }
        return Static.instance!
    }
    
    
    override init() {
       super.init()
//        asySocket = asy
    }

    
    func startConnectSocket() -> Void {
        do{
         try asySocket?.acceptOnPort(port!)
        }catch{
            print("开启服务器失败")
        }
        
    }
    

    
    

}
