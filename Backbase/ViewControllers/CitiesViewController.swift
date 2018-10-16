//
//  CitiesViewController.swift
//  Backbase
//
//  Created by Zahra Aghajani on 10/16/18.
//  Copyright © 2018 Zahra Aghajani. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cities: [CityStruct] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var citiesTrie = {
        return DataHandler.getDataInTrie(fileName: "Cities")
    }()
    
    var cache = NSCache<NSString, NSArray>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.contentOffset = CGPoint(x: 0, y: 44)
    }
}

extension CitiesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")!
        let city = cities[indexPath.row]
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: "showOnMapSegue", sender: cities[indexPath.row])
    }
}

extension CitiesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOnMapSegue", let city = sender as? CityStruct {
            let dest = segue.destination as! LocationViewController
            dest.city = city
        }
    }
}

extension CitiesViewController {
    fileprivate func loadData() {
        cities = citiesTrie.words.sorted { $0.name <= $1.name && $0.country <= $0.country }
        cache.setObject(cities as NSArray, forKey: "")
    }
}

extension CitiesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let cachedResult = cache.object(forKey: searchText as NSString) {
            cities = cachedResult as! [CityStruct]
        } else {
            cities = citiesTrie.findWordsWithPrefix(prefix: searchText)
            cache.setObject(cities as NSArray, forKey: searchText as NSString)
        }
    }
}

