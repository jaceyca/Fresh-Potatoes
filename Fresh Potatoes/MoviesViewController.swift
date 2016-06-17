//
//  MoviesViewController.swift
//  Fresh Potatoes
//
//  Created by Jessica Choi on 6/15/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        searchBar.sizeToFit()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        //        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        //        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        //        let request = NSURLRequest(
        //            URL: url!,
        //            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
        //            timeoutInterval: 10)
        //
        //        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //
        //        let session = NSURLSession(
        //            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
        //            delegate: nil,
        //            delegateQueue: NSOperationQueue.mainQueue()
        //
        //
        //        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
        //            if let data = dataOrNil {
        //                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
        //                    data, options:[]) as? NSDictionary {
        //                    print("response: \(responseDictionary)")
        //                    self.movies = responseDictionary["results"] as! [NSDictionary]
        //                    self.tableView.reloadData()
        //
        //                }
        //            }
        //
        //            MBProgressHUD.hideHUDForView(self.view, animated: true)
        //            }
        //        )
        //        task.resume()
        //
        
        refreshControlAction(refreshControl)
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let filteredData = filteredData{
            return filteredData.count
        }
        else{
            return 0
        }
    }
    
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String
        {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            let imageRequest = NSURLRequest(URL: imageUrl!)
            
            cell.posterView.setImageWithURLRequest(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            cell.posterView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.posterView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
            
            cell.posterView.setImageWithURL(imageUrl!)
        }
        cell.overviewLabel.text = overview
        cell.titleLabel.text = title
        
        print ("row \(indexPath.row)")
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        filteredData = movies!.filter({(moviesItem: NSDictionary) -> Bool in
            if (moviesItem["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            {
                return true
            }
            else
            {
                return false
            }
        })
        tableView.reloadData()
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        NSLog("end of cancel")
        filteredData = movies
        tableView.reloadData()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        
        // Configure session so that completion handler is executed on main UI thread
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
            )
            
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? NSDictionary {
                    print("response: \(responseDictionary)")
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.filteredData = self.movies
                    self.tableView.reloadData()
                    
                }
            }
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            }
        )
        task.resume()
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        
        detailViewController.movie = movie
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
