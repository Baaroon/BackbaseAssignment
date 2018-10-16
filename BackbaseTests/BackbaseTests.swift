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
    func testCitiesCount() {
        let trie = DataHandler.getDataInTrie(fileName: "MockCities")
        XCTAssert(trie.words.count == 6, "Error loading cities")
    }
    
    func testFindPrefix() {
        let trie = DataHandler.getDataInTrie(fileName: "MockCities")
        let cities = trie.findWordsWithPrefix(prefix: "A")
        
        XCTAssert(cities.count == 4, "Error in finding algorithm")
    }
    
    func testNotFound() {
        let trie = DataHandler.getDataInTrie(fileName: "MockCities")
        let cities = trie.findWordsWithPrefix(prefix: "Tehrab")
        
        XCTAssert(cities.count == 0, "Error in finding algorithm")
    }
}
