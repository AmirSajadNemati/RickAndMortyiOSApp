//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/5/23.
//

import UIKit

class RMEpisodeDetailViewViewModel {
    private let endpointUrl: URL?
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData() 
    }
    

    // MARK : - Private
    private func fetchEpisodeData(){
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(
            request,
            expecting: RMEpisode.self) { result in
                switch result {
                case .success(let model):
                    print(String(describing: model))
                case .failure(let failure):
                    break
            }
        }
    }
}
