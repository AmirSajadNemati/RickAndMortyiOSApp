//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/21/23.
//

import Foundation

final class RMSearchResultViewModel{
    public private(set) var results: RMSearchResultType
    private var next: String?
    
    // MARK : - Init
    init(results: RMSearchResultType, next: String?){
        self.results = results
        self.next = next
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    public private(set) var isLoadingMoreResults = false
    
    /// Paginate if additional locations are needed
    public func fetchAditionalCharacters(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void){

        guard !isLoadingMoreResults else {
            return
        }
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreResults = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
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
                    strongSelf.next = info.next
                    
                    let additionalLocations = moreResults.compactMap({
                        return RMLocationTableViewCellViewModel(location: $0)
                    })
                    var newResults: [RMLocationTableViewCellViewModel] = []
                    switch strongSelf.results {
                    case .location(let existingResults):
                        newResults = existingResults + additionalLocations
                        strongSelf.results = .location(newResults)
                    case .character, .episode:
                        break
                    }
                    
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        
                        //Notify via callback
                        completion(newResults)
                       // strongSelf.didFinishPagination?()
                    }
                case .failure(let error):
                    print(String(describing: error))
                    strongSelf.isLoadingMoreResults = false
                }
            }
    }
}

enum RMSearchResultType{
    case character([RMCharacterCollectionViewCellViewModel])
    case episode([RMCharacterEpisodeCollectionViewCellViewModel])
    case location([RMLocationTableViewCellViewModel])
    
}
