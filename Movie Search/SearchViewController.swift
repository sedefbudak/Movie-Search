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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        let cellNib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "MovieCell")
        searchBar.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        performSearch()
    }
    
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func performSearch() {
        search.performSearch(text: searchBar.text!, completion: {
            self.tableView.reloadData()
        })
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MovieCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! MovieCell
        let resultMovie = search.movieList[indexPath.row]
        cell.configure(for: resultMovie)
        return cell
        
    }
    
}

