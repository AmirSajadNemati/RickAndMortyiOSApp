//
//  RMCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 2/26/23.
//

import Foundation
import UIKit


protocol RMCharacterListViewViewModelDelgate: AnyObject {
    func didLoadInitialCharacters()
    func didSelectCharacter(_ character: RMCharacter)
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
}


/// View model to handle character list view logic
final class RMCharacterListViewViewModel: NSObject{
    
    public weak var delegate: RMCharacterListViewViewModelDelgate?
    
    private var isLoadingMoreCharacters = false
    
    private var characters: [RMCharacter] = [] {
        didSet{
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
                if !cellViewModels.contains(viewModel) {
                    
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels : [RMCharacterCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllCharactersResponse.RMGetAllCharactersResponseInfo? = nil;
    /// Fetch initial set of characters(20)
    func fetchAllCharacters(){
        
        RMService.shared.execute(.listCharactersRequest,
                                 expecting: RMGetAllCharactersResponse.self,
                                 completion: { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                
                self?.characters = results
                self?.apiInfo = info
                
                
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()

                }
                
            case .failure(let failure):
                print(String(describing: failure))
            }
            

        })
    }
    
    
    /// Paginate if additional characters are needed
    public func fetchAditionalCharacters(url: URL){
        
   
        guard !isLoadingMoreCharacters else {
            return
        }
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            print("failed to make request")
            return
        }
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
                    
                    strongSelf.apiInfo = info
                    
                    let originalCount = strongSelf.characters.count
                    let newCount = moreResults.count
                    let total = originalCount + newCount
                    let startingIndex = total - newCount
                    
                    let IndexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount) ).compactMap({
                        return IndexPath(row: $0, section: 0)
                    })
                    strongSelf.characters.append(contentsOf: moreResults)
                    DispatchQueue.main.async {
                        strongSelf.delegate?.didLoadMoreCharacters(with: IndexPathsToAdd)
                        strongSelf.isLoadingMoreCharacters = false
                    }
                case .failure(let error):
                    print(String(describing: error))
                    strongSelf.isLoadingMoreCharacters = false
                }
            }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

// MARK : - CollectionView

extension RMCharacterListViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let bounds = UIScreen.main.bounds
        let width: CGFloat
        if UIDevice.isiPhone {
            width = (bounds.width - 30) / 2
        } else {
            width = (bounds.width - 50) / 4
        }
        return CGSize(width: width, height: width * 1.5)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
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
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}


// MARK : - ScrollView

extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //print(isLoadingMoreCharacters)
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
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
                
                self?.fetchAditionalCharacters(url: url)
            }
            t.invalidate()
        }
    }
}
