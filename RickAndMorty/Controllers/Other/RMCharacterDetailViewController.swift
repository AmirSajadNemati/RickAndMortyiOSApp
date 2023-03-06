//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 2/27/23.
//

import UIKit



/// Controller to show detail for a selected character
final class RMCharacterDetailViewController: UIViewController {

    private var viewModel: RMCharacterDetailViewViewModel
    
    // MARK : - Init
    
    init(viewModel: RMCharacterDetailViewViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK : - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        // Do any additional setup after loading the view.
    }
    

    

}
