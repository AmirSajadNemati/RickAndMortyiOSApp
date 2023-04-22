//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/16/23.
//

import UIKit
protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(
        _ rmSearchView: RMSearchView,
        didSelect option: RMSearchInputViewViewModel.DynamicOptions
    )
    func rmSearchView(
        _ rmSearchView: RMSearchView,
        didTapLocation location: RMLocation
    )
}
final class RMSearchView: UIView {
    
    
    public weak var delegate: RMSearchViewDelegate?
    // MARK : - SubViews
    
    // SearchInputView
    private let searchInputView = RMSearchInputView()
    // NoResultView
    private let noResultsView = RMNoSerachResultView()
    
    // Result CollecitonView
    private let resultsView = RMSearchResultsView()

    
    private let viewModel: RMSearchViewViewModel
    
    // MARK : - Init
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(resultsView, noResultsView, searchInputView)
        addConstraints()
        
        searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        
        resultsView.delegate = self
        setUpHandlers(viewModel: viewModel)
        
        
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK : - Private
    private func setUpHandlers(viewModel: RMSearchViewViewModel){
        
        viewModel.registerMapUpdateBlock { [weak self] tuple in
            self?.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        
        viewModel.registerSearchResultHandler {[weak self] results in
            DispatchQueue.main.async { 
                self?.resultsView.configure(with: results)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }
        
        viewModel.registerNoResultHandler{ [weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            
            // Search Input
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55: 110),
            
            // Results View
            resultsView.leftAnchor.constraint(equalTo: leftAnchor),
            resultsView.rightAnchor.constraint(equalTo: rightAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            
            
            // No Result
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    // MARK : - Public
    public func showKeyboard(){
        searchInputView.showKeyboard()
    }
    
    
    
}

// MARK : - CollectionView
extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK : - RMSearchInputViewDelegate
extension RMSearchView: RMSearchInputViewDelegate {

    func rmSearchInputView(_ rmSearchInputView: RMSearchInputView, didSelect option: RMSearchInputViewViewModel.DynamicOptions) {
        delegate?.rmSearchView(
            self,
            didSelect: option
        )
    }
    
    func rmSearchInputView(_ rmSearchInputView: RMSearchInputView, didChangeSearchtext text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputViewDidTapSearchKeyboard(_ rmSearchInputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
    
}

// MARK : - RMSearchResultsViewDelegate
extension RMSearchView: RMSearchResultsViewDelegate {
    func rmSearchResultView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int) {
        guard let locationModel = viewModel.locationSearchResult(at: index) else {
            return
        }
        delegate?.rmSearchView(self, didTapLocation: locationModel)
    }
}
