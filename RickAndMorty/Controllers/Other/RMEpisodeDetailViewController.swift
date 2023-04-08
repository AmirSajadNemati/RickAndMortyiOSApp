//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/4/23.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController, RMEpisodeDetailViewViewModelDelegate {

    private let viewModel: RMEpisodeDetailViewViewModel
    
    private let detailView = RMEpisodeDetailView()
    
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
        view.addSubview(detailView)
        setUpConstraints()
        title = "Episode"
        view.backgroundColor = .systemBackground
        addShareButton()
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
    }
    
    // MARK : - Private
    
    private func addShareButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    @objc private func didTapShare(){
        
    }
    
    private func setUpConstraints(){
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
    }
    
// MARK : - Delegate
    
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
        
    }
  

}
