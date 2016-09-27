//
//  UnionPayViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/9/27.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit

class UnionPayViewController: SunBaseViewController {

    /** 测试获取流水交易号 */
    fileprivate let tn_normal = "http://101.231.204.84:8091/sim/getacptn"
    /** 暗号跳转 */
    fileprivate let scheme = "UPPaySwift"
    /** 
     * 环境
     * 01 测试环境
     * 00 正式环境
     */
    fileprivate let mode = "01"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let btn = UIButton()
        btn.frame = CGRect(x: 30, y: 100, width: 200, height: 60)
        btn.setBackgroundImage(UIImage(named: "background" ), for: .normal)
        btn.setTitle("点击支付", for: .normal)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(UnionPayViewController.startPay), for: .touchUpInside)
    }
        
    
    
    func startPay() -> Void {
        let req = URLSession.init(configuration: URLSessionConfiguration.default)
        req.dataTask(with: URLRequest(url: URL(string: tn_normal)!)) { (data, respose, error) in
            if (respose as! HTTPURLResponse).statusCode != 200 {
                req.invalidateAndCancel()
                print("请求失败")
            }else{
                let tn = String(data: data!, encoding: .utf8)
                if tn != nil && (tn?.characters.count)! > 0 {
                    UPPaymentControl.default().startPay(tn, fromScheme: self.scheme, mode: self.mode, viewController: self)
                }
            }
            
            }.resume()
        
    }
    
}
