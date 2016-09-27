//
//  SunTcpSocket.swift
//  常用|基类-swift
//
//  Created by chedao on 16/8/9.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class SunTcpSocket: NSObject,GCDAsyncSocketDelegate {

//    private static var __once: () = { 
//            
//            Static.instance = SunTcpSocket()
//        }()

    /** 接收到的数据回调 */
    var receivedData:((Data)->Void)?
    /** 发送完成 */
    var sendDataResult:((Bool)->Void)?
    
    var TcpSocket:GCDAsyncSocket?
    var port:UInt16?
    lazy var clientSockets:[GCDAsyncSocket] = {
        let array = [GCDAsyncSocket]()
        return array
    }()
    
    static var share : SunTcpSocket {
        struct Static{
            static let instance : SunTcpSocket = SunTcpSocket()
        }
        return Static.instance
        
    }
    
    /*
     全局队列（代理的方法是在子线程被调用）
     dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
     
     主队列（代理的方法会在主线程被调用）
     dispatch_get_main_queue()
     代理里的动作是耗时的动作，要在子线程中操作
     代理里的动作不是耗时的动作，就可以在主线程中调用
     看情况写队列
     */

    override init() {
        super.init()
        TcpSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default))
    }
    
    /** 开启服务器 */
    func startConnectSocket(){
        
        do{
            try TcpSocket?.accept(onPort: port!)
            print("开启服务器成功")
        }catch let error {
            print("开启服务器失败",error)
        }
        TcpSocket?.readData(withTimeout: -1, tag: 0)

    }
    
    /**
     *   服务器监听到有客户端接入会调用这个代理方法
     *
     *   @param sock        服务端
     *   @param newSocket   客户端
     *
     */
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        print("服务端",sock)
        print( "客户端",newSocket.connectedHost)
        //有新客户端接入加入数组保存
        clientSockets.append(newSocket)
        newSocket.readData(withTimeout: -1, tag: 0)
        
        
    }
    
    //服务器读取客户端发送的信息
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        if receivedData != nil {
            receivedData!(data)
        }
        print("服务端收到消息",data)
        sock.readData(withTimeout: -1, tag: 0)
        
    }
    
    /**  用户端连接服务器  */
    func connectToHost(_ host:String,port:UInt16)->Void{
    
        do{
            try TcpSocket?.connect(toHost: host, onPort: port,withTimeout: -1)
        }catch let error {
            print("连接服务器失败",error)
        }
    }

    /** 断开连接  */
    func disConnect()->Void{
   
        TcpSocket?.disconnect()
        print("断开连接")
        
        
    }
   
    /**  发送数据给服务器  */
    func sendData(_ data:AnyObject?,result:@escaping (Bool)->Void)->Void{
          sendDataResult = result
        if data == nil && TcpSocket?.isConnected == true {
            return
        }
        
//        let sendData = try? NSJSONSerialization.dataWithJSONObject(data!, options: .PrettyPrinted)
        let sendData = (data as! NSString).data(using: String.Encoding.utf8.rawValue)
        TcpSocket?.write(sendData!, withTimeout: -1, tag: 0)
        
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        print("消息发送成功")
        if sendDataResult != nil {
            sendDataResult!(true)
        }
    }
    
    
    //连接成功
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("连接成功",host,port)
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    
    
    
    
}
