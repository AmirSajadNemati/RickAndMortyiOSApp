//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/7/23.
//

import UIKit

/// Configurable controller to search
final class RMSearchViewController: UIViewController {

    struct Config {
        enum `Type` {
            case character
            case episode
            case location
        }
        let type: `Type`
    }
    
    private let config: Config
    
    // MARK : - Init
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
   
    }
    

   

}
