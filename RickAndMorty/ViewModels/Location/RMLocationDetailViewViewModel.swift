//
//  RMLocationDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/15/23.
//

import UIKit

protocol RMLocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class RMLocationDetailViewViewModel {

    private let endpointUrl: URL?
    
    private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {
        didSet{
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }
    enum SectionType {
        case Info(viewModel: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate: RMLocationDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels: [SectionType] = []
    // MARK : - Init
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchLocationData()
    }
    
    // MARK : - Private
    
    private func createCellViewModels(){
        guard let dataTuple = dataTuple else {
            return
        }
    
        let location = dataTuple.location
        let characters = dataTuple.characters

        var createdString = ""
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created){
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
        
        cellViewModels = [
            .Info(viewModel: [
                .init(title: "Location name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
                .init(title: "Created", value: createdString)
            ]),
            .characters(viewModel: characters.compactMap({
                return RMCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageUrl: URL(string: $0.image))
            }))
        ]
    }
    
    private func fetchRelatedCharacters(location: RMLocation){
        let rmRequests: [RMRequest] = location.residents.compactMap({
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
            location,
            characters
            )
        }
     
    }
    
    // MARK : - Public
    
    
    /// fetch backing Location model
    public func fetchLocationData(){
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(
            request,
            expecting: RMLocation.self) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.fetchRelatedCharacters(location: model)
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
