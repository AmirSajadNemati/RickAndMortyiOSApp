//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/6/23.
//

import UIKit

protocol RMEpisodeListViewViewModelDelgate: AnyObject {
    func didLoadInitialEpisodes()
    func didSelectEpisode(_ episode: RMEpisode) 
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
}


/// View model to handle episode list view logic
final class RMEpisodeListViewViewModel: NSObject {
    
    public weak var delegate: RMEpisodeListViewViewModelDelgate?
    
    private var isLoadingMoreEpisodes = false
    
    private let borderColors: [UIColor] = [
        .systemGreen,
        .systemBlue,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemMint,
        .systemRed,
        .systemCyan
    
    
    ]
    
    private var episodes: [RMEpisode] = [] {
        didSet{
            for episode in episodes {
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: episode.url),
                    borderColor: borderColors.randomElement() ?? .systemBlue
                )
                if !cellViewModels.contains(viewModel) {
                    
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels : [RMCharacterEpisodeCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllEpisodesResponse.RMGetAllEpisodesResponseInfo? = nil;
    
    /// Fetch initial set of episodes(20)
    func fetchAllEpisodes(){
        
        RMService.shared.execute(.listEpisodesRequest,
                                 expecting: RMGetAllEpisodesResponse.self,
                                 completion: { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                
                self?.episodes = results
                self?.apiInfo = info
                
                
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()

                }
                
            case .failure(let failure):
                print(String(describing: failure))
            }
            

        })
    }
    
    /// Paginate if additional episodes are needed
    public func fetchAditionalEpisodes(url: URL){
        
   
        guard !isLoadingMoreEpisodes else {
            return
        }
        isLoadingMoreEpisodes = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreEpisodes = false
            print("failed to make request")
            return
        }
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
                    
                    strongSelf.apiInfo = info
                    
                    let originalCount = strongSelf.episodes.count
                    let newCount = moreResults.count
                    let total = originalCount + newCount
                    let startingIndex = total - newCount
                    
                    let IndexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount) ).compactMap({
                        return IndexPath(row: $0, section: 0)
                    })
                    strongSelf.episodes.append(contentsOf: moreResults)
                    DispatchQueue.main.async {
                        strongSelf.delegate?.didLoadMoreEpisodes(with: IndexPathsToAdd)
                        strongSelf.isLoadingMoreEpisodes = false
                    }
                case .failure(let error):
                    print(String(describing: error))
                    strongSelf.isLoadingMoreEpisodes = false
                }
            }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}


// MARK : - CollectionView

extension RMEpisodeListViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 20)
        return CGSize(width: width, height: 120)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterEpisodeCollectionViewCell else {
                fatalError("Unsupported Cell")
            }
        
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter ,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        
        footer.startAnimating()
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width,
                      height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
        
        
    }
}

// MARK : - ScrollView

extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreEpisodes,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString)
        else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentView = scrollView.contentSize.height
            let totalScrollViewFixedY = scrollView.frame.size.height
            
            if offset >= (totalContentView - totalScrollViewFixedY - 120) {
                
                self?.fetchAditionalEpisodes(url: url)
            }
            t.invalidate()
        }
    }
}
