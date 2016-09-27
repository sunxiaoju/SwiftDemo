//
//  ViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/7/13.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit
import MJRefresh
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    lazy var tableView:UITableView = {
        let tv = UITableView(frame: self.view.bounds, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    var dataArr  = ["动画","相机","获取相册中所有照片","html","客户端","服务端","chating","alert","银联支付"]
    
    
    
    lazy var rightBarBtn:UIBarButtonItem = {
    
        let btn = UIButton(frame: CGRect(x: 0,y: 0,width: 40,height: 40))
        btn.btn_enabled =  true
        btn.setBackgroundImage(UIImage(named: "time_check"), for: .disabled)
        btn.setBackgroundImage(UIImage(named: "take-snap"), for: UIControlState())
//        btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (btn) in
//            print("dianjile")
//        })
        btn.eventTimeInterval = 1
        return UIBarButtonItem(customView:btn)
    
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kHexColor(0xe0e0e0)
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
//        let btn = UIButton(frame: CGRectMake(0,74,40,40))
//        btn.btn_enabled =  true
//        btn.setBackgroundImage(UIImage(named: "time_check"), forState: .Disabled)
//        btn.setBackgroundImage(UIImage(named: "take-snap"), forState: .Normal)
//        //        btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (btn) in
//        //            print("dianjile")
//        //        })
//        btn.addTarget(self, action: #selector(ViewController.btnClick), forControlEvents: .TouchUpInside)
//        
//        self.view.addSubview(btn)
//        self.view.bringSubviewToFront(btn)
        
//        let str = STools().getNetWorkingState()
//        print(str)

        let string = STools().carveStringSpance("4654654564564565646646")
        print(string)
        
        
        var arr = [2,4,1,5,6,2,9]
        let newArr = arr.sorted()
        print(newArr)
        
        for i in 0..<arr.count {
            
            for j in i+1..<arr.count {
                
                if arr[i] > arr[j] {
                    
                    swap(&arr[i], &arr[j])
                
                }
                
                
            }
        }
        print("快速排序",arr)
        
        
        for i in 0..<arr.count {
            for j in 0..<arr.count-1-i {
                if arr[j] < arr[j+1] {
                    swap(&arr[j], &arr[j+1])
                }
            }
        }
        print("冒泡排序",arr)

       
        self.view.addSubview(tableView)

//    self.showHUDImg(nil, str: "标题", delay: 10, view: self.view)
        self.showHUD("标题", delay: 10, view: self.view)

        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
        }
        cell?.textLabel?.text = dataArr[(indexPath as NSIndexPath).row]
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0 {
            self.navigationController?.pushViewController(AnimationViewController(), animated: true)

        }else if (indexPath as NSIndexPath).row == 1 {
         self.navigationController?.pushViewController(SunCameraViewController(), animated: true)
        
        }else if (indexPath as NSIndexPath).row == 2 {
            STools().getPhotoData(){ images in
                print(images)
            }
        
        }else if (indexPath as NSIndexPath).row == 3{
            self.navigationController?.pushViewController(HtmlViewController(), animated: true)

        
        }else if (indexPath as NSIndexPath).row == 4{
            self.navigationController?.pushViewController(UdpClientViewController(), animated: true)
            
            
        }else if (indexPath as NSIndexPath).row == 5{
            self.navigationController?.pushViewController(UdpServiceViewController(), animated: true)
            
            
        }else if (indexPath as NSIndexPath).row == 6 {
            self.navigationController?.pushViewController(SocketViewController(style: .plain, needRefresh: false, needLoadMore: false), animated: true)
        }
        else if (indexPath as NSIndexPath).row == 7 {
            let alert = AlertViewController(title: "标题", message: nil, preferredStyle: .alert)
            alert.addActions("取消", others: ["确定"], actionPressed: { (action, index) in
                print(index)
            })
            self.present(alert, animated: true, completion: nil)
        }else if indexPath.row == 8 {
        self.navigationController?.pushViewController(UnionPayViewController(), animated: true)
            
        }
        
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

