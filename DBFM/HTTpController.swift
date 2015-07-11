//
//  HTTpController.swift
//  doubanFM
//
//  Created by lifubing on 15/7/5.
//  Copyright © 2015年 lifubing. All rights reserved.
//

import UIKit


class HTTPController:NSObject {
    var delegate:HttpProtocol?
    
    func onSearch(url:String){
        Alamofire.request(Method.GET,url).responseJSON(options: NSJSONReadingOptions.MutableContainers){
            (_,_,data,error) -> Void in
            self.delegate?.didRecieveResults(data!)
        }
    }
    
}
protocol HttpProtocol {
    func didRecieveResults(results:AnyObject)
}