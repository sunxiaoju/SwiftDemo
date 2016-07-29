//
//  SunCameraViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/7/27.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

class SunCameraViewController: SunBaseViewController,UIGestureRecognizerDelegate,AVCaptureFileOutputRecordingDelegate {

    /** 是否需要保存到相册 */
    var savePhotos:Bool = false
    
    /** 设置焦距 */
    var effectiveScale:CGFloat = 1.0
    var beginScale:CGFloat = 1.0
    
    //捕获设备 设置前置摄像头、后置摄像头、麦克风
    var device:AVCaptureDevice?
    
    //输入设备
    lazy var input:AVCaptureDeviceInput = {
        return try! AVCaptureDeviceInput(device: self.device)
    }()
    
    //输出图片
    lazy var imageOutput:AVCaptureStillImageOutput = {
        return AVCaptureStillImageOutput()
    }()
    
    //与输入输出结合开启摄像头
    lazy var session:AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPreset640x480
        
        //输入输出设备的结合
        if session.canAddInput(self.input){
            session.addInput(self.input)
        }
        if session.canAddOutput(self.imageOutput){
            session.addOutput(self.imageOutput)
        }
        return session
    }()
    
    //图像预览层，试试显示捕捉图像
    lazy var previewLayer:AVCaptureVideoPreviewLayer = {
        
        let perLayer = AVCaptureVideoPreviewLayer(session: self.session)
        perLayer.frame = CGRectMake(10,70,300,300)
        perLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(perLayer)
        return perLayer
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .None
        if canUserCamera() == false || self.device == nil{
            return
        }
        
        
        self.device = createWithPosition(.Back)
        self.session.startRunning()
        self.previewLayer.frame = CGRectMake(0, 49, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64 - 100)
        makeTools()
        let btn = UIButton()
        btn.frame = CGRectMake(0, 0, 60, 60)
        btn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 64 - 50)
        btn.backgroundColor = UIColor.redColor()
        btn.addTarget(self, action: #selector(SunCameraViewController.getCameraPhoto), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SunCameraViewController.tapClick(_:))))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(SunCameraViewController.pinchClick(_:)))
        pinch.delegate = self
        self.view.addGestureRecognizer(pinch)
        
    }
    
    //MARK:=====检查相机权限
    func canUserCamera() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        if authStatus == AVAuthorizationStatus.Denied || authStatus == AVAuthorizationStatus.Restricted {
            return false
        }
        return true
    }
    
    
    
    func makeTools() -> Void {
        
      let toobar = UIToolbar(frame: CGRectMake(0,0,SCREEN_WIDTH,49))
    self.view.addSubview(toobar)
    
        let btnBar = UIBarButtonItem(title: "录像", style: .Plain, target: self, action: #selector(SunCameraViewController.startVideoRecorder))
          let stopBar = UIBarButtonItem(title: "停止录像", style: .Plain, target: self, action: #selector(SunCameraViewController.stopVideoRecorder))
        let changeBtn = UIBarButtonItem(title: "切换", style: .Plain, target: self, action: #selector(SunCameraViewController.changeCamera))
        let flashBtn = UIBarButtonItem(title: "闪光灯", style: .Plain, target: self, action: #selector(SunCameraViewController.setFlash))
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        toobar.items = [btnBar,space,stopBar,space,flashBtn,space,changeBtn]
    
    }
    //MARK:+++++++创建设备
    func createWithPosition(position:AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for item in devices {
            if (item as! AVCaptureDevice).position == position {
                return item as? AVCaptureDevice
            }
        }
        return nil
    }
    
    //MARK:获取拍照的手机
    func getCameraPhoto(){
    
        let conntion = self.imageOutput.connectionWithMediaType(AVMediaTypeVideo)
        if conntion == nil {
            print("拍照失败")
            return
        }
        
        self.imageOutput.captureStillImageAsynchronouslyFromConnection(conntion) { (imageDatasamplebuffer, error) in
            if imageDatasamplebuffer == nil{
                print(error ,"拍照失败")
                return
            }
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDatasamplebuffer)
            let image = UIImage(data: imageData)
            self.session.stopRunning()
            
            
            
            print(image)
            let iv = UIImageView(frame: self.view.bounds)
            iv.image = image
            self.view.addSubview(iv)
            self.savePhotos = true
            self.saveImageToPhotos(image!)
            
        }
    }
    
    //MARK:=====将图片保存到相册
    func saveImageToPhotos(image:UIImage) -> Void {
        if savePhotos == false {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(SunCameraViewController.image(_:error:contextInfo:)), nil)
    }

    //保存图片之后指定返回的参数必须为这3个
    func image(image:UIImage,error:NSError?,contextInfo:AnyObject)->Void{
        if error == nil {
            print("保存成功")
        }else{
            print("你保存失败",error)
        }
        print(error,image)
        
    
    }
    
    //MARK:=====切换摄像头
    func changeCamera() -> Void {
        
        let cameraCount = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).count
        if cameraCount > 1 {
            let animation = CATransition()
            animation.duration = 0.5
            animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            animation.type = "oglFlip"
            var newDevice:AVCaptureDevice? = nil
            let position = self.input.device.position
            
            if position == AVCaptureDevicePosition.Front {
                newDevice = createWithPosition(.Back)
                animation.subtype = kCATransitionFromLeft
            }else{
                newDevice = createWithPosition(.Front)
                animation.subtype = kCATransitionFromRight
            }
            if newDevice == nil {
                return
            }
            let newInput = try? AVCaptureDeviceInput(device: newDevice!)
            
            self.previewLayer.addAnimation(animation, forKey: nil)
            
            if newInput != nil {
             
                self.session.beginConfiguration()
                self.session.removeInput(self.input)
                if self.session.canAddInput(newInput) {
                    self.session.addInput(newInput)
                    self.input = newInput!
                }else{
                    self.session.addInput(self.input)
                }
                self.session.commitConfiguration()
            }else{
            
                print("切换失败")
            }
        }
    }
    
    //MARK:=========控制闪光灯的开关
    func setFlash() -> Void {
        if self.input.device.position == .Back {
            if self.device?.flashMode == AVCaptureFlashMode.Off {
                changeFlash(AVCaptureFlashMode.On)
            }else if self.device?.flashMode == AVCaptureFlashMode.On{
                changeFlash(.Off)
            }
        }else{
        
            print("前置摄像头不支持闪光灯")
        }
      
    }
    
    func changeFlash(flashMode:AVCaptureFlashMode) -> Void {
        
       try! self.device?.lockForConfiguration()
        
        if self.device?.hasFlash == true {
            self.device?.flashMode = flashMode
        }else{
            print("该设备不支持闪光灯")
        }
        self.device?.unlockForConfiguration()
    }
    
    //MARK:===== 曝光于对焦
    func tapClick(tap:UITapGestureRecognizer) -> Void {
        focusAtPoint(tap.locationInView(tap.view))
    }
    
    func focusAtPoint(point:CGPoint) -> Void {
       
        let size = self.previewLayer.frame.size
        let focusPoint = CGPointMake(point.y/size.height, 1-point.x/size.width)
        
        try! self.device?.lockForConfiguration()
        
        //对焦模式和对焦头
        if self.device!.isFocusModeSupported(.AutoFocus){
            self.device!.focusPointOfInterest = focusPoint
            self.device?.focusMode = .AutoFocus
        }
        
        //曝光模式和曝光点
        if self.device!.isExposureModeSupported(.AutoExpose) {
            self.device?.exposurePointOfInterest = focusPoint
            self.device?.exposureMode = .AutoExpose
        }
        self.device?.unlockForConfiguration()
//        //设置对焦动画
//        _focusView.center = point;
//        _focusView.hidden = NO;
//        [UIView animateWithDuration:0.3 animations:^{
//            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
//            }completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.5 animations:^{
//            _focusView.transform = CGAffineTransformIdentity;
//            } completion:^(BOOL finished) {
//            _focusView.hidden = YES;
//            }];
//            }];
    }
    
    //MARK:===== 缩放手势调整焦距
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKindOfClass(UIPinchGestureRecognizer.classForCoder()) {
            self.beginScale = self.effectiveScale
        }
        return true
    }
    
    func pinchClick(pinch:UIPinchGestureRecognizer)->Void{
    
        var alltouchesOnPreviewLayer:Bool = true
        let numstouches = pinch.numberOfTouches()
        for i in 0..<numstouches {
            let location = pinch.locationOfTouch(i, inView: self.view)
            let convertedLocation = self.previewLayer.convertPoint(location, fromLayer: self.previewLayer.superlayer)
            if self.previewLayer.containsPoint(convertedLocation) == false {
                
                alltouchesOnPreviewLayer = false
                break
            }
            
        }
        
        print(pinch.scale)
        if alltouchesOnPreviewLayer {
            
            self.effectiveScale = self.beginScale * pinch.scale
            if self.effectiveScale < 1.0 {
                self.effectiveScale = 1.0
            }
            
            let maxScale = self.imageOutput.connectionWithMediaType(AVMediaTypeVideo).videoMaxScaleAndCropFactor
            if self.effectiveScale > maxScale {
                self.effectiveScale = maxScale
            }
            
            UIView.animateWithDuration(0.025, animations: { 
                self.previewLayer.setAffineTransform(CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale))
            })
        }
        
    
    }
    
    
    //MARK:自定义录制视频
    
    /** 视频输入 */
    lazy var vedioInput:AVCaptureDeviceInput = {
        return try! AVCaptureDeviceInput(device: self.device)
    }()
    
    /** 声音输入 */
    lazy var audioInput:AVCaptureDeviceInput = {
        return try! AVCaptureDeviceInput(device: AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio))
    
    }()
    
//    /** 视频流输出 */
    lazy var movieOutput:AVCaptureMovieFileOutput = {
        return AVCaptureMovieFileOutput()
    }()
    
    //判断用户是否允许访问麦克风权限
    func canUserAudio() -> Bool {
        
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeAudio)
        if status == AVAuthorizationStatus.Restricted || status == AVAuthorizationStatus.Denied {
            return false
        }
        return true
    }
    
    
    func vedios() -> Void {
        
        if canUserAudio() == false {
            return
        }
        self.session.removeInput(self.input)
        self.session.removeOutput(self.imageOutput)
        if self.session.canAddInput(self.vedioInput){
            self.session.addInput(self.vedioInput)
        }
        if self.session.canAddInput(self.audioInput) {
            self.session.addInput(self.audioInput)
        }
        if self.session.canAddOutput(self.movieOutput){
            self.session.addOutput(self.movieOutput)
        }
        
    }
    
    //开始录制视频
    func startVideoRecorder() -> Void {
        vedios()
        let moviceCon = self.movieOutput.connectionWithMediaType(AVMediaTypeVideo)
        let avcaptureOrientation = AVCaptureVideoOrientation.Portrait
        moviceCon.videoOrientation = avcaptureOrientation
        moviceCon.videoScaleAndCropFactor = 1.0
        let  path = NSHomeDirectory().stringByAppendingString("/Documents/video.mp4")
        if self.movieOutput.recording == false {
            self.movieOutput.startRecordingToOutputFileURL(NSURL(fileURLWithPath: path), recordingDelegate: self)
        }
        
    }
    //停止录制
    func stopVideoRecorder() -> Void {
        if self.movieOutput.recording {
            self.movieOutput.stopRecording()
        }
        
        
    }
    //代理方法
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        //判断最小时间
        if CMTimeGetSeconds(captureOutput.recordedDuration) < 1.0 {
            
            print("录制时间过短")
            return
        }
        
        print(outputFileURL,CMTimeGetSeconds(captureOutput.recordedDuration),captureOutput.recordedFileSize / 1024)

        //保存到相册中
        UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.absoluteString, self, #selector(SunCameraViewController.video(_:error:contextInfo:)), nil)

////        //保存到相册中
//        ALAssetsLibrary().writeVideoAtPathToSavedPhotosAlbum(outputFileURL) { (assetUrl, error) in
//            if error == nil{
//                print("保存成功")
//            }
//        }
    }
    
    
    func video(videoPath:String,error:NSError?,contextInfo:AnyObject?) -> Void {
        if error == nil{
            print("保存成功")
        }
    }
    //获取视频截图
    
    func getVideoSnap(path:String) -> UIImage {
        let asset = AVAsset(URL: NSURL(fileURLWithPath: path))
        
        let generator = AVAssetImageGenerator(asset: asset)
        let snaptime = CMTimeMake(10,10)
        /** 这个方法第一个时间是指的图片创建的时间， 第二个actualTime 是指向图片正式生成时间的指针，实际生成时间这个参数可以传NULL，如果你不关心它是什么时候诞生的。 但是第一个时间不能传入空，必须告诉它你要在哪一个时间点生成一张截图 */
        let ImageRef = try! generator.copyCGImageAtTime(snaptime, actualTime: nil)
     
        return UIImage(CGImage: ImageRef)
     }

}
    