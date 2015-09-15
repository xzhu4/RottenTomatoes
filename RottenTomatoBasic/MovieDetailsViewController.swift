//
//  MovieDetailsViewController.swift
//  RottenTomatoBasic
//
//  Created by Xiuming Zhu on 9/12/15.
//  Copyright © 2015 codepath. All rights reserved.
//

import UIKit
import JTProgressHUD

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        var url = movie.valueForKeyPath("posters.thumbnail")! as! String
        let thumbImg = NSData(contentsOfURL: NSURL(string:url)!)
        
        imgView.image = UIImage(data:thumbImg!)
        
        
        
        self._delay(0.1) {
            var range = url.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
            if let range = range {
                url = url.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
            }
            let betterImgReq = NSURLRequest(URL:NSURL(string:url)!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 60)
            
            self.imgView.setImageWithURLRequest(betterImgReq, placeholderImage: UIImage(data:thumbImg!), success: { (req, res, img) -> Void in
                self.imgView.image = img
                //self.imgView.alpha = 0.3
                //UIView.animateWithDuration(1, animations: { () -> Void in self.imgView.alpha = 1})
            }, failure: {(req, res, err) -> Void in
                NSLog("Error loading high res poster")
            })
            
            self.imgView.setImageWithURL(NSURL(string: url)!)
        }
        // Do any additional setup after loading the view.
    }
    
    func _delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
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
