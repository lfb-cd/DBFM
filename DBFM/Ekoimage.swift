//
//  Ekoimage.swift
//  doubanFM
//
//  Created by lifubing on 15/7/5.
//  Copyright © 2015年 lifubing. All rights reserved.
//

import UIKit

class Ekoimage: UIImageView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //圆角
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        //描边
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7).CGColor
        
    }
    //旋转
    func onRotation(){
        //动画
        var animat = CABasicAnimation(keyPath:"transform.rotation")
        animat.fromValue = 0.0
        animat.toValue = M_PI * 2.0
        animat.duration = 20
        animat.repeatCount = 10000
        self.layer.addAnimation(animat, forKey: nil)
    }

}
