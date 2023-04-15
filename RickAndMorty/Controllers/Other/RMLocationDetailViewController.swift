//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/15/23.
//

import UIKit

final class RMLocationDetailViewController: UIViewController, RMLocationDetailViewViewModelDelegate, RMLocationDetailViewDelegate {
 
    private let viewModel: RMLocationDetailViewViewModel
    
    private let detailView = RMLocationDetailView()
    
    // MARK : - Init
    init(location: RMLocation) {
        let url = URL(string: location.url)
        self.viewModel = .init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailView)
        detailView.delegate = self
        setUpConstraints()
        title = "Location"
        view.backgroundColor = .systemBackground
        addShareButton()
        viewModel.delegate = self
        viewModel.fetchLocationData()
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
// MARK : - View Delegate
    
    func rmEpisodeDetailView(
            _ detailView: RMLocationDetailView,
            didSelect character: RMCharacter
        ) {
            let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
            vc.title = character.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    
// MARK : - ViewModel Delegate
    
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
        
    }
  

}
