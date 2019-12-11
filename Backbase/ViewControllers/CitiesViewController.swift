//
//  CitiesViewController.swift
//  Backbase
//
//  Created by Zahra Aghajani on 10/16/18.
//  Copyright © 2018 Zahra Aghajani. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController {
    
    fileprivate var cities: [CityStruct] = []
    
    fileprivate lazy var citiesTrie = {
        return dataHandler.getDataInTrie()
    }()
    
    fileprivate var cache = NSCache<NSString, NSArray>()
    
    fileprivate var isLoading = true
    fileprivate var dataHandler: DataHandlerProtocol
    
    lazy var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    lazy var searchBar = UISearchBar()
    
    init(dataHandler: DataHandlerProtocol) {
        self.dataHandler = dataHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
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

        let dest = LocationViewController(city: cities[indexPath.row])
        
        navigationController?.pushViewController(dest, animated: true)
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
        title = "Cities"
        
        [searchBar, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        tableView.accessibilityIdentifier = "tableview"
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
                
        tableView.tableFooterView = UIView(frame: .zero)
        searchBar.frame.size.height = 0
        
        tableView.register(UINib(nibName: "LoadingCell", bundle: Bundle.main   ), forCellReuseIdentifier: "loadingCell")
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: Bundle.main   ), forCellReuseIdentifier: "cityCell")
    }
}

extension CitiesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Save previous search results in cache, so search results will be ready very soon when user searchs for repeated prefixes or deletes characters. In this case, we don't need to traverse our data structure repeatedly
        if let cachedResult = cache.object(forKey: searchText as NSString) {
            cities = cachedResult as! [CityStruct]
        } else {
            cities = self.citiesTrie.findWordsWithPrefix(prefix: searchText)
            cache.setObject(self.cities as NSArray, forKey: searchText as NSString)
        }
        
        tableView.reloadData()
    }
}

