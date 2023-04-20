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
    
    private var searchResultHandler: (() -> Void)?
    
    private var searchText = ""
    // MARK : - Init
    init(config: RMSearchViewController.Config){
        self.config = config
        
        
    }
    
    // MARK : - Public
    public func registerSearchResultHandler(_ block: @escaping () -> Void){
        self.searchResultHandler = block
    }
    public func executeSearch(){
        // Test Searhc text
        print("searchtext: \(searchText)")
        
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
        print(request.url?.absoluteURL)
        
        RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { result in
            switch result {
            case .success(let model):
                print("search result found: \(model.results.count) ")
            case .failure:
                break
            }
        }
    
    
    }
    
//    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest){
//        RMService.shared.execute(request, expecting: type) { result in
//            switch result {
//            case .success(let model):
//                print("search result found: \(model)")
//            case .failure:
//                break
//            }
//        }
//    }
    
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
    
}
