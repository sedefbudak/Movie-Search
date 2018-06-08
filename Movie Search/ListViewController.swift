//
//  ListViewController.swift
//  Movie Search
//
//  Created by Efe Budak on 07/06/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var moviesTableView: UITableView!
    var genre = 0
    var page = 1
    private let search = SearchByGenre()
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
      //  navigationController?.pop
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.rowHeight = 80
        var cellNib = UINib(nibName: "MovieCell", bundle: nil)
        moviesTableView.register(cellNib, forCellReuseIdentifier: "MovieCell")
        cellNib = UINib(nibName: "NothingFound", bundle: nil)
        moviesTableView.register(cellNib, forCellReuseIdentifier: "NothingFound")
        cellNib = UINib(nibName: "LoadingCell", bundle: nil)
        moviesTableView.register(cellNib, forCellReuseIdentifier: "LoadingCell")
        search.performSearchByGenre(selectedGenre: String(genre), page: page,  completion: {
            self.moviesTableView.reloadData()
        })        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
            print ("tableview list count : \(list.count)")
            if indexPath.row == list.count - 1 {
                page += 1
                search.performSearchByGenre(selectedGenre: String(genre), page: page,  completion: {
                    self.moviesTableView.reloadData()
                })
            }
            return cell
            
        case .notSearchedYet:
            fatalError("Should never get here")
        case .loading:
            return tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
