//
//  Model.swift
//  Backbase
//
//  Created by Zahra Aghajani on 10/16/18.
//  Copyright © 2018 Zahra Aghajani. All rights reserved.
//

import Foundation

struct CityStruct: Codable {
    let country: String
    let name: String
    let id: Int
    let coord: CoordinateStruct
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case country, name, coord
    }
}

struct CoordinateStruct: Codable {
    let lat: Double
    let lon: Double
}
