//
//  RMGetAllLocationsResponse.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/15/23.
//

import Foundation

struct RMGetAllLocationsResponse: Codable {
    
    struct RMGetAllLocationsResponseInfo: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: RMGetAllLocationsResponseInfo
    let results: [RMLocation]
}
