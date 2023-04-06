//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/4/23.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {

    private let viewModel: RMEpisodeDetailViewViewModel
    
    // MARK : - Init
    init(url: URL?) {
        self.viewModel = .init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemGreen

    }
    

  

}
