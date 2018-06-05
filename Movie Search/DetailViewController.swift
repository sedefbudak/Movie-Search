//
//  DetailViewController.swift
//  Movie Search
//
//  Created by Sedef Budak on 03/06/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var bigTitle: UILabel!
    @IBOutlet weak var bigDate: UILabel!
    @IBOutlet weak var bigPopularity: UILabel!
    @IBOutlet weak var bigTopic: UILabel!
    var movie : Movie!
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        bigTitle.text = "Name: \(movie.title)"
        bigDate.text = "Release date: \(movie.year)"
        bigPopularity.text = "Popularity: \(String(movie.popularity))"
        bigTopic.text = movie.overview
        if movie.imagePath != nil {
            let imageURL = URL(string: "http://image.tmdb.org/t/p/w185//\(movie.imagePath!)")
            downloadTask = bigImageView.loadImage(url: imageURL!)
        }
    }

}
