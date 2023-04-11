//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/11/23.
//

import Foundation

final class RMLocationViewViewModel {
    
    private var locations: [RMLocation] = []
    
    private var cellViewModels: [String] = []
    
    private var hasMoreResults: Bool {
        return false
    }
    
    init(){}
    
    // MARK : - Public
    public func fetchLocations(){
        RMService.shared.execute(.listLocationsRequest,
                                 expecting: String.self) { result in
            switch result {
            case .success(let model):
                break
            case .failure(let failure):
                break
            }
        }
        
    }
    
}
