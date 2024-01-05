//
//  SirenView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 11/4/23.
//

import SwiftUI

struct SirenView: View {
    let user: User
    @ObservedObject var viewModel: SirenViewModel
    //@StateObject private var locationViewModel: LocationViewModel
    @State var speed: Double = 50
    @State var isEditing = false
    
    
    @State var messageText: String = ""
    @State private var selectedImage: UIImage?
    
    //initializes the required parameters for Chat view
    init(user: User) {
        self.user = user
        self.viewModel = SirenViewModel(user: user)
        //_locationViewModel = StateObject(wrappedValue: LocationViewModel(user: user))
    }
    
    var body: some View {
        var riskDescription: String {
                switch Int(speed) {
                case ..<20:
                    return "Very minimal risk level"
                case 20..<40:
                    return "Minimal risk level"
                case 40..<60:
                    return "Average risk level"
                case 60..<80:
                    return "Beyond average risk level"
                case 80..<90:
                    return "Dangerous risk level"
                default:
                    return "Very Dangerous risk level"
                }
            }
        
        VStack {
            LocationView(user: user)
                        .frame(width: 300, height: 300)
            
            Text("\(Int(speed))")
                .foregroundColor(Color("darkPurple"))
            
            Slider(
                value: $speed,
                in: 0...100,
                step: 2
            )
            {
                Text("Speed")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("100")
            } onEditingChanged: { editing in
                isEditing = editing
            }
            .frame(width: 300)
            .foregroundColor(Color("darkPurple"))
            .accentColor(Color("darkPink"))
            
            
            Text(riskDescription)
                .foregroundColor(Color("darkPurple"))
                
                
            Spacer()
                .frame(height: 50)
            
            Button("Send Siren Call") {
                Task {
                    //i want to call the get currentlocation method here:
                    viewModel.sendMessageToSirenList(riskDescription: riskDescription)
                }
            }.font(.custom("chalkduster", size: 15))
            .padding(10)
            .border(Color.gray, width: 1)
            .foregroundColor(Color("darkPurple"))
            .bold()
            .tint(.black)
        }
    }
}


