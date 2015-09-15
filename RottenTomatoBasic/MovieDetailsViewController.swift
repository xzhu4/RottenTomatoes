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
        JTProgressHUD.show()
        
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        var url = movie.valueForKeyPath("posters.thumbnail")! as! String
        
        var range = url.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            url = url.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        imgView.setImageWithURL(NSURL(string: url)!)
        JTProgressHUD.hide()    
        // Do any additional setup after loading the view.
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
