//
//  MovieCell.swift
//  Movie Search
//
//  Created by Efe Budak on 31/05/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!

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
        
    }

}
