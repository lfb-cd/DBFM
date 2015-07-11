//
//  EkoButton.swift
//  DBFM
//
//  Created by lifubing on 15/7/6.
//  Copyright (c) 2015年 lifubing. All rights reserved.
//

import UIKit

class EkoButton: UIButton {
    var isPlay:Bool = true
    let imgPlay:UIImage = UIImage(named: "btnPlay")!
    let imgPause:UIImage = UIImage(named: "btnPause")!
    
    required init(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        self.addTarget(self, action: "onClick", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    func onClick(){
        isPlay = !isPlay
        if isPlay {
        
            self.setImage(imgPause, forState: UIControlState.Normal)
        }else {
            self.setImage(imgPlay, forState: UIControlState.Normal)
        }
    }
    func onPlay(){
        isPlay = true
        self.setImage(imgPause, forState: UIControlState.Normal)
    }
}
