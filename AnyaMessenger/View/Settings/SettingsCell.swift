//
//  SettingsCell.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 9/30/23.
//

import SwiftUI

//This SettingsCell Class creates the UI properties in the settings view
struct SettingsCell: View {
    let viewModel: SettingsCellViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(systemName: viewModel.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .padding(6)
                    .background(viewModel.backgroundColor)
                    .foregroundColor(.white)
                    .cornerRadius(6)

                Text(viewModel.title)
                    .font(.system(size: 15))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                
            }
            .padding(.top)
            .padding(.horizontal)
            
            Divider()
                .padding(.leading)
        }
        .frame(height: 56)
        .background(Color.white)
    }
}

struct SettingsCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCell(viewModel: SettingsCellViewModel(rawValue: 2)!)
    }
}
