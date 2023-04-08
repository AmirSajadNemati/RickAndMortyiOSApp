//
//  RMGetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/6/23.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable {
    
    struct RMGetAllEpisodesResponseInfo: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: RMGetAllEpisodesResponseInfo
    let results: [RMEpisode]
}
