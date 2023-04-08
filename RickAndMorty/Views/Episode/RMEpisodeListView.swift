//
//  RMEpisodeListView.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/6/23.
//

import UIKit


protocol RMEpisodeListViewDelegate: AnyObject {
    func rmEpisodeListView(
        _ episodeListView: RMEpisodeListView,
        didSelectEpisode episode: RMEpisode)
}

/// View that handles showing list of episodes, loader, etc.
class RMEpisodeListView: UIView {

    public weak var delegate: RMEpisodeListViewDelegate?

    
    private let viewModel = RMEpisodeListViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom:10, right: 10)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alpha = 0
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter ,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
    
    // MARK : - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(collectionView, spinner)
    
        addConstraints()
        
        spinner.startAnimating()
        viewModel.fetchAllEpisodes()
        viewModel.delegate = self
        setUpCollectionView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo:rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpCollectionView(){
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        
        
    }


}


extension RMEpisodeListView: RMEpisodeListViewViewModelDelgate {
    
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPaths)
        }
    }
    
    func didSelectEpisode(_ episode: RMEpisode) {
        delegate?.rmEpisodeListView(self,didSelectEpisode: episode)
    }
    
    func didLoadInitialEpisodes() {
        collectionView.reloadData() // Initial fetch
        self.spinner.stopAnimating()
        self.collectionView.isHidden = false
        UIView.animate(withDuration: 0.4){
            self.collectionView.alpha = 1

        }
    }
}
