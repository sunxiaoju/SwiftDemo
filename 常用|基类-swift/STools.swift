//
//  STools.swift
//  常用|基类-swift
//
//  Created by chedao on 16/7/13.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit
import Photos

private let application = UIApplication.shared

class STools: NSObject {

    /** 每四个字符之间加一个空格区分 */
    func carveStringSpance(_ str:String)->String{
        let  newStr = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
        let array  = NSMutableArray()
        for item in 0..<(newStr.length/4 + 1) {

            if item == newStr.length/4 {
                array.add(newStr.substring(with: NSMakeRange(item*4, newStr.length%4)))
            }else{
                array.add(newStr.substring(with: NSMakeRange(item*4, 4)))
            }
        }
        
        return array.componentsJoined(by: " ")
    }
    
    //MARK:  获取手机网络信息 ===== XCode8 中报错
    /** 获取当前的网络状态：
     *无网络;2G;3G;4G;WIFI
     */
    func getNetWorkingState() -> String {
        let childrens = ((application.value(forKeyPath: "statusBar") as AnyObject).value(forKeyPath: "foregroundView") as AnyObject).subviews
        var state = "无网络"
        var netType = 0
        for child in childrens! {
            
            if child.isKind(of: NSClassFromString("UIStatusBarDataNetworkItemView")!) {
                
                netType = (child.value(forKeyPath: "dataNetworkType")! as AnyObject).intValue
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
    
    func  getPhotoData(_ closure:@escaping (([UIImage])->Void)) -> Void{
        
        var  imageArr = [UIImage]()
        /** 获取所有资源几个 并按创建时间排序 */
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let fetchResults = PHAsset.fetchAssets(with: options)
        
        for i in 0..<fetchResults.count {
            let asset = fetchResults[i]
            PHImageManager.default().requestImageData(for: asset , options: nil, resultHandler: { (imageData, dataUI, orientation, info) in
                
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

extension UIImage{

    /** 设置图片的方向 */
    func normlizedImage() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImagte = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImagte!
    }
    
    func fixOrientation()->UIImage{
    
        
        if (self.imageOrientation == UIImageOrientation.up) {
            return self
        
        }
        var transform = CGAffineTransform.identity;
        switch (self.imageOrientation) {
        case UIImageOrientation.downMirrored,.down:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height);
            transform = transform.rotated(by: CGFloat(M_PI));
            break;
            
        case UIImageOrientation.leftMirrored,.left:
            transform = transform.translatedBy(x: self.size.width, y: 0);
            transform = transform.rotated(by: CGFloat(M_PI_2));
            break;
            
        case UIImageOrientation.rightMirrored,.right:
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-M_PI_2));
            break;
        case UIImageOrientation.upMirrored,.up:
            break;
        }
        
        switch (self.imageOrientation) {
        case UIImageOrientation.downMirrored,.upMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
            break;
            
        case UIImageOrientation.rightMirrored,.leftMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
            break;
        case UIImageOrientation.up,.down,.left,.right:
            break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                                 bitsPerComponent: (self.cgImage?.bitsPerComponent)!, bytesPerRow: 0,
                                                 space: (self.cgImage?.colorSpace!)!,
                                                bitmapInfo: (self.cgImage?.bitmapInfo.rawValue)!);
        ctx?.concatenate(transform);
        switch (self.imageOrientation) {
        case UIImageOrientation.left,.leftMirrored,.right,.rightMirrored:
            // Grr...
            ctx?.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width));
            break;
            
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height));
            break;
        }
        
        let cgimg = ctx?.makeImage();
        let img = UIImage(cgImage: cgimg!);
        return img;
    
    }
    
}


