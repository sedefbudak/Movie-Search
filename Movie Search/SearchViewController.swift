//
//  ViewController.swift
//  Movie Search
//
//  Created by Sedef Budak on 31/05/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let search = Search()
    private let searchGenre = SearchGenre()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var page = 1
    var nameGenres = [String]()
    
    @IBOutlet weak var genrePicker: UIPickerView!
    var genrePickerData : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        self.genrePicker.delegate = self
        self.genrePicker.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        createCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        genrePicker.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func createCells(){
        var cellNib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "MovieCell")
        cellNib = UINib(nibName: "NothingFound", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "NothingFound")
        cellNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "LoadingCell")
    }
    
    @IBAction func searchByGenreButton(_ sender: UIButton) {
        genrePicker.isHidden = false
        searchGenre.getGenre(completion: {
            let countOfGenres = self.searchGenre.genres.count
            for i in 0..<countOfGenres  {
                self.nameGenres.append(self.searchGenre.genres[i].name)
            }
            self.genrePickerData = self.nameGenres
            self.genrePicker.reloadAllComponents();
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        if segue.identifier == "ShowDetailView" {
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath
            let resultMovie = search.movieList[(indexPath.row)]
            detailViewController.movie = resultMovie
        }
        if segue.identifier == "ListOfMovies" {
            let listViewController = segue.destination as! ListViewController
            let row = sender as! Int
            let selectedGenre = searchGenre.genres[row].id
            let selectedGenreName = searchGenre.genres[row].name
            listViewController.genre = selectedGenre
            listViewController.navigationItem.title = "\(selectedGenreName) Movies"
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        performSearch()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func performSearch() {
        search.performSearch(text: searchBar.text!, page: page, completion: {
            self.tableView.reloadData()
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        page = 1
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
            if indexPath.row == list.count - 1 && page < search.totalPages {
                page += 1
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
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch search.state {
        case .notSearchedYet, .loading, .noResults:
            return nil
        case .results:
            return indexPath
        }
    }
}

extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func loadGenrePicker() {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genrePickerData.count
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genrePickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        performSegue(withIdentifier: "ListOfMovies", sender: row)
    }
    
}
