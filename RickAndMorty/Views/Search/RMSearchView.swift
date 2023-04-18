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
}
final class RMSearchView: UIView {
    
    
    public weak var delegate: RMSearchViewDelegate?
    // MARK : - SubViews
    
    // SearchInputView
    private let searchInputView = RMSearchInputView()
    // NoResultView
    private let noResultsView = RMNoSerachResultView()
    
    // Result CollecitonView
    
    private let viewModel: RMSearchViewViewModel
    
    // MARK : - Init
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView, searchInputView)
        addConstraints()
        
        searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK : - Private
    private func addConstraints(){
        NSLayoutConstraint.activate([
            
            // Search Input
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55: 110),
            
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
}
