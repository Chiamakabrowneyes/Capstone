//
//  SettingsView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 9/30/23.
//



/**
 This Settings View Conforms to the EditProfileViewModel as its ObservableObject so any changes to that class properties will notify and update this view
 */
import SwiftUI

struct SettingsScene: View {
    @ObservedObject var viewModel: EditProfileSceneModel
    
    init(user: User) {
        self.viewModel = EditProfileSceneModel(user: user)
    }
    
    //initializing the user in the settings to populate data in the setting interface
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                NavigationLink(
                    destination: EditProfileScene(viewModel: viewModel),
                    label: {
                        SettingsHeader(user: viewModel.user)
                            .padding(.vertical)
                    })
                
                VStack(spacing: 1) {
                    ForEach(SettingsCellSceneModel.allCases, id: \.self) { viewModel in
                        SettingsCell(viewModel: viewModel)
                    }
                }
                
                Button(action: { AuthSceneModel.shared.signout() }, label: {
                    Text("Log Out")
                        .foregroundColor(.red)
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                        .background(Color.white)
                })
                
                Spacer()
            }
        }
    }
}
