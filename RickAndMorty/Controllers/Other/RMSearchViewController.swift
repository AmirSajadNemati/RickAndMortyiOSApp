//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/7/23.
//

import UIKit

// Dynamic search option view
// Render results
// Render no results view
// Searching / API CAll
/// Configurable controller to search
final class RMSearchViewController: UIViewController {
    
    
    /// Configuration for search session
    struct Config {
        enum `Type` {
            case character // name | status | gender
            case episode // name
            case location // name | Type
            
            var displayTitle: String {
                switch self {
                case .character:
                    return "Characters"
                case.episode:
                    return "Episodes"
                case .location:
                    return "Locations"
                    
                }
            }
        }
        let type: `Type`
    }
    private let searchView: RMSearchView
    private let viewModel: RMSearchViewViewModel
    // MARK : - Init
    init(config: Config) {
        let viewModel = RMSearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK : - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Searching \(viewModel.config.type.displayTitle)"
        addSearchButton()
        view.addSubviews(searchView)
        addConstraints()
   
    }
    
    // MARK : - Private
    private func addConstraints(){
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapExecuteSearch))
    }
    
    @objc func didTapExecuteSearch(){
        
    }
   

}
