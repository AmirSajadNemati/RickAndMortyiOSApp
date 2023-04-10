//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/10/23.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {

   
    let id = UUID()
  
    public let type: RMSettingsOptions
    public let onTapHandler: (RMSettingsOptions) -> Void
    
    // MARK : - Init
    init(type: RMSettingsOptions, onTapHandler: @escaping (RMSettingsOptions) -> Void){
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    // MARK : - Public
    public var image: UIImage? {
        return type.iconImage
    }
    
    public var title: String {
        return type.displayTitle
    }
    
    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
    
    public var targetUrl: URL?{
        return type.targetUrl
    }
}
