//
//  UdpServiceViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/8/8.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit

class UdpServiceViewController: SunBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SunTcpSocket.share.port = 8080
        SunTcpSocket.share.startConnectSocket()
        
        let criView = CricuitView(frame: CGRect(x: 0,y: 100,width: SCREEN_WIDTH,height: 150))
        self.view.addSubview(criView)
        criView.makeCricuitImage(["green","red","blue","jiangnan"])
    
    }

}
