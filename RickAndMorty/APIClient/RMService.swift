//
//  RMService.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 2/23/23.
//

import Foundation
 

/// Primary API service object to get Rick And Morty data
final class RMService{
    
    /// Shared singleton instance
    static let shared  = RMService()
    
    
    /// Privatized constructor
    private init() {}
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback with data or error
    private func execute(_ request: RMRequest, completion: @escaping () -> Void){
        
    }
    
    
}
