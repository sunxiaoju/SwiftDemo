//
//  SunTableViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/7/18.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit

class SunTableViewController: SunBaseViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {

    
    var tableView:UITableView?
    var tableStyle:UITableViewStyle?
    var refresh:Bool?
    var loadMore:Bool?
    
    
    
    
    var navBarChangePoint:CGFloat = 0
    
    
     init(style:UITableViewStyle,needRefresh:Bool,needLoadMore:Bool){
        super.init(nibName: nil, bundle: nil)
        self.tableStyle = style
        self.refresh = needRefresh
        self.loadMore = needLoadMore
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        self.navBarApperanceAlpha()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "background"), forBarMetrics: .Default)
    }
    func initTableView() -> Void {
        tableView = UITableView(frame: CGRect.zero, style: tableStyle!)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        tableView?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(tableView!)
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        let dic =  ["tableView":self.tableView!]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: .AlignAllLeft, metrics: nil, views: dic))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(-64)-[tableView]|", options: .AlignAllLeft, metrics: nil, views: dic))
        self.view.layoutIfNeeded()
        
        if refresh! {
           //增加刷新信息
            
        }
        
        if loadMore! {
            //加载更多
            
            
        }
        
        
    }
    
     func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offset_y = scrollView.contentOffset.y
        print(offset_y)
        
        if offset_y > navBarChangePoint {
            let alpha = 1 - (navBarChangePoint + 64 - offset_y)/60
            self.navigationController?.navigationBar.subviews.first?.alpha = alpha
        }else{
            self.navigationController?.navigationBar.subviews.first?.alpha = 0
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "reuseIdentifier")
        }
        cell?.textLabel?.text = "123"
        return cell!
    }
    

}
