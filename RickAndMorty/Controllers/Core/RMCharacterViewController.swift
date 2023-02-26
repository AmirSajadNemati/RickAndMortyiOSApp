//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 2/23/23.
//

import UIKit

/// Controller to show and search characters
final class RMCharacterViewController: UIViewController {

    
    private let characterListView = RMCharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Characters"
        view.backgroundColor = .systemBackground
        view.addSubview(characterListView)
        
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        
            
        }
        
    }


