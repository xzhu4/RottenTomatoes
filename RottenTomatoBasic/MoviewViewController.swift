//
//  MoviewViewController.swift
//  RottenTomatoBasic
//
//  Created by Xiuming Zhu on 9/12/15.
//  Copyright © 2015 codepath. All rights reserved.
//

import UIKit
import JTProgressHUD

class MoviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var naviTitle: UINavigationItem!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var refreshControl: UIRefreshControl!

    
    var cached_strs = ["https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json","https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json"]
    var cache_index = 0
    
    var movies: [NSDictionary]?
    var errorMsg: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JTProgressHUD.show()
        tableView.dataSource = self
        tableView.delegate = self
        _fetch_show_movies()
        _add_refresh()
        
    }
    
    func _show_error_msg() {
        self.errorLabel.text = " !Network Error! "
        self.errorLabel.hidden = false
    }
    
    func _add_refresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "_refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
    }
    
    func _refresh() {
         _fetch_show_movies()
         self.refreshControl.endRefreshing()
    }
    
    func _fetch_show_movies() {

        var url_str = cached_strs[cache_index]
        let url = NSURL(string: url_str)!
        // Do any additional setup after loading the view.
        let request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if  error != nil {
                self._show_error_msg()
                return
                
            } else {
                self.errorLabel.hidden = true
                self.naviTitle.title = "Movies"
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options:[]) as! NSDictionary
                
                self.movies = json["movies"] as! [NSDictionary]
                self.movies?.shuffle()
                self.tableView.reloadData()
            }
        }
        JTProgressHUD.hide()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 2.0, *)
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        else {
            return 0
        }
        
    }
    
    // Row display. Imple menters should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath:indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        let url = NSURL(string:movie.valueForKeyPath("posters.thumbnail") as! String)!
        cell.posterView.setImageWithURL(url)
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:false)

    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }


    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexpath = tableView.indexPathForCell(cell)!
        
        let movie = movies![indexpath.row]
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
     
        
    }


}


extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
