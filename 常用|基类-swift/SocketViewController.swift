//
//  SocketViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/8/11.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit

class SocketViewController: SunTableViewController,UITextFieldDelegate {

    
    lazy var serviceSocket:SunTcpSocket = {
        return SunTcpSocket()
    }()
    
    lazy var clientSocket:SunTcpSocket = {
        return SunTcpSocket()
    }()
    var dataArr = [MessageModel]()

    lazy var textField:UITextField = {
        
        let tf = UITextField()
        tf.returnKeyType = .send
        tf.borderStyle = .none
        tf.backgroundColor = UIColor.green
        tf.delegate = self
        self.view.addSubview(tf)
        tf.snp.updateConstraints({ (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(40)
        })
        return tf
    
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAlert()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clientSocket.disConnect()
    
    }
    
    //MARK:弹出框
    func showAlert() -> Void {
        let alert = UIAlertController(title: "链接ip", message:nil , preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
        }
        alert.addActions("取消", others: ["连接"]) { (action, index) in
            switch index {
            case 0:
                alert.dismiss(animated: true, completion: nil)
                break
            default:
                
                self.clientSocket.connectToHost((alert.textFields?.last?.text)!, port: 8080)
                break
            }
            
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "聊天";
        self.tableView?.tableFooterView? = UIView()
        self.tableView?.backgroundColor = UIColor.blue
        self.tableView?.register(ChatingCell.self, forCellReuseIdentifier: "chatingCell")
        
        self.tableView?.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(self.textField.snp.top)
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(SocketViewController.showKEyboard(notification:)), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.rac_addObserverForName(NSNotification.Name.UIKeyboardWillShow, object: nil).subscribeNext({ (notification) in
//                    })
        
        NotificationCenter.default.addObserver(self, selector: #selector(SocketViewController.hideKeyboard(noti:)), name: .UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.rac_addObserverForName(NSNotification.Name.UIKeyboardWillHide, object: nil).subscribeNext { (notification) in
//
//            var bounds = self.view.bounds
//            bounds.origin.y = 0
//            UIView.animateWithDuration(0.5, animations: { 
//                self.view.bounds = bounds
//                self.view.layoutIfNeeded()
//            })
//        }
        serviceSocket.port = 8080
        serviceSocket.startConnectSocket()
        serviceSocket.receivedData = { data in
            print(Thread.current)
         
            let message = String(data: data as Data, encoding: String.Encoding.utf8)
            DispatchQueue.main.async(execute: { 
                self.dataArr.append(MessageModel().packMessageModel(["message":message! as AnyObject,"sign":1 as AnyObject]))
                self.scrollTableviewtoEnd()
            })
        }
    }
    
    func showKEyboard(notification:Notification) -> Void {
        let keyHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.height
        var bounds = self.view.bounds
        bounds.origin.y = keyHeight
        UIView.animate(withDuration: 0.5, animations: {
            self.view.bounds = bounds
            self.view.layoutIfNeeded()
        })

    }
    func hideKeyboard(noti:Notification) -> Void {
        var bounds = self.view.bounds
        bounds.origin.y = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.bounds = bounds
            self.view.layoutIfNeeded()
        })
    }
    
    func scrollTableviewtoEnd(){
        
            self.tableView?.insertRows(at: [IndexPath(row: self.dataArr.count - 1, section: 0)], with: .bottom)
            self.tableView?.scrollToRow(at: IndexPath(row: self.dataArr.count - 1, section: 0), at: .bottom, animated: false)
    }
    

    //MARK:======== UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        clientSocket.sendData(textField.text as AnyObject?) { (result) in
            DispatchQueue.main.async {
            self.dataArr.append(MessageModel().packMessageModel(["message":textField.text! as AnyObject,"sign":0 as AnyObject]))
                print(Thread.current)
                self.scrollTableviewtoEnd()
                
                self.textField.text = nil
            }
            
        }
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatingCell") as! ChatingCell
        cell.packCell(dataArr[(indexPath as NSIndexPath).row])
         return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatingCell") as! ChatingCell
        return cell.cellForRowHeight(dataArr[(indexPath as NSIndexPath).row])
    }
}
