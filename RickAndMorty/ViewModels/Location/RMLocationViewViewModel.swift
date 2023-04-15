//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/11/23.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}
final class RMLocationViewViewModel {
    
    weak var delegate: RMLocationViewViewModelDelegate?
    
    private var info: RMGetAllLocationsResponse.RMGetAllLocationsResponseInfo?
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
        
    }
    
    public func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return self.locations[index]
    }
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    private var hasMoreResults: Bool {
        return false
    }
    
    init(){}
    
    // MARK : - Public
    public func fetchLocations(){
        RMService.shared.execute(.listLocationsRequest,
                                 expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.info = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()

                }
            case .failure:
                break
            }
        }
        
    }
    
}
