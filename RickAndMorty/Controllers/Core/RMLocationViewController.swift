//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 2/23/23.
//

import UIKit

/// Controller to show and search locations
final class RMLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Locations"
        view.backgroundColor = .systemBackground
        addSearchButton()
    }
    
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc func didTapSearch(){
        let vc = RMSearchViewController(config: .init(type: .episode))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    
}
