//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/16/23.
//

import UIKit

final class RMSearchViewViewModel{
    
    public let config: RMSearchViewController.Config
    
    private var optionMap: [RMSearchInputViewViewModel.DynamicOptions: String] = [:]
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOptions, String)) -> Void)?
    
    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?
    
    private var noResultHandler: (() -> Void)?
    
    private var searchResultModels: Codable?

    private var searchText = ""
    // MARK : - Init
    init(config: RMSearchViewController.Config){
        self.config = config
        
        
    }
    
    // MARK : - Public
    public func registerNoResultHandler(_ block: @escaping () -> Void){
        self.noResultHandler = block
    }
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void){
        self.searchResultHandler = block
    }
    public func executeSearch(){
        
        // Build Arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        
        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({_, element in
            let key: RMSearchInputViewViewModel.DynamicOptions = element.key
            let value: String = element.value
            
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        
        // Create request
        let request = RMRequest(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )
        
        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        case . location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
            
        }
       
    
    
    }
    
    public func set(query text: String){
        self.searchText = text
    }
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOptions){
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerMapUpdateBlock(
        _ block: @escaping ((RMSearchInputViewViewModel.DynamicOptions, String)) -> Void
    ){
        self.optionMapUpdateBlock = block
    }
    
    public func locationSearchResult(at index: Int) -> RMLocation? {
        guard let searchModel = searchResultModels as? RMGetAllLocationsResponse else {
            return nil
        }
        return searchModel.results[index]
    }
    // MARK : - Private
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest){
        RMService.shared.execute(request, expecting: type) {[weak self] result in
            switch result {
            case .success(let model):
                self?.processSearchResults(model: model)
            case .failure:
                self?.handleNoResults()
            }
        }
    }
    
    private func processSearchResults(model: Codable){
        var resultVM: RMSearchResultViewModel?
        if let characterResults = model as? RMGetAllCharactersResponse {
            resultVM = .character(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.url))
            }))
        }
        else if let episodesResults = model as? RMGetAllEpisodesResponse {
            resultVM = .episode(episodesResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            }))
        }
        else if let locationsResults = model as? RMGetAllLocationsResponse {
            resultVM = .location(locationsResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
        }
        
        if let results = resultVM {
            self.searchResultModels = model
            self.searchResultHandler?(results)
            
        } else {
            // fallback error
            
            handleNoResults()
        }
    }
    
    private func handleNoResults(){
        
        noResultHandler?()
    }
    
    
    
}
