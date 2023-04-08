//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/5/23.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel {

    private let endpointUrl: URL?
    
    private var dataTuple: (RMEpisode, [RMCharacter])? {
        didSet{
            delegate?.didFetchEpisodeDetails()
        }
    }
    enum SectionType {
        case Info(viewModel: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    public private(set) var sections: [SectionType] = []
    // MARK : - Init
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData() 
    }
    
    // MARK : - Private
    private func fetchRelatedCharacters(episode: RMEpisode){
        let rmRequests: [RMRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
        var characters: [RMCharacter ] = []
        let group = DispatchGroup()
        
        // Loop through requests
        for request in rmRequests {
            group.enter()
            defer {
                group.leave()
            }
            // Refetch each character and appending it
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (
            episode,
            characters
            )
        }
     
    }
    
    // MARK : - Public
    
    
    /// fetch backing episode model
    public func fetchEpisodeData(){
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(
            request,
            expecting: RMEpisode.self) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.fetchRelatedCharacters(episode: model)
                case .failure:
                    break
            }
        }
    }
}
