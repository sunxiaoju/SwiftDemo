//
//  ShowAnimationViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/7/25.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit


// 设置锚点（动画围绕的中心点） 中心点、左下角和右上角的anchorPoint为(0.5,0.5), (0,1), (1,0)
//iv.layer.anchorPoint = CGPointMake(1, 0.5)


class ShowAnimationViewController: SunBaseViewController {

    var type:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if type == 0 {
            radarAnimation()
        }else if type == 1{
            pointsJoinlines()
        }else if type == 2{
            TranSlation3D()
        }else if type == 3{
            affineTransform()
        }else if type == 4{
            planeAnimation()
        }else if type == 5{
            viewAnimation()
        }else if type == 6{
            ceshi()
        }
    
    }

    
    //MARK:===============雷达效果
    func radarAnimation(){
    
        for i in 0..<5{
        
        let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            imageV.center = self.view.center
            imageV.image = UIImage(named: "time_check")
            
          let group = createAnimationGroup()
            group.beginTime = CFTimeInterval(i)
            imageV.layer.add(group, forKey: "fasan")
            self.view.addSubview(imageV)
        
        
        }
    
    }
    func createAnimationGroup() -> CAAnimationGroup {
    
        let animation1 = CABasicAnimation(keyPath: "transform.scale")
        animation1.fromValue = 0
        animation1.toValue = 4
        
        let animation2 = CABasicAnimation(keyPath: "opacity")
        animation2.fromValue = 1
        animation2.toValue = 0
        
        let groups = CAAnimationGroup()
        //动画时间
        groups.duration = 5.0
        //循环次数
        groups.repeatCount = FLT_MAX
        groups.autoreverses = false
        groups.animations = [animation1,animation2]
        //指定动画完成就移除
        groups.isRemovedOnCompletion = true
        return groups
    }
    
    //MARK:++++++++ 多个点连接出来的线路动画
    
    func pointsJoinlines() -> Void {
        let view  = UIView(frame: CGRect(x: 0,y: 0,width: 50,height: 50))
        view.backgroundColor = UIColor.red
        view.center = self.view.center
        self.view.addSubview(view)
        let keyFrame = keyFrameAniamtion(setValues(), time: 10, repeatCount: FLT_MAX)
        view.layer.add(keyFrame, forKey: nil)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ShowAnimationViewController.tapClick)))
        
    }
    func tapClick() -> Void {
        print("tap")
    }
    
    func setValues() -> [NSValue] {
        let v0 = NSValue(cgPoint: self.view.center)
       let v1 =  NSValue(cgPoint: CGPoint(x: 25, y: 254))
       let v2 = NSValue(cgPoint: CGPoint(x: 160, y: 89))
        let v3 = NSValue(cgPoint: CGPoint(x: 295, y: 254))
        let v4 = NSValue(cgPoint: CGPoint(x: 160, y: SCREEN_HEIGHT - 25))
        let v5 = NSValue(cgPoint: CGPoint(x: 25, y: 254))
        let v6 = NSValue(cgPoint: self.view.center)
        
        return [v0,v1,v2,v3,v4,v5,v6]
        ;
        
    }
    
    func keyFrameAniamtion(_ values:[AnyObject],time:CFTimeInterval,repeatCount:Float) -> CAKeyframeAnimation {
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.values = values
        animation.isRemovedOnCompletion = false
        //动画完成之后view展示的位置 removed/Backwards:坐标位置 Forwards/Both：动画结束的位置
        animation.fillMode = kCAFillModeRemoved
        animation.autoreverses = false
        animation.duration = time
        animation.repeatCount = repeatCount
        return animation
    }
    
    //MARK:+++++++++ 3D效果展示
    func TranSlation3D() -> Void{
        
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        iv.image = UIImage(named: "AppIcon60")
        iv.center = self.view.center
        self.view.addSubview(iv)
    
        // 设置锚点（动画围绕的中心点）
//        iv.layer.anchorPoint = CGPointMake(1, 0.5)
        
        /**
         tx正数往右，负数往左，ty正数往下，负数往上，对于tz来说，值越大，那么图层就越往外（接近屏幕），值越小，图层越往里（屏幕里）。
         CATransform3D transform3d = CATransform3DMakeTranslation(100, 40, 20);
         
         t：就是上一个函数。其他的都一样。
         可以理解为：函数的叠加，效果的叠加。
         CATransform3D CATransform3DTranslate (CATransform3D t, CGFloat tx, CGFloat ty, CGFloat tz);
         
         sx：X轴缩放，代表一个缩放比例，一般都是 0 --- 1 之间的数字。
         sy：Y轴缩放。
         sz：整体比例变换时，若sz<0，发生关于原点的对称等比变换。
         CATransform3D CATransform3DMakeScale (CGFloat sx, CGFloat sy, CGFloat sz);
         
         旋转效果。
         angle：旋转的弧度，所以要把角度转换成弧度：角度 * M_PI / 180。
         x：沿X轴方向旋转。值范围-1 --- 1之间
         y：沿Y轴方向旋转。值范围-1 --- 1之间
         z：沿Z轴方向旋转。值范围-1 --- 1之间
         CATransform3D CATransform3DMakeRotation (CGFloat angle, CGFloat x, CGFloat y, CGFloat z);
         
         */
        
        //图片偏移
//        UIView.animateWithDuration(3) { 
//            let animation1 = CATransform3DMakeTranslation(-100, 100, -50)
        //效果叠加之后获取的是先叠加在执行
//        let animation2 = CATransform3DTranslate(animation1, 100, -100, 50)
//            iv.layer.transform = animation1
//        }

        //图片缩放 s<0 会有翻转动画
//        UIView.animateWithDuration(3) {
//            let animation1 = CATransform3DMakeScale(0.5, 1, -1)
////            let animation2 = CATransform3DTranslate(animation1, 1, 1, 1)
//            iv.layer.transform = animation1
//        }
        
        //图片旋转动画
        UIView.animate(withDuration: 3, animations: {
            let animation1 = CATransform3DMakeRotation(60 * CGFloat(M_PI/180), 0, 0, -1)
            iv.layer.transform = animation1
        }) 
      
    
    }
    
    //MARK:++++++++ 2D效果的转化 针对于view承德动画
    /**
     CGAffineTransform CGAffineTransformMakeTranslation (    CGFloat tx,    CGFloat ty );
     
     CGAffineTransform CGAffineTransformTranslate (    CGAffineTransform t,    CGFloat tx,    CGFloat ty );
     
     //旋转效果
     CGAffineTransform CGAffineTransformMakeRotation (    CGFloat angle );
     
     CGAffineTransform CGAffineTransformRotate (    CGAffineTransform t,    CGFloat angle );
     
     //缩放效果
     CGAffineTransform CGAffineTransformMakeScale (    CGFloat sx,    CGFloat sy );
     
     CGAffineTransform CGAffineTransformScale (    CGAffineTransform t,    CGFloat sx,    CGFloat sy );
     
     //反转效果
     CGAffineTransform CGAffineTransformInvert (    CGAffineTransform t );
     
     //只对局部产生效果
     CGRect CGRectApplyAffineTransform (    CGRect rect,    CGAffineTransform t );
     
     //判断两个AffineTrans是否相等
     bool CGAffineTransformEqualToTransform (    CGAffineTransform t1,    CGAffineTransform t2 );
     
     //获得Affine Transform
     CGAffineTransform CGContextGetUserSpaceToDeviceSpaceTransform (    CGContextRef c );
     
     
     把二维图形的变化统一在一个坐标系里
     struct CGAffineTransform {
     CGFloat a, b, c, d;
     CGFloat tx, ty;
     };
     ad：缩放倍数 bc：旋转 tx：相对于父坐标系的x轴坐标 ty：相对于父坐标系的y轴坐标
     
     */
    func affineTransform() -> Void {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        iv.image = UIImage(named: "AppIcon60")
        iv.center = self.view.center
        self.view.addSubview(iv)
        
    
        UIView.animate(withDuration: 3, animations: {
            //平移
            _ = CGAffineTransform(translationX: 50, y: 50);
            //缩放
            let transform2 = CGAffineTransform(scaleX: 2, y: 2);
            //旋转
            _ = CGAffineTransform(rotationAngle: 90*CGFloat(M_PI)/180);
            
            let transform4 = transform2.translatedBy(x: 100, y: 100);
            let transform5 = transform4.rotated(by: 90*CGFloat(M_PI)/180);
            iv.transform = transform5
            
        }, completion: { (finish:Bool) in
            //动画完成回到原来的位置
            iv.transform = CGAffineTransform.identity
        }) 
        
        
        
        
    }
    
    
    //MARK:===== 常用的渐变动画
    
    /*
     官方文档提供的四种CATransition Type:
     NSString * const kCATransitionFade;        // 淡化
     NSString * const kCATransitionMoveIn;     // 移入
     NSString * const kCATransitionPush;        // 推入
     NSString * const kCATransitionReveal;      // 渐变移出
     ***********************************************************
     隐藏的几种CATransition Type:
     *  @"cube"                     立方体翻滚效果
     *  @"moveIn"                   新视图移到旧视图上面
     *  @"reveal"                   显露效果(将旧视图移开,显示下面的新视图)
     *  @"fade"                     交叉淡化过渡(不支持过渡方向)             (默认为此效果)
     *  @"pageCurl"                 向上翻一页
     *  @"pageUnCurl"               向下翻一页
     *  @"suckEffect"               收缩效果，类似系统最小化窗口时的神奇效果(不支持过渡方向)
     *  @"rippleEffect"             滴水效果,(不支持过渡方向)
     *  @"oglFlip"                  上下左右翻转效果
     *  @"rotate"                   旋转效果
     *  @"push"
     *  @"cameraIrisHollowOpen"     相机镜头打开效果(不支持过渡方向)
     *  @"cameraIrisHollowClose"    相机镜头关上效果(不支持过渡方向)
     
     ***********************************************************
     
     官方文档提供的四种SubType:
     NSString * const kCATransitionFromRight;
     NSString * const kCATransitionFromLeft;
     NSString * const kCATransitionFromTop;
     NSString * const kCATransitionFromBottom;
     
     *  当type为@"rotate"(旋转)的时候,它也有几个对应的subtype,分别为:
     *  90cw    逆时针旋转90°
     *  90ccw   顺时针旋转90°
     *  180cw   逆时针旋转180°
     *  180ccw  顺时针旋转180°
     */

    func planeAnimation() -> Void {
        
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        iv.image = UIImage(named: "jiangnan")
        iv.center = self.view.center
        self.view.addSubview(iv)
        //添加阴影效果
        //阴影偏移量
        iv.layer.shadowOffset = CGSize(width: 20, height: 20)
        //阴影范围
        iv.layer.shadowRadius = 10
        //阴影透明度
        iv.layer.shadowOpacity = 0.7
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 3 + 3/NSEC_PER_SEC)) {
            let  animation = CATransition()
            animation.duration = 1
            animation.repeatCount = 5
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            animation.type = "pageCurl"
            //动画的副类型。动画执行的方向。
            animation.subtype = kCATransitionFromBottom
            iv.layer.add(animation, forKey: nil)
        }
  

    }
    
    
    //MARK:========= UIView简单的动画
    func viewAnimation() -> Void {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        iv.image = UIImage(named: "jiangnan")
        iv.center = self.view.center
        self.view.addSubview(iv)
        
        UIView.beginAnimations("View", context: nil)
        UIView.setAnimationsEnabled(true)
        //延迟
        UIView.setAnimationDelay(1)
        //动画时长
        UIView.setAnimationDuration(3)
        //动画曲线
        UIView.setAnimationCurve(.easeInOut)
        //重复次数
        UIView.setAnimationRepeatCount(5)
        //设置动画块中的动画效果是否回复，回复是当动画向前播放结束後再向后重头播放
        UIView.setAnimationRepeatAutoreverses(true)
        iv.frame = CGRect(x: 0, y: 64, width: 60, height: 60)
        UIView.commitAnimations()

        //设置动画回调函数
//        UIView.setAnimationDelegate(self)/
        // UIView.setAnimationWillStartSelector(<#T##selector: Selector##Selector#>)
//        UIView.setAnimationDidStopSelector(<#T##selector: Selector##Selector#>)
        
     
    }
    
    
    //MARK:++++++++ 测试  
    func ceshi(){
        let image_line = UIImageView(frame: CGRect(x: 0, y: 64, width: 100, height: 20))
        self.view.addSubview(image_line)
        image_line.backgroundColor = UIColor.red
        
        
        let frameAnimation = CABasicAnimation(keyPath: "position.y")
        frameAnimation.duration = 3;
        frameAnimation.fromValue = -2;
        frameAnimation.toValue   =  284;
        frameAnimation.repeatCount = HUGE;
        image_line.layer.add(frameAnimation, forKey: "position.y")
//        [image_line.layer addAnimation:frameAnimation forKey:@"position.y"];
    
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
