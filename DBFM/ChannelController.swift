//
//  ChannelController.swift
//  DBFM
//
//  Created by lifubing on 15/7/5.
//  Copyright (c) 2015年 lifubing. All rights reserved.
//

import UIKit

protocol ChannelProtocol{
    func onChanngeChannel(channel_id:String)
}

class ChannelController: UIViewController,UITableViewDelegate {

    @IBOutlet weak var tv: UITableView!
    
    @IBAction func backbtn(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    var delegate:ChannelProtocol?
    var channelData:[JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0.85
    
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("channel") as! UITableViewCell
        let rowData:JSON = self.channelData[indexPath.row] as JSON
        cell.textLabel?.text = rowData["name"].string
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowData:JSON = self.channelData[indexPath.row]
        let channel_id:String = rowData["channel_id"].stringValue
        
        delegate?.onChanngeChannel(channel_id)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //设置cell动画3d缩放
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
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
