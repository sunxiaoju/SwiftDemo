//
//  AnimationViewController.swift
//  常用|基类-swift
//
//  Created by chedao on 16/7/25.
//  Copyright © 2016年 chedao. All rights reserved.
//

import UIKit

class AnimationCell: UICollectionViewCell {
    
    var  textLabel:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel = UILabel(frame: self.bounds)
        textLabel?.textColor = UIColor.white
        textLabel?.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(textLabel!)
        
    }
    override func draw(_ rect: CGRect) {
        self.contentView.layer.contentsScale = 5
        self.contentView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class AnimationViewController: SunBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var collectionView:UICollectionView?
    var dataArr = ["雷达效果","点连接的线路","3D特效","2D特效","渐变动画","view简单动画","测试"]
    override func viewDidLoad() {
        super.viewDidLoad()

        let flawOut = UICollectionViewFlowLayout()
        flawOut.itemSize = CGSize(width: 80, height: 50)
        flawOut.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64), collectionViewLayout: flawOut)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.view.addSubview(collectionView!)
        collectionView?.register(AnimationCell.self, forCellWithReuseIdentifier: "cell")
        
     
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AnimationCell
        cell.textLabel?.text = dataArr[(indexPath as NSIndexPath).item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            let showVC = ShowAnimationViewController()
            showVC.type = (indexPath as NSIndexPath).item
            self.navigationController?.pushViewController(showVC, animated:  true)
        
        
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
