//
//  ViewController.swift
//  MovieGoer
//
//  Created by Zhia Chong on 10/15/16.
//  Copyright © 2016 Zhia Chong. All rights reserved.
//

import UIKit
import ALLoadingView

class MoviesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkIssueLabel: UILabel!
    
    private var movies = [[String:AnyObject]]()
    private var isMoreDataLoading = false
    private var dataPage = 1
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Now Playing"
        self.networkIssueLabel.isHidden = true
        
        ALLoadingView.manager.showLoadingView(ofType: .basic)
        ALLoadingView.manager.blurredBackground = true
        Story.fetchPosts(page: dataPage, successCallback: {(info: [[String: AnyObject]]) -> Void in
                print("SUCCESS!")
                ALLoadingView.manager.hideLoadingView(withDelay: 0.65, completionBlock: {() -> Void in
                        self.movies = info
                        self.tableView.reloadData()
                })
            }, errorCallback: {(error: NSError?) -> Void in
                ALLoadingView.manager.hideLoadingView()
                UIView.animate(withDuration: 0.65, animations: {
                    self.networkIssueLabel.isHidden = false
                })
                print ("ERRORED can't find posts!")
                
            }
        )
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 500.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesDetailTableViewCell", for: indexPath as IndexPath) as! MoviesDetailTableViewCell
        
        if let moviePhotoUrl = generateUrlForPhoto(at: indexPath) {
            cell.movieImage.setImageWith(Story.getPhotoUrl(moviePhotoUrl))
        }

        let movie = self.movies[indexPath.row]
        cell.movieTitleLabel.text = movie["original_title"] as! String?
        cell.overviewLabel.text = movie["overview"] as! String?

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MoviesDetailViewController
        let indexPath = tableView.indexPath(for: sender as! MoviesDetailTableViewCell)
        let movie = self.movies[indexPath!.row] as [String:AnyObject]
        
        if let movieOverview = movie["overview"] as! String? {
            vc.overviewText = movieOverview
        }
        if let movieTitle = movie["original_title"] as! String? {
            vc.movieTitle = movieTitle
        }
        if let releaseDate = movie["release_date"] as! String? {
            vc.releaseDate = releaseDate
        }
        if let language = movie["original_language"] as! String? {
            vc.language = language
        }
        if let popularity = movie["popularity"] as! Float? {
            vc.popularity = popularity
        }
        if let voteAverage = movie["vote_average"] as! Float? {
            vc.voteAverage = voteAverage
        }
        if let movieUrl = movie["poster_path"] as! String? {
            vc.posterBackgroundImageViewUrl = Story.getPhotoUrl(movieUrl)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Code to load more results
                ALLoadingView.manager.showLoadingView(ofType: .basic)
                ALLoadingView.manager.blurredBackground = false
                
                loadMoreData()
                ALLoadingView.manager.hideLoadingView(withDelay: 0.1, completionBlock: {()})
            }
        }
    }
    
    func loadMoreData() {
        dataPage += 1
        
        Story.fetchPosts(page: dataPage, successCallback: {(info: [[String: AnyObject]]) -> Void in
            print("SUCCESS!")
            self.movies += info
            self.tableView.reloadData()
            self.isMoreDataLoading = false
            self.networkIssueLabel.isHidden = true
            }, errorCallback: {(error: NSError?) -> Void in
                print ("ERRORED!")
                self.isMoreDataLoading = true
                UIView.animate(withDuration: 0.65, animations: {
                    self.networkIssueLabel.isHidden = false
                })
            }
        )
    }
    

    /**
    * PRIVATE METHODS
    */
    func generateUrlForPhoto(at: IndexPath) -> String? {
        
        if let photoUrl = self.movies[at.row]["poster_path"] as? String {
            return photoUrl
        }
        
        return nil
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        if (!isMoreDataLoading) {
            isMoreDataLoading = true
            ALLoadingView.manager.showLoadingView(ofType: .basic)
            ALLoadingView.manager.blurredBackground = false
            
            self.dataPage = 1
            loadMoreData()
            ALLoadingView.manager.hideLoadingView(withDelay: 0.65, completionBlock: {()})
        }
        
        refreshControl.endRefreshing()
        self.isMoreDataLoading = false
    }

}

