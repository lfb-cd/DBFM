//
//  ViewController.swift
//  DBFM
//
//  Created by lifubing on 15/7/5.
//  Copyright (c) 2015年 lifubing. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HttpProtocol,ChannelProtocol{

    @IBOutlet weak var vi: Ekoimage!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var playeTime: UILabel!
    @IBOutlet weak var progress: UIImageView!
    
    @IBOutlet weak var btnPlay: EkoButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPre: UIButton!
    
    //当前在播放第几首
    var currIndex:Int = 0
    
    @IBOutlet weak var btnOrder:OrderButton!
    
    var eHttp:HTTPController = HTTPController()
    
    var tableData:[JSON] = []
    
    var channelData:[JSON] = []
    var timer:NSTimer?
    
    var imageCache = Dictionary<String,UIImage>()
    
    var audioPlayer:MPMoviePlayerController = MPMoviePlayerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        vi.onRotation()

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        bg.addSubview(blurView)
        self.tv.delegate = self
        self.tv.dataSource = self
        //设置代理
        eHttp.delegate = self
        //获取频道
        eHttp.onSearch("http://www.douban.com/j/app/radio/channels")
        //获取频道为0的歌曲数据
        eHttp.onSearch("http://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite")
        tv.backgroundColor = UIColor.clearColor()
        
        //监听按钮
        btnPlay.addTarget(self, action: "onPlay:", forControlEvents: UIControlEvents.TouchUpInside)
        btnNext.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
        btnPre.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
        btnOrder.addTarget(self, action: "onOrder:", forControlEvents: UIControlEvents.TouchUpInside)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playFinish", name: MPMoviePlayerPlaybackDidFinishNotification, object: audioPlayer)
    }
    var isAutoFinish:Bool = true
    func playFinish(){
        println("ok")
        println(btnOrder.order)
        if isAutoFinish {

            switch btnOrder.order {
            case 1:
                //顺序播放
                currIndex++
                if currIndex > tableData.count - 1{
                    currIndex = 0
                }
                onSelectRow(currIndex)
            case 2:
                //随机
                currIndex = random() % tableData.count
                
                onSelectRow(currIndex)
                
            case 3:
                onSelectRow(currIndex)
            default:
                "default"
            }
        }else {
            isAutoFinish = true
        }
        
        
    }
    func onOrder(btn:OrderButton){
        var message:String = ""
        switch (btn.order){
        case 1:
            message = "顺序播放"
        case 2:
            message = "随机播放"
        case 3:
            message = "单曲循环"
        default:
            message = "----"
        }
        println(message)
    }
    func onClick(btn:EkoButton){
        isAutoFinish = false
        if btn == btnNext {
            currIndex++
            if currIndex > self.tableData.count - 1 {
                currIndex = 0
            }
        }else{
            currIndex--
            if currIndex < 0{
                currIndex = self.tableData.count - 1
            }
        }
        onSelectRow(currIndex)
    }

    func onPlay(btn:EkoButton){
        if btn.isPlay{
            audioPlayer.play()
        }else {
            audioPlayer.pause()
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("douban") as! UITableViewCell
        
//        cell.backgroundColor = UIColor.clearColor()
        
        let rowData:JSON = tableData[indexPath.row]
        println("JSON:::::\(rowData)")
        cell.textLabel?.text = rowData["title"].string
        cell.detailTextLabel?.text = rowData["artist"].string
//        cell.imageView?.image = rowData["title"].string
        
        let url = rowData["picture"].string
        onGetCacheImage(url!,imagView: cell.imageView!)
        
        return cell
    }
  
    
    
    
    func didRecieveResults(results:AnyObject){

        let json = JSON(results)
        
        if let channel = json["channels"].array {
            self.channelData = channel
        }else if let song = json["song"].array {
            isAutoFinish = false
            self.tableData = song
            self.tv.reloadData()
            //获取到立即设置背景
            onSelectRow(0)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var channelC:ChannelController = segue.destinationViewController as! ChannelController
        channelC.delegate = self
        channelC.channelData = self.channelData
    }
    func onChanngeChannel(channel_id:String){
        let url:String = "http://douban.fm/j/mine/playlist?type=n&channel=\(channel_id)&from=mainsite"
        eHttp.onSearch(url)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         isAutoFinish = false
        onSelectRow(indexPath.row)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //设置cell动画3d缩放
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.5, 1)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    func onSelectRow(index:Int){
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        tv.selectRowAtIndexPath(indexPath!, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        var rowData:JSON = self.tableData[index] as JSON
        let imgUrl = rowData["picture"].string
        onSetImage(imgUrl!)
        var url:String = rowData["url"].string!
        onSetAudio(url)
    }
    func onSetImage(url:String){
        onGetCacheImage(url,imagView: self.vi)
        onGetCacheImage(url,imagView: self.bg)

    }
    
    func onSetAudio(url:String){
        self.audioPlayer.stop()
        self.audioPlayer.contentURL = NSURL(string: url)
        self.audioPlayer.play()
        isAutoFinish = true
        btnPlay.onPlay()
        timer?.invalidate()
        playeTime.text = "00:00"
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "onUpdate", userInfo: nil, repeats: true)
        isAutoFinish = true
    }
    func onUpdate(){
        let c = audioPlayer.currentPlaybackTime
        if c>0.0 {
            
            let t = audioPlayer.duration
            let pro :CGFloat = CGFloat(c/t)
            progress.frame.size.width = view.frame.size.width * pro
            
            let all:Int = Int(c)
            let m:Int = all % 60
            let f:Int = Int(all / 60)
            
            var time:String = ""
            if f < 10 {
                time = "0\(f):"
            }else {
                time = "\(f):"
            }
            if m < 10 {
                time += "0\(m)"
            }else {
                time += "\(m)"
            }
            playeTime.text = time
        }
    }
    
    
    func onGetCacheImage(url:String, imagView:UIImageView){
        let image = self.imageCache[url] as UIImage?
        if image == nil {
            Alamofire.request(Method.GET,url).response({(_,_,data,_) -> Void in
                let img = UIImage(data: data! as! NSData)
                
                imagView.image = img
                self.imageCache[url] = img
            })
        }else {
            imagView.image = image!
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

