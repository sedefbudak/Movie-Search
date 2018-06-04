//
//  ViewController.swift
//  Movie Search
//
//  Created by Efe Budak on 31/05/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let search = Search()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortingSegmentedControl: UISegmentedControl!

    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        performSearch()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        var cellNib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "MovieCell")
        cellNib = UINib(nibName: "NothingFound", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "NothingFound")
        cellNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "LoadingCell")
        searchBar.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        if segue.identifier == "ShowDetailView" {
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath
            let resultMovie = search.movieList[indexPath.row]
            detailViewController.movie = resultMovie
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        performSearch()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func showNetworkError(){
        let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the Movie Database. Please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated:true, completion: nil)
    }
    
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func performSearch() {
        search.performSearch(text: searchBar.text!, selectedSegment: sortingSegmentedControl.selectedSegmentIndex, completion: {
            self.tableView.reloadData()
        })
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch search.state {
        case .noResults: return 1
        case .loading: return 1
        case .notSearchedYet: return 0
        case .results(let list): return list.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch search.state {
        case .noResults :
            return tableView.dequeueReusableCell(withIdentifier: "NothingFound", for: indexPath)
        case .results(let list):
            let cellIdentifier = "MovieCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! MovieCell
            let resultMovie = list[indexPath.row]
            cell.configure(for: resultMovie)
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

