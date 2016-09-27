//
//  SunScoket.swift
//  常用|基类-swift
//
//  Created by chedao on 16/8/3.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class SunUdpSocket: NSObject,GCDAsyncUdpSocketDelegate{
    

    
    /** 接收到的数据回调 */
    var receivedData:((Data)->Void)?
    /** 发送完成 */
    var sendData:(()->Void)?
    
    
    
    var UdpSocket:GCDAsyncUdpSocket?
    var port:UInt16?
    
    static var share : SunUdpSocket {
        struct Static{
            static let instance : SunUdpSocket = SunUdpSocket()
        }
        return Static.instance
    
    }
    

    
    
    override init() {
       super.init()
      UdpSocket =  GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.global())
//        UdpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default))
    }

    /**开启服务器*/
    func startConnectSocket() -> Void {

        do{
            try UdpSocket?.bind(toPort: port!)
        }catch let error {
            print("开启服务器失败",error)
        }
        beginReceivingData()
        
    }
    
    /** 关闭服务器  */
    func closeSocket()->Void{
        UdpSocket?.close()
    }
    
    /** 开始一直接受数据, 默认 */
    func beginReceivingData() -> Void {
        
    do {
        try UdpSocket?.beginReceiving()
        }catch let error {
        print("一直接受收开启失败",error)
        
        }
        
    }
    /** 只接收一次数据 */
    func beginReceivingOnceData()->Void{
        
        do {
            try UdpSocket?.receiveOnce()
        }catch let error {
            print("一直接受收开启失败",error)
            
        }
    
    }
    
    /** 停止接收数据 */
    func stopReceivedData() -> Void {
        UdpSocket?.pauseReceiving()
    }
    
    
    
    //接收端
    private func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: AnyObject?) {

        if receivedData != nil {
            receivedData!(data)
        }
        
//        let msg = String(data: data, encoding: NSUTF8StringEncoding)
//        print(msg)
        //MARK:===收到消息的处理
//        sock.connectedHost()
        //收到消息之后返回给客户端收到消息
//        sock.sendData(data, toAddress: address, withTimeout: -1, tag: 0)
    }
    
    

    /** 发送数据  */
    func sendData(_ ip:String,prot:UInt16,msg:String) -> Void {
        let data  = msg.data(using: String.Encoding.utf8)
        UdpSocket?.send(data!, toHost: ip, port: prot, withTimeout: -1, tag: 0)
    }
    
    //发送失败
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error) {
        print(tag,error)
    }
    
    //发送数据的回调
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        if sendData != nil {
            sendData!()
        }
        print(tag,"发送完成")
    }

}
