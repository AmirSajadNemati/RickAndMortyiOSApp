//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 3/29/23.
//

import UIKit

protocol RMEpisodeDataRender {
    var name: String {get}
    var air_date: String {get}
    var episode: String {get}
    
}
final class RMCharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable {
    
    private let episodeDataUrl: URL?
    public let borderColor : UIColor
    private var isFetching = false
    private var dataBlock: ((RMEpisodeDataRender) -> Void )?
    
    private var episode : RMEpisode? {
        didSet {
            guard let model = episode else {
                return
            }
            dataBlock?(model)
        }
    
    }

    // MARK : - Init
    init(episodeDataUrl: URL?, borderColor: UIColor = .systemBlue){
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
    }
    
    // MARK : - Public
    public func registerForData(_ block: @escaping(RMEpisodeDataRender) -> Void ){
        self.dataBlock = block
    }
    public func fetchEpisode(){
        
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        
        guard let url = episodeDataUrl,
              let rmRequest = RMRequest(url: url) else {
            return
        }
        
        isFetching = true
                
        RMService.shared.execute(rmRequest,expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK : - Hasher
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    
    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel, rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
