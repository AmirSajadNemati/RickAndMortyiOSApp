//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/16/23.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(
        _ rmSearchInputView: RMSearchInputView,
        didSelect option: RMSearchInputViewViewModel.DynamicOptions
    )
    
}
final class RMSearchInputView: UIView {
    
    weak public var delegate: RMSearchInputViewDelegate?
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet{
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
                return
            }
            let options = viewModel.options
            createOptionSelectionViews(options: options)
        }
    }
    
    // MARK : - SubViews
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        
        return searchBar
    }()
    
    // MARK : - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(searchBar)
        
        addConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK : - Private
    private func addConstraints(){
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            
        ])
    }
    private func createOptionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 6),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -6),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
        return stackView
    }
    private func createOptionSelectionViews(options: [RMSearchInputViewViewModel.DynamicOptions]) {
       
        let stackView = createOptionStackView()
        
        for x in 0..<options.count {
            let option = options[x]
            let button = createButton(with: option, tag: x)
            stackView.addArrangedSubview(button)
            
        }
    }
    
    @objc private func didTapButton(_ sender: UIButton){
        guard let options = viewModel?.options else {
            return
        }
        let tag = sender.tag
        let selected = options[tag]
        delegate?.rmSearchInputView(self,
                                    didSelect: selected)
    }
    
    private func createButton(
        with option: RMSearchInputViewViewModel.DynamicOptions,
        tag: Int
    ) -> UIButton {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: option.rawValue,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                    .foregroundColor: UIColor.label
                ]
            ), for: .normal
        )
        button.backgroundColor = .secondarySystemFill
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.tag = tag
        button.layer.cornerRadius = 6
        return button
    }
    
    // MARK : - Public
    public func configure(with viewModel: RMSearchInputViewViewModel){
        searchBar.placeholder = viewModel.searchPlaceholderText
        self.viewModel = viewModel
    }

    public func showKeyboard(){
        searchBar.becomeFirstResponder()
    }
}
