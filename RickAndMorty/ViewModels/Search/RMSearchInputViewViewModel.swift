//
//  RMSearchInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/16/23.
//

import UIKit

final class RMSearchInputViewViewModel {
    
    private let type: RMSearchViewController.Config.`Type`
    
    enum DynamicOptions: String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
        
        var choices: [String] {
            switch self {
            case .status:
                return ["alive", "dead", "unkown"]
            case .gender:
                return ["male", "female", "unkown", "genderless"]
            case .locationType:
                return ["planet", "cluster", "microverse"]
            }
        }
        
        var queryArgument: String {
            switch self{
            case .status:
                return "status"
            case .locationType:
                return "type"
            case.gender:
                return "gender"
            }
        }
        
    }
    
    // MARK : - Init
    init(type: RMSearchViewController.Config.`Type`){
        self.type = type
    }
    
    // MARK : - Public
    
    public var hasDynamicOptions: Bool {
        switch self.type {
        case .location, .character :
            return true
        case .episode:
            return false
        }
    }
    
    public var options: [DynamicOptions] {
        switch self.type {
        case .location:
            return [.locationType]
        case .character:
            return [.gender, .status]
        case .episode:
            return []
        }
    }
    
    public var searchPlaceholderText: String {
        switch self.type {
        case .location:
            return "Location Name"
        case .character:
            return "Character Name"
        case .episode:
            return "Episode Name"
        }
    }
}
