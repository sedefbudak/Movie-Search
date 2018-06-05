//
//  MovieCell.swift
//  Movie Search
//
//  Created by Sedef Budak on 31/05/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    var downloadTask : URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(for result: Movie) {
        
        nameLabel.text = result.title
        rateLabel.text = String(result.popularity)
        if result.imagePath != nil {
            artworkImageView.image = UIImage(named: "Placeholder")
            let imageURL = URL(string: "http://image.tmdb.org/t/p/w185//\(result.imagePath!)")
            downloadTask = artworkImageView.loadImage(url: imageURL!)
        }
    }
}

