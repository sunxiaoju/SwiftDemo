//
//  UdpClientViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/8/8.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
class UdpClientViewController: SunBaseViewController,GCDAsyncSocketDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        SunTcpSocket.share.connectToHost("10.3.22.122", port: 8080)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        SunUdpSocket.share.sendData("10.3.22.165", prot: 8080, msg: "hello")
//        SunTcpSocket.share.sendData("sunxiaoju")
  
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
