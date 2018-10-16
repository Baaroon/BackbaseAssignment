//
//  DataHandler.swift
//  Backbase
//
//  Created by Zahra Aghajani on 10/16/18.
//  Copyright © 2018 Zahra Aghajani. All rights reserved.
//

import Foundation

class DataHandler {
    
    class func getDataInTrie() -> Trie<CityStruct> {
        var cities: [CityStruct] = []
        let trie = Trie<CityStruct>()
        
        if let url = Bundle.main.url(forResource: "Cities", withExtension: "json"),
            let data = try? Data.init(contentsOf: url) {
            cities = try! JSONDecoder().decode([CityStruct].self, from: data)
            cities.sort { $0.name <= $1.name && $0.country <= $0.country }
            
            cities.forEach { trie.insert(word: $0.name, data: $0) }
        }
        return trie
    }
    
    
}
