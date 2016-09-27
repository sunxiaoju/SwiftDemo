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
    var iv:UIImageView?
    
    lazy var fouceView:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "focus-crosshair"))
        iv.frame = CGRect(x: 0, y: 0, width: 73, height: 73)
        iv.isHidden = true
        return iv
    }()
    
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
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
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
        perLayer?.frame = CGRect(x: 10,y: 70,width: 300,height: 300)
        perLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(perLayer!)
        return perLayer!
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge()
        self.device = createWithPosition(.back)
    
        if canUserCamera() == false || self.device == nil{
            return
        }
        try! self.device?.lockForConfiguration()
        self.device?.flashMode = .auto
        self.device?.unlockForConfiguration()
        
        self.session.startRunning()
        self.previewLayer.frame = CGRect(x: 0, y: 49, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 49 - 64 - 100)
         iv = UIImageView(frame: CGRect(x: 0, y: 49, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 49 - 64 - 100))
        iv!.image = UIImage(named: "grid")
        iv!.alpha = 0.6
        self.view.addSubview(iv!)
        makeTools()
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        btn.center = CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT - 64 - 50)
        btn.backgroundColor = UIColor.red
        btn.setBackgroundImage(UIImage(named: "take-snap"), for: UIControlState())
        btn.addTarget(self, action: #selector(SunCameraViewController.getCameraPhoto), for: .touchUpInside)
        self.view.addSubview(btn)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SunCameraViewController.tapClick(_:))))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(SunCameraViewController.pinchClick(_:)))
        pinch.delegate = self
        self.view.addGestureRecognizer(pinch)
        
    }
    
    //MARK:=====检查相机权限
    func canUserCamera() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted {
            return false
        }
        return true
    }
    
    
    
    func makeTools() -> Void {
        
      let toolbar = UIToolbar(frame: CGRect(x: 0,y: 0,width: SCREEN_WIDTH,height: 49))
        toolbar.backgroundColor = UIColor.black
        self.view.addSubview(toolbar)
    
        let flashB = UIButton(type: .custom)
        flashB.setImage(UIImage(named: "flash-auto"), for: UIControlState())
        flashB.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        flashB.addTarget(self, action: #selector(SunCameraViewController.setFlash(_:)), for: .touchUpInside)
        let flashBtn = UIBarButtonItem(customView: flashB)
        
        
        
//        let  
        let btnBar = UIBarButtonItem(title: "录像", style: .plain, target: self, action: #selector(SunCameraViewController.startVideoRecorder))
          let stopBar = UIBarButtonItem(title: "停止录像", style: .plain, target: self, action: #selector(SunCameraViewController.stopVideoRecorder))
        let changeBtn = UIBarButtonItem(image: UIImage(named: "front-camera"), style: .plain, target: self, action:  #selector(SunCameraViewController.changeCamera))
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [flashBtn,space,btnBar,space,stopBar,space,changeBtn]
    
    }
    //MARK:+++++++创建设备
    func createWithPosition(_ position:AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for item in devices! {
            if (item as! AVCaptureDevice).position == position {
                return item as? AVCaptureDevice
            }
        }
        return nil
    }
    
    //MARK:获取拍照的手机
    func getCameraPhoto(){
    
        let conntion = self.imageOutput.connection(withMediaType: AVMediaTypeVideo)
        if conntion == nil {
            print("拍照失败")
            return
        }
        conntion?.videoOrientation = .portrait
        self.imageOutput.captureStillImageAsynchronously(from: conntion) { (imageDatasamplebuffer, error) in
            if imageDatasamplebuffer == nil{
                print(error ,"拍照失败")
                return
            }
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDatasamplebuffer)
            let image = UIImage(data: imageData!)
            self.session.stopRunning()
            
            print(image)
//            let iv = UIImageView(frame: self.view.bounds)
//            iv.image = image
//            self.view.addSubview(iv)
//            self.savePhotos = true
//            self.saveImageToPhotos(image!)
            self.iv?.image = image
        }
    }
    
    //MARK:=====将图片保存到相册
    func saveImageToPhotos(_ image:UIImage) -> Void {
        if savePhotos == false {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(SunCameraViewController.image(_:error:contextInfo:)), nil)
    }

    //保存图片之后指定返回的参数必须为这3个
    func image(_ image:UIImage,error:NSError?,contextInfo:AnyObject)->Void{
        if error == nil {
            print("保存成功")
        }else{
            print("你保存失败",error)
        }
        print(error,image)
        
    
    }
    
    //MARK:=====切换摄像头
    func changeCamera() -> Void {
        
        let cameraCount = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count
        if cameraCount > 1 {
            let animation = CATransition()
            animation.duration = 0.5
            animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            animation.type = "oglFlip"
            var newDevice:AVCaptureDevice? = nil
            let position = self.input.device.position
            
            if position == AVCaptureDevicePosition.front {
                newDevice = createWithPosition(.back)
                animation.subtype = kCATransitionFromLeft
            }else{
                newDevice = createWithPosition(.front)
                animation.subtype = kCATransitionFromRight
            }
            if newDevice == nil {
                return
            }
            let newInput = try? AVCaptureDeviceInput(device: newDevice!)
            
            self.previewLayer.add(animation, forKey: nil)
            
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
    func setFlash(_ btn:UIButton) -> Void {
        if self.input.device.position == .back {
            if self.device?.flashMode == AVCaptureFlashMode.off {
                changeFlash(AVCaptureFlashMode.on)
                btn.setImage(UIImage(named: "flash-on"),for: UIControlState())
            }else if self.device?.flashMode == AVCaptureFlashMode.on{
                changeFlash(.off)
                btn.setImage(UIImage(named: "flash-off"),for: UIControlState())
            }
        }else{
        
            print("前置摄像头不支持闪光灯")
        }
      
    }
    
    func changeFlash(_ flashMode:AVCaptureFlashMode) -> Void {
        
       try! self.device?.lockForConfiguration()
        
        if self.device?.hasFlash == true {
            self.device?.flashMode = flashMode
  
        }else{
            print("该设备不支持闪光灯")
        }
        self.device?.unlockForConfiguration()
    }
    
    //MARK:===== 曝光于对焦
    func tapClick(_ tap:UITapGestureRecognizer) -> Void {
        focusAtPoint(tap.location(in: tap.view))
    }
    
    func focusAtPoint(_ point:CGPoint) -> Void {
       
        let size = self.previewLayer.frame.size
        let focusPoint = CGPoint(x: point.y/size.height, y: 1-point.x/size.width)
        
        try! self.device?.lockForConfiguration()
        
        //对焦模式和对焦头
        if self.device!.isFocusModeSupported(.autoFocus){
            self.device!.focusPointOfInterest = focusPoint
            self.device?.focusMode = .autoFocus
        }
        
        //曝光模式和曝光点
        if self.device!.isExposureModeSupported(.autoExpose) {
            self.device?.exposurePointOfInterest = focusPoint
            self.device?.exposureMode = .autoExpose
        }
        self.device?.unlockForConfiguration()
//        //设置对焦动画
        fouceView.center = point;
        fouceView.isHidden = false;
        UIView.animate(withDuration: 0.3, animations: {
            self.fouceView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25);
            
        }, completion: { (finish) in
            UIView.animate(withDuration: 0.3, animations: {
                self.fouceView.transform = CGAffineTransform.identity;
                
            }, completion: { (finish) in
                self.fouceView.isHidden = true
            }) 
        }) 
     
    }
    
    //MARK:===== 缩放手势调整焦距
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPinchGestureRecognizer.classForCoder()) {
            self.beginScale = self.effectiveScale
        }
        return true
    }
    
    func pinchClick(_ pinch:UIPinchGestureRecognizer)->Void{
    
        var alltouchesOnPreviewLayer:Bool = true
        let numstouches = pinch.numberOfTouches
        for i in 0..<numstouches {
            let location = pinch.location(ofTouch: i, in: self.view)
            let convertedLocation = self.previewLayer.convert(location, from: self.previewLayer.superlayer)
            if self.previewLayer.contains(convertedLocation) == false {
                
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
            
            let maxScale = self.imageOutput.connection(withMediaType: AVMediaTypeVideo).videoMaxScaleAndCropFactor
            if self.effectiveScale > maxScale {
                self.effectiveScale = maxScale
            }
            
            UIView.animate(withDuration: 0.025, animations: { 
                self.previewLayer.setAffineTransform(CGAffineTransform(scaleX: self.effectiveScale, y: self.effectiveScale))
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
        return try! AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio))
    
    }()
    
//    /** 视频流输出 */
    lazy var movieOutput:AVCaptureMovieFileOutput = {
        return AVCaptureMovieFileOutput()
    }()
    
    //判断用户是否允许访问麦克风权限
    func canUserAudio() -> Bool {
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
        if status == AVAuthorizationStatus.restricted || status == AVAuthorizationStatus.denied {
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
        let moviceCon = self.movieOutput.connection(withMediaType: AVMediaTypeVideo)
        let avcaptureOrientation = AVCaptureVideoOrientation.portrait
        moviceCon?.videoOrientation = avcaptureOrientation
        moviceCon?.videoScaleAndCropFactor = 1.0
        let  path = NSHomeDirectory() + "/Documents/video.mp4"
        if self.movieOutput.isRecording == false {
            self.movieOutput.startRecording(toOutputFileURL: URL(fileURLWithPath: path), recordingDelegate: self)
        }
        
    }
    //停止录制
    func stopVideoRecorder() -> Void {
        if self.movieOutput.isRecording {
            self.movieOutput.stopRecording()
        }
        
        
    }
    //代理方法
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
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
    
    
    func video(_ videoPath:String,error:NSError?,contextInfo:AnyObject?) -> Void {
        if error == nil{
            print("保存成功")
        }
    }
    //获取视频截图
    
    func getVideoSnap(_ path:String) -> UIImage {
        let asset = AVAsset(url: URL(fileURLWithPath: path))
        
        let generator = AVAssetImageGenerator(asset: asset)
        let snaptime = CMTimeMake(10,10)
        /** 这个方法第一个时间是指的图片创建的时间， 第二个actualTime 是指向图片正式生成时间的指针，实际生成时间这个参数可以传NULL，如果你不关心它是什么时候诞生的。 但是第一个时间不能传入空，必须告诉它你要在哪一个时间点生成一张截图 */
        let ImageRef = try! generator.copyCGImage(at: snaptime, actualTime: nil)
     
        return UIImage(cgImage: ImageRef)
     }

}
    
