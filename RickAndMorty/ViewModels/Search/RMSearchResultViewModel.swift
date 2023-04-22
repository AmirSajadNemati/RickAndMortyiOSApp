//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/21/23.
//

import Foundation

enum RMSearchResultViewModel{
    case character([RMCharacterCollectionViewCellViewModel])
    case episode([RMCharacterEpisodeCollectionViewCellViewModel])
    case location([RMLocationTableViewCellViewModel])
    
}
