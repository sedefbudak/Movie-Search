//
//  DetailViewController.swift
//  Movie Search
//
//  Created by Sedef Budak on 03/06/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    private let search = Search()
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var bigTitle: UILabel!
    @IBOutlet weak var bigDate: UILabel!
    @IBOutlet weak var bigPopularity: UILabel!
    @IBOutlet weak var bigTopic: UILabel!
    var movie : Movie!
    var movieByGenre : MovieByGenre!
    var downloadTask : URLSessionDownloadTask?
    
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        if movie != nil {
        updateUI()
        }
        else if movieByGenre != nil {
            updateUIForMovieByGenre()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateUI() {
        bigTitle.text =  "Name: \(movie.title)"
        bigDate.text = "Release date: \(String(describing: movie.releaseDate))"
        bigPopularity.text = "Popularity: \(String(movie.popularity))"
        bigTopic.text = movie.overview
        if movie.imagePath != nil {
            let imageURL = URL(string: "http://image.tmdb.org/t/p/w185//\(movie.imagePath!)")
            downloadTask = bigImageView.loadImage(url: imageURL!)
        }
    }
    
    func updateUIForMovieByGenre() {
        bigTitle.text =  "Name: \(movieByGenre.title)"
        bigDate.text = "Release date: \(String(describing: movieByGenre.releaseDate))"
        bigPopularity.text = "Popularity: \(String(movieByGenre.popularity))"
        bigTopic.text = movieByGenre.overview
        if movieByGenre.imagePath != nil {
            let imageURL = URL(string: "http://image.tmdb.org/t/p/w185//\(movieByGenre.imagePath!)")
            downloadTask = bigImageView.loadImage(url: imageURL!)
        }
    }
}
