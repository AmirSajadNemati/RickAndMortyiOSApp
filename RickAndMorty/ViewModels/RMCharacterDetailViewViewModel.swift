//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 2/27/23.
//

import Foundation

final class RMCharacterDetailViewViewModel{
    
    private var character: RMCharacter
    
    init(character: RMCharacter){
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
