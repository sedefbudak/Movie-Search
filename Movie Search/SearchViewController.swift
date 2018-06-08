//
//  ViewController.swift
//  Movie Search
//
//  Created by Sedef Budak on 31/05/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    private let search = Search()
    private let searchGenre = SearchGenre()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var page = 1
    var nameGenres = [String]()
    
    @IBOutlet weak var genrePicker: UIPickerView!
    var genrePickerData : [String] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.genrePicker.delegate = self
        self.genrePicker.dataSource = self
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    // func of picker
    
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
    
    // func of search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        performSearch()
    }
    
    // func of error
    func showNetworkError(){
        let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the Movie Database. Please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated:true, completion: nil)
    }
    
    /*
     // funcs of load and save movie list
     func documentsDirectory() -> URL {
     let paths = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
     return paths[0]
     }
     
     func dataFilePath() -> URL {
     return documentsDirectory().appendingPathComponent("Movie Search.plist")
     }
     
     func saveMovies() {
     let encoder = PropertyListEncoder()
     do {
     let data = try encoder.encode(search.movieList)
     try data.write(to: dataFilePath(),options: Data.WritingOptions.atomic)
     } catch {
     print("Error encoding item array!")
     }
     } */
}

extension SearchViewController: UISearchBarDelegate {
    
    
    func performSearch() {
        search.performSearch(text: searchBar.text!, page: page, completion: {
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
            print ("tableview list count : \(list.count)")
            if indexPath.row == list.count - 1 {
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
