//
//  STools.swift
//  常用|基类-swift
//
//  Created by chedao on 16/7/13.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit
import Photos

private let application = UIApplication.sharedApplication()

class STools: NSObject {

    /** 每四个字符之间加一个空格区分 */
    func carveStringSpance(str:String)->String{
        let  newStr = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let array  = NSMutableArray()
        for item in 0..<(newStr.length/4 + 1) {

            if item == newStr.length/4 {
                array.addObject(newStr.substringWithRange(NSMakeRange(item*4, newStr.length%4)))
            }else{
                array.addObject(newStr.substringWithRange(NSMakeRange(item*4, 4)))
            }
        }
        
        return array.componentsJoinedByString(" ")
    }
    
    //MARK:  获取手机网络信息
    /** 获取当前的网络状态：
     *无网络;2G;3G;4G;WIFI
     */
    func getNetWorkingState() -> String {
        let childrens = application.valueForKeyPath("statusBar")?.valueForKeyPath("foregroundView")?.subviews
        var state = "无网络"
        var netType = 0
        for child in childrens! {
            
            if child.isKindOfClass(NSClassFromString("UIStatusBarDataNetworkItemView")!) {
                
                netType = child.valueForKeyPath("dataNetworkType")!.integerValue
                switch netType {
                case 0:
                    state = "无网络"
                    break
                case 1:
                    state = "2G"
                    break
                case 2:
                    state = "3G"
                    break
                case 3:
                    state = "4G"
                    break
                case 5:
                    state = "WIFI"
                    break
                default:
                    break
                }
                
                
            }
            
            
        }
        return state
    }
    
//    /** 借助类库判断网络  需要导入Reachability类 */
//    private  var conn:Reachability?
//    func addObserver(netClosure:(String)->Void) -> Void {
//       
//        conn = try? Reachability.reachabilityForInternetConnection()
//        var state = "无网络"
//        conn?.whenReachable = { reach in
//       
//            dispatch_async(dispatch_get_main_queue(), { 
//                if  reach.isReachableViaWiFi() {
//                    state = "WIFI"
//                }else if reach.isReachableViaWWAN() {
//                    
//                    state = "移动"
//                }else{
//                    state = "无网络"
//                }
//                netClosure(state)
//            })
//            
//        }
//        do {
//            try conn!.startNotifier()
//        }catch{}
//    }
//    
   
    
    /** 获取相册中的所有图片  */
    
    func  getPhotoData(closure:([UIImage]->Void)) -> Void{
        
        var  imageArr = [UIImage]()
        /** 获取所有资源几个 并按创建时间排序 */
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let fetchResults = PHAsset.fetchAssetsWithOptions(options)
        
        for i in 0..<fetchResults.count {
            let asset = fetchResults[i]
            PHImageManager.defaultManager().requestImageDataForAsset(asset as! PHAsset, options: nil, resultHandler: { (imageData, dataUI, orientation, info) in
                
                let image = UIImage(data: imageData!)
                imageArr.append(image!)
                
                if imageArr.count == fetchResults.count {
                    closure(imageArr)
                }
                
            })
            
        }
    }
    
    
//    /** 自定义tabbar的背景图片 */
//    func tabBarBackgroundImage(str:String,tabbar:UITabBar)->Void{
//        
//        tabbar.backgroundImage = UIImage(named: str)
//    
//    
//    }
    
    
    
}
