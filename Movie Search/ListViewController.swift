//
//  ListViewController.swift
//  Movie Search
//
//  Created by Sedef Budak on 07/06/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var moviesTableView: UITableView!
    var genre = 0
    var pageGenre = 1
    private let search = SearchByGenre()
    
    @IBOutlet weak var sortingSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults()
        if userDefaults.value(forKey: "segmentIndex") != nil {
            sortingSegmentedControl.selectedSegmentIndex = userDefaults.value(forKey: "segmentIndex") as! Int
        }
        sortingSegmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)], for: .normal)
        sortingSegmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 0.3962473869, blue: 0.4897101521, alpha: 1)], for: .selected)
        moviesTableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        createCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        performSearch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        if segue.identifier == "ShowDetailView" {
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath
            let resultMovie = search.movieListbyGenre[(indexPath.row)]
            detailViewController.movieByGenre = resultMovie
        }
    }
    
    private func createCells(){
        var cellNib = UINib(nibName: "MovieCell", bundle: nil)
        moviesTableView.register(cellNib, forCellReuseIdentifier: "MovieCell")
        cellNib = UINib(nibName: "NothingFound", bundle: nil)
        moviesTableView.register(cellNib, forCellReuseIdentifier: "NothingFound")
        cellNib = UINib(nibName: "LoadingCell", bundle: nil)
        moviesTableView.register(cellNib, forCellReuseIdentifier: "LoadingCell")
    }

    // func of sorting
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        pageGenre = 1
        performSearch()
        let userDefaults = UserDefaults()
        userDefaults.set(sortingSegmentedControl.selectedSegmentIndex, forKey: "segmentIndex")
        userDefaults.synchronize()
    }
    
    private func performSearch(){
        search.performSearchByGenre(selectedGenre: String(genre), page: pageGenre, selectedSegment: sortingSegmentedControl.selectedSegmentIndex,  completion: {
            self.moviesTableView.reloadData()
        })
    }
    
    // func of tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch search.state {
        case .noResults: return 1
        case .loading: return 1
        case .notSearchedYet: return 0
        case .resultsByGenre(let list): return list.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch search.state {
        case .noResults :
            return tableView.dequeueReusableCell(withIdentifier: "NothingFound", for: indexPath)
        case .resultsByGenre(let list):
            let cellIdentifier = "MovieCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! MovieCell
            let resultMovie = list[indexPath.row]
            cell.configureByGenre(for: resultMovie)
            if indexPath.row == list.count - 1 && pageGenre < search.totalPages{
                pageGenre += 1
                performSearch()
            }
            return cell
        case .notSearchedYet:
            fatalError("Should never get here")
        case .loading:
            return tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDetailView", sender: indexPath)
    }
}
