//
//  CricuitView.swift
//  常用|基类-swift
//
//  Created by chedao on 16/9/8.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit

 let criTime:TimeInterval = 5.0

class CricuitView: UIView,UIScrollViewDelegate {
    

    
    lazy var scrollView:UIScrollView = {
        let scrollW = self.bounds.width
        let scrollH = self.bounds.height
        let scrollView =  UIScrollView(frame: CGRect(x: 0,y: 0,width: scrollW,height: scrollH))
        scrollView.backgroundColor = UIColor.white
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    
    lazy var pageC:UIPageControl = {
        let pageW = self.bounds.width
        let  pageC = UIPageControl(frame: CGRect(x: pageW * 0.5 - 50,y: self.bounds.height - 10,width: 100,height: 5))
        pageC.currentPage = 0
//        pageC.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named:"")!)
//        pageC.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "")!)
        return pageC
    }()
    //MARK:+++++定时器
    var timer:Timer?
    func createTimer() -> Void {
        self.timer  = Timer.scheduledTimer(timeInterval: criTime, target: self, selector: #selector(CricuitView.timeChange), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
    
    func timeChange() -> Void {
        let width:CGFloat = self.scrollView.bounds.width
        let index = Int(self.scrollView.contentOffset.x/width)
        
        self.scrollView.setContentOffset(CGPoint(x: CGFloat(index + 1)*width, y: 0), animated: true)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(self.scrollView)
        self.addSubview(self.pageC)
        createTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
   
    //MARK:============UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.timer?.invalidate()
        self.timer = nil
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        createTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width:CGFloat = self.scrollView.bounds.width
        let index = Int(self.scrollView.contentOffset.x/width)
        if index == imageArr!.count + 1 {
            self.scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
            self.pageC.currentPage = 0
        }else if index == 0{
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(imageArr!.count)*width, y: 0), animated: false)
            self.pageC.currentPage = self.imageArr!.count - 1
        }else{
            self.pageC.currentPage = index - 1

        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView)
    }
    
    //MARK:================== 设置轮播图片
    
    var imageArr:[String]?
    
    func isUrl(_ str:String) -> Bool {
        return CFStringHasPrefix(str as CFString!, "http://" as CFString!) || CFStringHasPrefix(str as CFString!, "https://" as CFString!) ? true : false
    }
    func makeCricuitImage(_ imageArr:[String]) -> Void {
        self.imageArr = imageArr
        let scrollW = self.bounds.width
        let scrollH = self.bounds.height
        pageC.numberOfPages = imageArr.count
        for i in 0..<imageArr.count {
            
            let iv = UIImageView()
            iv.backgroundColor = UIColor.cyan
            iv.isUserInteractionEnabled = true
            let imageX = scrollW * CGFloat(i + 1)
            iv.frame = CGRect(x: imageX, y: 0, width: scrollW, height: scrollH)
            self.scrollView.addSubview(iv)
            //MARK:设置图片
            if isUrl(imageArr[i]) {
             //设置sdwebimage
                
            }else{
                iv.image = UIImage(named: imageArr[i])
            }
        
            let tap = UITapGestureRecognizer(target: self, action: #selector(CricuitView.cricuitClick(_:)))
            iv.addGestureRecognizer(tap)
            iv.tag = 500 + i
        }
        
        let fristV = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollW, height: scrollH))
        self.scrollView.addSubview(fristV)
        let lastV = UIImageView(frame:CGRect(x: scrollW * CGFloat(imageArr.count + 1), y: 0, width: scrollW, height: scrollH))
        self.scrollView.addSubview(lastV)
        if isUrl(imageArr.last!) {
            //设置sdwebimage
        }else{
            fristV.image = UIImage(named: imageArr.last!)
        }
        
        if isUrl(imageArr[0]) {
            //设置sdwebimage
        }else{
            lastV.image = UIImage(named: imageArr[0])
        }
//
        scrollView.contentOffset = CGPoint(x: scrollW, y: 0)
        scrollView.contentSize = CGSize(width: CGFloat(imageArr.count + 2 ) * scrollW, height: scrollH)
        
        
    }
    
    //MARK:轮播图图片的点击事件
    func cricuitClick(_ tap:UITapGestureRecognizer) -> Void {
        
        print(tap.view?.tag)
        
    }

}
