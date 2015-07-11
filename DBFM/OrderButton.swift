//
//  OrderButton.swift
//  DBFM
//
//  Created by lifubing on 15/7/6.
//  Copyright (c) 2015年 lifubing. All rights reserved.
//

import UIKit

class OrderButton: UIButton {
    var order:Int = 1
    
    let order1:UIImage = UIImage(named: "order1")!
    let order2:UIImage = UIImage(named: "order1")!
    let order3:UIImage = UIImage(named: "order1")!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    func onClick(sender:UIButton){
        order++
        var messege = "顺序"
        
        switch order {
        case 1 :
            messege = "顺序"
//            self.setImage(order1, forState: UIControlState.Normal)
        case 2:
            messege = "随机"

//            self.setImage(order2, forState: UIControlState.Normal)
        case 3:
            messege = "单曲"
//            self.setImage(order3, forState: UIControlState.Normal)
        default:
            order = 1
            
            
//            self.setImage(order1, forState: UIControlState.Normal)
        }
        self.setTitle(messege, forState: UIControlState.Normal)


    }

}
