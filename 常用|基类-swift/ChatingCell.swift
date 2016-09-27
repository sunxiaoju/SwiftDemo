//
//  ChatingCell.swift
//  常用|基类-swift
//
//  Created by chedao on 16/8/30.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit
import SnapKit

class ChatingCell: UITableViewCell {

    
    var leftConstraint:Constraint?
    var rightConstraint:Constraint?
    lazy var friendIcon:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "photo_default3"), for: UIControlState())
        btn.addTarget(self, action: #selector(ChatingCell.actionIcon(_:)), for: .touchUpInside)
        self.contentView.addSubview(btn)
        btn.snp.makeConstraints({ (make) in
            make.left.top.equalTo(10)
            make.height.width.equalTo(50)
        })
        
        return btn
    }()
    
    lazy var selfIcon:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "photo_default3"), for: UIControlState())
        btn.addTarget(self, action: #selector(ChatingCell.actionIcon(_:)), for: .touchUpInside)
        self.contentView.addSubview(btn)
        btn.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.height.width.equalTo(50)
        })
        return btn
    
    }()
    
    
    lazy var chatBtn:UIButton = {
        let btn = UIButton()
        btn.isEnabled = false
        let image = UIImage(named: "menu_single_normal")
        let imageN = image?.resizableImage(withCapInsets: UIEdgeInsets(top:0,left:15,bottom:0,right:15), resizingMode:.stretch)
        btn.setTitleColor(UIColor.black, for: UIControlState())
        btn.titleLabel?.numberOfLines = 0
        btn.setBackgroundImage(imageN, for: UIControlState())
        self.contentView.addSubview(btn)
        btn.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            self.leftConstraint = make.left.equalTo(self.friendIcon.snp.right).offset(10).priority(250).constraint
            make.bottom.equalTo(-10)
           self.rightConstraint = make.right.equalTo(self.selfIcon.snp_left).offset(-10).priority(250).constraint
            make.width.equalTo(SCREEN_WIDTH - 140)
        })
        return btn
    }()
    
    func actionIcon(_ btn:UIButton) -> Void {

    }
  

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func packCell(_ model:MessageModel) -> Void {
    
        chatBtn.setTitle(model.message, for: UIControlState())
        if model.sign == 0 {
        //自己
            friendIcon.isHidden = true
            selfIcon.isHidden = false
            self.leftConstraint?.updatePriority(260)
            self.rightConstraint?.updatePriority(300)
            
        }else{
        //朋友
            friendIcon.isHidden = false
            selfIcon.isHidden = true
            self.leftConstraint?.updatePriority(300)
            self.rightConstraint?.updatePriority(260)
        }
        let rect = getRect(model.message!)
        if rect.height < 50 {
            self.chatBtn.snp.updateConstraints({ (make) in
                make.width.equalTo(rect.width + 10)
            })
        }
        
        
        
    }
    
    func cellForRowHeight(_ model:MessageModel) -> CGFloat {
        
      let rect = getRect(model.message!)
        print(rect)
        
        if rect.height < 50 {
            return 70
        }
       return rect.height + 70
        
    }
    
    func getRect(_ str:String) -> CGRect {
        
    return (str as NSString).boundingRect(with: CGSize(width: SCREEN_WIDTH - 140, height: 10000), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:(self.chatBtn.titleLabel?.font)!], context: nil)
    }
    

}
