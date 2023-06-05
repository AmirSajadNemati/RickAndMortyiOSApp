//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/21/23.
//

import UIKit

protocol RMSearchResultsViewDelegate: AnyObject {
    func rmSearchResultView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)
}

/// Shows search results UI( table or collectin as desired)
final class RMSearchResultsView: UIView {

    weak var delegate: RMSearchResultsViewDelegate?
    private var viewModel: RMSearchResultViewModel?{
        didSet{
            self.processViewModel()
        }
    }
    /// TableView Models
    private var locationCellViewModels: [RMLocationTableViewCellViewModel] = []
    
    /// CollectionView Models
    private var collectionViewCellViewModels: [any Hashable] = []
    // TableView
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            RMLocationTableViewCell.self,
            forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    // CollectionView
    private let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom:10, right: 10)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Cell for character
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        // Cell for episode
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter ,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
    
    // MARK : - Init
    override init(frame: CGRect){
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView, collectionView)
        
        addConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    // MARK : - Private
    private func addConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func processViewModel(){
        guard let viewModel = viewModel else {
            return
        }
        
        switch viewModel.results {
        case .character(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
        case .episode(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
        case .location(let viewModels):
            setUpTableView(viewModels: viewModels)
        }
    }
    
    private func setUpCollectionView(){
       collectionView.delegate = self
       collectionView.dataSource = self
        tableView.isHidden = true
        UIView.animate(withDuration: 0.3){
            self.collectionView.isHidden = false
        }
        collectionView.reloadData()
    }
    
    private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]){
        self.locationCellViewModels = viewModels
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.isHidden = true
        tableView.reloadData()
        UIView.animate(withDuration: 0.3){
            self.tableView.isHidden = false
        }
    }
    
    
    // MARK : - Publoc
    public func configure(with viewModel: RMSearchResultViewModel){
        self.viewModel = viewModel
    }
}

// MARK : - TableView
extension RMSearchResultsView: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RMLocationTableViewCell.cellIdentifier,
            for: indexPath
        ) as? RMLocationTableViewCell else {
            fatalError("Failed tp dequeue RMLocationTableViewCell")
        }
        cell.confgiure(with: locationCellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.rmSearchResultView(self, didTapLocationAt: indexPath.row)
        
    }
   
    
    
}

// MARK : - CollectionView
extension RMSearchResultsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Character || Episode
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        if let CharacterVM = currentViewModel as? RMCharacterCollectionViewCellViewModel {
            // Character cell
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: CharacterVM)
            return cell
        }
        // Episode cell
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError()
        }
        if let episodeVM = currentViewModel as?  RMCharacterEpisodeCollectionViewCellViewModel {
            cell.configure(with: episodeVM)
        }
        return cell
    }
    
    // Configuring Spinner for collectionView Pagination
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
        guard let viewModel = self.viewModel,
              viewModel.shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width,
                      height: 100)
    }
    
    // Select Cell Logic
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle cell tab
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        let bounds = UIScreen.main.bounds

        if currentViewModel is RMCharacterCollectionViewCellViewModel {
            let width = (bounds.width - 30) / 2
            return CGSize(width: width, height: width * 1.5)
        }
        // Episode
        let width = bounds.width - 20
        return CGSize(width: width, height: 120)

    }
}

// MARK : - ScrollView

extension RMSearchResultsView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !locationCellViewModels.isEmpty {
            handleLocationPagination(scrollView: scrollView)
        } else {
            // CollectionView
            handleCharacterOrEpisodePagination(scrollView: scrollView)
        }
    }
    private func handleCharacterOrEpisodePagination(scrollView: UIScrollView){
        guard let viewModel = viewModel,
              !collectionViewCellViewModels.isEmpty,
              !viewModel.isLoadingMoreResults,
              viewModel.shouldShowLoadMoreIndicator
        else {
            return
        }

        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentView = scrollView.contentSize.height
            let totalScrollViewFixedY = scrollView.frame.size.height

            if offset >= (totalContentView - totalScrollViewFixedY - 120) {
                
                self?.viewModel?.fetchAditionalResults(completion: { [weak self] newResults in
                    guard let strongSelf = self else {
                        return
                    }
                    DispatchQueue.main.async {
                        strongSelf.tableView.tableFooterView = nil

                        let originalCount = strongSelf.collectionViewCellViewModels.count
                        let newCount = (newResults.count - originalCount)
                        let total = originalCount + newCount
                        let startingIndex = total - newCount
                        let IndexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount) ).compactMap({
                            return IndexPath(row: $0, section: 0)
                        })
    
                        strongSelf.collectionViewCellViewModels = newResults
                        strongSelf.collectionView.insertItems(at: IndexPathsToAdd)
                    }
                    print("\(newResults.count) items")
                })
            }
            t.invalidate()
        }

    }
    
    private func handleLocationPagination(scrollView: UIScrollView){
        guard let viewModel = viewModel,
              !locationCellViewModels.isEmpty,
              !viewModel.isLoadingMoreResults,
              viewModel.shouldShowLoadMoreIndicator
        else {
            return
        }

        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentView = scrollView.contentSize.height
            let totalScrollViewFixedY = scrollView.frame.size.height

            if offset >= (totalContentView - totalScrollViewFixedY - 120) {
                DispatchQueue.main.async {
                    self?.showLoadingIndicator()
                }
                self?.viewModel?.fetchAditionalCharacters(completion: { [weak self] newResults in
                    self?.tableView.tableFooterView = nil
                    self?.locationCellViewModels = newResults
                    self?.tableView.reloadData()
                })
            }
            t.invalidate()
        }
    }
        

    private func showLoadingIndicator() {
        let footer = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.self.width, height: 100))
        tableView.tableFooterView = footer
    }
}
