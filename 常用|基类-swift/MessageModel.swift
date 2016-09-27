//
//  MessageModel.swift
//  常用|基类-swift
//
//  Created by chedao on 16/8/12.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit

class MessageModel: NSObject {
    var message:String?
    var sign:Int?
    
    func packMessageModel(_ dic:[String:AnyObject]) -> MessageModel {
        let model = MessageModel()
        model.message = dic["message"] as? String
        model.sign = dic["sign"] as? Int
        return model
    }
    
    

}
