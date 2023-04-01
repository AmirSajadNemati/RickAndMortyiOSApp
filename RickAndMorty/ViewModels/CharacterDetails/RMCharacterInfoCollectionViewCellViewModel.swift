//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 3/29/23.
//

import UIKit


final class RMCharacterInfoCollectionViewCellViewModel {
    private let type: `Type`
    private var value: String
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static var shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()
    
    
    public var title: String {
        return type.displayeTitle
    }
    
    public var displayValue: String {
        if value.isEmpty {return "None"}
        
        if let data = Self.dateFormatter.date(from: value),
           type == .created {
            return Self.shortDateFormatter.string(from: data)
        }
        return value
    }
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    init(
        type: `Type`,
        value: String
    ){
        self.type = type
        self.value = value
    }
    /*
     
     .init(value: character.status.text, title: "Status"),
     .init(value: character.gender.rawValue, title: "Gender"),
     .init(value: character.type, title: "Type"),
     .init(value: character.species, title: "Species"),
     .init(value: character.origin.name, title: "Origin"),
     .init(value: String(character.episode.count), title: "Episodes"),
     .init(value: character.location.name, title: "Location"),
     .init(value: character.created, title: "Created"),
     
     */
    enum `Type`: String {
        
        case status
        case gender
        case type
        case species
        case origin
        case episodesCount
        case location
        case created
        
        // Displayed Title
        var displayeTitle: String {
            switch self {
            case .status,
                    .gender,
                    .type,
                    .species,
                    .origin,
                    .location,
                    .created:
                return rawValue.uppercased()
            case .episodesCount:
                return "EPISODE COUNT"
            }
        }
        
        // Tint Color
        var tintColor: UIColor {
            switch self{
            case .status:
                return .systemOrange
            case .gender:
                return .systemYellow
            case .type:
                return .systemGreen
            case .species:
                return .systemMint
            case .origin:
                return .systemCyan
            case .episodesCount:
                return .systemPurple
            case .location:
                return .systemPink
            case .created:
                return .systemRed
            }
        }
        // Icon Image
        var iconImage: UIImage? {
            switch self{
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .episodesCount:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            }
        }
        
    }
}
