//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 2/25/23.
//

import Foundation

struct RMGetAllCharactersResponse: Codable {
    
    struct RMGetAllCharactersResponseInfo: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: RMGetAllCharactersResponseInfo
    let results: [RMCharacter]
}
