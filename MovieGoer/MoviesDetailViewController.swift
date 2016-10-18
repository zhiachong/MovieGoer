//
//  MoviesDetailViewController.swift
//  MovieGoer
//
//  Created by Zhia Chong on 10/15/16.
//  Copyright © 2016 Zhia Chong. All rights reserved.
//

import UIKit
import ALLoadingView

class MoviesDetailViewController: UIViewController {
    
    var posterBackgroundImageViewUrl: URL!
    var movieTitle: String!
    var overviewText: String!
    var releaseDate: String!
    var language: String!
    var popularity: Float!
    var voteAverage: Float!
    
    @IBOutlet weak var posterBackgroundView: UIImageView!
    @IBOutlet weak var movieDescriptionScrollView: UIScrollView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var moviePopularityLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieDateReleasedLabel: UILabel!
    @IBOutlet weak var movieLanguageLabel: UILabel!
    @IBOutlet weak var overview: UIView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Movie Details"

        // Setup initial information
        setupView()
        
        // Do any additional setup after loading the view.
        self.posterBackgroundView.contentMode = .scaleAspectFill
        self.posterBackgroundView.alpha = 0.0
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
                self.posterBackgroundView.alpha = 1.0
        })
        
        // Set up title information
        let offSet:CGFloat = 10
        let originalOverviewLabelHeight = self.movieOverviewLabel.frame.height
        self.movieOverviewLabel.sizeToFit()
        let resizedOverviewLabelHeight = self.movieOverviewLabel.frame.height
        let extraHeight = (resizedOverviewLabelHeight - originalOverviewLabelHeight + offSet)
        let resizedOverviewHeight = overview.frame.height + extraHeight
        
        let contentWidth = movieDescriptionScrollView.bounds.width
        let contentHeight = movieDescriptionScrollView.bounds.height
        movieDescriptionScrollView.frame = CGRect(x: movieDescriptionScrollView.frame.origin.x, y: movieDescriptionScrollView.frame.origin.y, width: contentWidth, height: contentHeight + extraHeight)
        movieDescriptionScrollView.contentSize = CGSize(width: contentWidth, height: movieDescriptionScrollView.frame.height + extraHeight + 100)
        overview.frame = CGRect(x: overview.frame.origin.x, y: overview.frame.origin.y, width: contentWidth, height: resizedOverviewHeight)
        overview.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.65)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        self.movieTitleLabel.text = self.movieTitle
        self.movieOverviewLabel.text = self.overviewText
        self.movieDateReleasedLabel.text = self.releaseDate
        let locale = NSLocale(localeIdentifier: self.language)
        self.movieLanguageLabel.text = locale.displayName(forKey: NSLocale.Key.identifier, value: self.language)
        self.moviePopularityLabel.text = String(self.popularity)
        self.movieRatingLabel.text = String(self.voteAverage)
        self.posterBackgroundView.setImageWith(self.posterBackgroundImageViewUrl)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
