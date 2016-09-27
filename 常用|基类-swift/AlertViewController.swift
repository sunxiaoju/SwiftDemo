//
//  AlertViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/9/5.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit



private let cellID = "alertCell"

class AlertViewController: UIAlertController,UITableViewDelegate,UITableViewDataSource {

    
    fileprivate lazy var tableview:UITableView = {
        var tv = UITableView(frame: CGRect(x: 0, y: 0, width: 300, height: 142), style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.tableFooterView = UIView()
        self.view.addSubview(tv)
//        tv.translatesAutoresizingMaskIntoConstraints = false
//       let dic = ["tv":tv]
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tv]|", options: .AlignAllLeft, metrics: nil, views: dic))
//        
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-50-[tv(142)]-50-|", options: .AlignAllLeft, metrics: nil, views: dic))
        return tv
    
    }()
    
    var dataArr = Array<String>() {
    
        didSet{
            self.tableview.reloadData()
            
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//    self.view.sendSubviewToBack(self.tableview)
//        self.view.frame = CGRectMake(0, 0, self.view.frame.width, 442)
        
        
    }

    //MARK:============== tableviewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
             cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        
        cell?.textLabel?.text = dataArr[(indexPath as NSIndexPath).row]
        
        return cell!
    }
    
    
}
