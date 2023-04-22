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
    
    private var locationCellViewModels: [RMLocationTableViewCellViewModel] = []
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            RMLocationTableViewCell.self,
            forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.backgroundColor = .yellow
        return tableView
    }()
    
    // MARK : - Init
    override init(frame: CGRect){
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
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
        ])
    }
    
    private func processViewModel(){
        guard let viewModel = viewModel else {
            return
        }
        
        switch viewModel {
        case .character(let viewModels):
            setUpCollectionView()
        case .episode(let viewModels):
            setUpCollectionView()
        case .location(let viewModels):
            setUpTableView(viewModels: viewModels)
        }
    }
    
    private func setUpCollectionView(){
        
    }
    
    private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]){
        self.locationCellViewModels = viewModels
        tableView.delegate = self
        tableView.dataSource = self
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
