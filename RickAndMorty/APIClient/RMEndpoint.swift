//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 2/23/23.
//

import Foundation

/// Represents unique API endpoinnt
@frozen enum RMEndpoint: String{
    /// Endpoint to get character info
    case character 
    /// Endpoint to get location info
    case location
    /// Endpoint to get episode info
    case episode
}
