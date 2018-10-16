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
    
    var cities: [CityStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.contentOffset = CGPoint(x: 0, y: 44)
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
        performSegue(withIdentifier: "showOnMapSegue", sender: cities[indexPath.row])
    }
}

extension CitiesViewController {
    fileprivate func loadData() {
        if let url = Bundle.main.url(forResource: "Cities", withExtension: "json"),
            let data = try? Data.init(contentsOf: url) {
            cities = try! JSONDecoder().decode([CityStruct].self, from: data)
        }
    }
}

extension CitiesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOnMapSegue", let city = sender as? CityStruct {
            let dest = segue.destination as! LocationViewController
            dest.coordinate = city.coord
        }
     }
}

