//
//  CitiesViewControllerUITests.swift
//  BackbaseTests
//
//  Created by Zahra on 12/10/19.
//  Copyright © 2019 Zahra Aghajani. All rights reserved.
//
@testable import Backbase
import XCTest

class CitiesViewControllerUITests: XCTestCase {
    func testLoadData() {
        let mock = MockDataHandler()
        let vc = CitiesViewController(dataHandler: mock)
        
        UIApplication.shared.windows.first?.rootViewController = vc
        let delayExpectation = expectation(description: "Waiting for document to be saved")

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            XCTAssertTrue(vc.tableView.numberOfRows(inSection: 0) == 6)
            delayExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTapCell() {
        let mock = MockDataHandler()
        let vc = CitiesViewController(dataHandler: mock)
        let nv = UINavigationController.init(rootViewController: vc)
        UIApplication.shared.windows.first?.rootViewController = nv
        let delayExpectation = expectation(description: "Waiting for document to be saved")

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            XCTAssertTrue(vc.tableView.numberOfRows(inSection: 0) == 6)
            vc.tableView(vc.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                XCTAssertTrue(UIApplication.shared.windows.first?.rootViewController?.children.last?.title == "Alabama")
                delayExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
