//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 3/29/23.
//

import Foundation


final class RMCharacterInfoCollectionViewCellViewModel {
    private let value: String
    private let title: String
    init(
        value: String,
        title: String
    ){
        self.value = value
        self.title = title
    }
}
