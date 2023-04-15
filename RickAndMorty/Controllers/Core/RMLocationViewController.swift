//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 2/23/23.
//

import UIKit

/// Controller to show and search locations
final class RMLocationViewController: UIViewController, RMLocationViewViewModelDelegate, RMLocationViewDelegate {

    private let locationView = RMLocationView()
    
    private let viewModel = RMLocationViewViewModel()
    
    // MARK : - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationView.delegate = self
        title = "Locations"
        view.backgroundColor = .systemBackground
        view.addSubview(locationView)
        addSearchButton()
        addConstraints()
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            
            locationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            locationView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            locationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    @objc func didTapSearch(){
        let vc = RMSearchViewController(config: .init(type: .episode))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK : - ViewModel Delegate
    func didFetchInitialLocations() {
        locationView.configure(with: viewModel)
    }
    
    // MARK : - RMLocationViewDelegate
    func rmLocationView(_ locationView: RMLocationView, didSelect Location: RMLocation) {
        let vc = RMLocationDetailViewController(location: Location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
