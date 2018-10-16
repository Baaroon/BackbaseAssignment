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
    
    fileprivate var cities: [CityStruct] = []
    
    fileprivate lazy var citiesTrie = {
        return DataHandler.getDataInTrie(fileName: "Cities")
    }()
    
    fileprivate var cache = NSCache<NSString, NSArray>()
    
    fileprivate var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
}

extension CitiesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 1 : cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading { return getLoadingCell() }
        return getCityCell(for: cities[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: "showOnMapSegue", sender: cities[indexPath.row])
    }
}

extension CitiesViewController {
    fileprivate func getLoadingCell() -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "loadingCell")!
    }
    
    fileprivate func getCityCell(for city: CityStruct) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")!
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.country
        return cell
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
        DispatchQueue.global(qos: .userInitiated).async {
            self.cities = self.citiesTrie.words.sorted { $0.name <= $1.name && $0.country <= $0.country }
            self.isLoading = false
            self.cache.setObject(self.cities as NSArray, forKey: "")
            DispatchQueue.main.async {
                self.searchBar.frame.size.height = 44
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func setupUI() {
        tableView.tableFooterView = UIView(frame: .zero)
        searchBar.frame.size.height = 0
    }
}

extension CitiesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let cachedResult = cache.object(forKey: searchText as NSString) {
            cities = cachedResult as! [CityStruct]
        } else {
            cities = self.citiesTrie.findWordsWithPrefix(prefix: searchText)
            cache.setObject(self.cities as NSArray, forKey: searchText as NSString)
        }
        tableView.reloadData()
    }
}

