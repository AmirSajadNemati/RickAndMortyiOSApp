//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 3/29/23.
//

import UIKit

final class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    
    // MARK : - Properties
    static let cellIdentifier = "RMCharacterEpisodeCollectionViewCell"
    
    // MARK : - Subviews
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK : - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        setUpLayer()
        
        addSubviews(seasonLabel, nameLabel, airDateLabel)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpLayer(){
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        
    }
    private func setUpConstraints(){
        
        NSLayoutConstraint.activate([
        
            // SeasonLabel
            seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            seasonLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            seasonLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            seasonLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
            
            // nameLabel
           nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor, constant: 10),
           nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
           nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
           nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
            
            // AirDateLabel
            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            airDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            airDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            airDateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
            
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }
    
    public func configure(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel){
        viewModel.registerForData { [weak self] data in
            self?.seasonLabel.text = "Episode " + data.episode
            self?.nameLabel.text = data.name
            self?.airDateLabel .text = "Aired on " + data.air_date
            
        }
        viewModel.fetchEpisode()
        contentView.layer.borderColor = viewModel.borderColor.cgColor
    }
}
