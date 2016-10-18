//
//  MoviesDetailTableViewCell.swift
//  MovieGoer
//
//  Created by Zhia Chong on 10/15/16.
//  Copyright © 2016 Zhia Chong. All rights reserved.
//

import UIKit

class MoviesDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
