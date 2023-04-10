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
    
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet{
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    enum SectionType {
        case Info(viewModel: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels: [SectionType] = []
    // MARK : - Init
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData() 
    }
    
    // MARK : - Private
    
    private func createCellViewModels(){
        guard let dataTuple = dataTuple else {
            return
        }
    
        let episode = dataTuple.episode
        let characters = dataTuple.characters

        var createdString = ""
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created){
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
        
        cellViewModels = [
            .Info(viewModel: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString)
            ]),
            .characters(viewModel: characters.compactMap({
                return RMCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageUrl: URL(string: $0.image))
            }))
        ]
    }
    
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
    
    public func character(at index: Int) -> RMCharacter?{
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
}
