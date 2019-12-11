//
//  BackbaseTests.swift
//  BackbaseTests
//
//  Created by Zahra Aghajani on 10/16/18.
//  Copyright © 2018 Zahra Aghajani. All rights reserved.
//

import XCTest
@testable import Backbase

class BackbaseTests: XCTestCase {

    lazy var trie = MockDataHandler().getDataInTrie()
    
    func testCitiesCount() {
        XCTAssert(trie.words.count == 6, "Error loading cities")
    }
    
    func testFindPrefix() {
        let cities = trie.findWordsWithPrefix(prefix: "A")
        
        XCTAssert(cities.count == 4, "Error in finding algorithm")
    }
    
    func testNotFound() {
        let cities = trie.findWordsWithPrefix(prefix: "Tehrab")
        
        XCTAssert(cities.count == 0, "Error in finding algorithm")
    }
}

class MockDataHandler: DataHandlerProtocol {
    func getDataInTrie() -> Trie<CityStruct> {
        var cities: [CityStruct] = []
        let trie = Trie<CityStruct>()
        
        if let url = Bundle.main.url(forResource: "MockCities", withExtension: "json"),
            let data = try? Data(contentsOf: url) {
            cities = try! JSONDecoder().decode([CityStruct].self, from: data)
            
            cities.forEach { trie.insert(word: $0.name, data: $0) }
        }
        return trie
    }
}
