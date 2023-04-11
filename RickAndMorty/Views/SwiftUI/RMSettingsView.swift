//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 4/10/23.
//

import SwiftUI

struct RMSettingsView: View {
    
    let viewModel: RMSettingsViewViewModel
    
    // MARK : - Init
    init(viewModel: RMSettingsViewViewModel){
        self.viewModel = viewModel
    }
    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack{
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.red)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                    
                }
                Text(viewModel.title).padding(.leading, 10)
                    
                    
                Spacer()
            }
            
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

struct RMSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingsView(viewModel: RMSettingsViewViewModel.init(cellViewModels: RMSettingsOptions.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0) { option in
                
            }
        })))
    }
}
