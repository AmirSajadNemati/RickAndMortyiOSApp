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
    
    public func fetchAditionalCharacters(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void){
    /// Paginate if additional locations are needed

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
    
    public func fetchAditionalResults(completion: @escaping ([any Hashable]) -> Void){

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
        
        switch results {
        case .character(let existingResults):
            RMService.shared.execute(
                request,
                expecting: RMGetAllCharactersResponse.self) { [weak self] result in
                    guard let strongSelf = self else {
                        return
                    }
                    switch result {
                    case .success(let newResponse):
                        let moreResults = newResponse.results
                        let info = newResponse.info
                        strongSelf.next = info.next
                        
                        let additionalResults = moreResults.compactMap({
                            return RMCharacterCollectionViewCellViewModel(
                                characterName: $0.name,
                                characterStatus: $0.status,
                                characterImageUrl: URL(string: $0.url))
                        })
                        var newResults: [RMCharacterCollectionViewCellViewModel] = []
                        
                        newResults = existingResults + additionalResults
                        strongSelf.results = .character(newResults)
                        
                        
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
        case .episode(let existingResults):
            RMService.shared.execute(
                request,
                expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
                    guard let strongSelf = self else {
                        return
                    }
                    switch result {
                    case .success(let newResponse):
                        let moreResults = newResponse.results
                        let info = newResponse.info
                        strongSelf.next = info.next
                        
                        let additionalLocations = moreResults.compactMap({
                            return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
                        })
                        var newResults: [RMCharacterEpisodeCollectionViewCellViewModel] = []
                        
                        newResults = existingResults + additionalLocations
                        strongSelf.results = .episode(newResults)
                        
                        
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
        case .location:
            // Already Handled
            break
        }
    }
}


enum RMSearchResultType{
    case character([RMCharacterCollectionViewCellViewModel])
    case episode([RMCharacterEpisodeCollectionViewCellViewModel])
    case location([RMLocationTableViewCellViewModel])
    
}
