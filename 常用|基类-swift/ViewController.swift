//
//  ViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/7/13.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    lazy var tableView:UITableView = {
        let tv = UITableView(frame: self.view.bounds, style: .Plain)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    var dataArr  = ["动画","相机","获取相册中所有照片"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kHexColor(0xe0e0e0)
        let str = STools().getNetWorkingState()
        print(str)

        let string = STools().carveStringSpance("4654654564564565646646")
        print(string)
        
        
        let arr = [2,4,1,5,6,2,9]
        let newArr = arr.sort()
        print(newArr)

       
        
        self.view.addSubview(tableView)
        
        
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            cell?.selectionStyle = .None
        }
        cell?.textLabel?.text = dataArr[indexPath.row]
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(AnimationViewController(), animated: true)

        }else if indexPath.row == 1 {
         self.navigationController?.pushViewController(SunCameraViewController(), animated: true)
        
        }else if indexPath.row == 2 {
            STools().getPhotoData(){ images in
                print(images)
            }
        
        }
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

