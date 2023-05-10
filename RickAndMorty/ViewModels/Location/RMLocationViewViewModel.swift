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
    
    public var isLoadingMoreLocations = false
    
    public var shouldShowLoadMoreIndicator: Bool {
        return info?.next != nil
    }
    
    public var didFinishPagination: (() -> Void)?
    
    
    // MARK : - Init
    init(){}
    
    // MARK : - Public
    
    public func registerDidFinishPagination(_ block: @escaping () -> Void ){
        self.didFinishPagination = block
    }
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
    
    /// Paginate if additional locations are needed
    public func fetchAditionalCharacters(){

        guard !isLoadingMoreLocations else {
            return
        }
        guard let nextUrlString = info?.next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreLocations = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreLocations = false
            print("failed to make request")
            return
        }
        RMService.shared.execute(
            request,
            expecting: RMGetAllLocationsResponse.self) { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let newResponse):
                    let moreResults = newResponse.results
                    let info = newResponse.info
                    print(moreResults.count)
                    strongSelf.info = info
                    strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({
                        return RMLocationTableViewCellViewModel(location: $0)
                    }))
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreLocations = false
                        strongSelf.didFinishPagination?()
                    }
                case .failure(let error):
                    print(String(describing: error))
                    strongSelf.isLoadingMoreLocations = false
                }
            }
    }
    
    
    
}
