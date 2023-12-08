//
//  LocationView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 11/24/23.
//

import SwiftUI
import MapKit

struct LocationView: View {
    @StateObject private var viewModel: LocationViewModel
    let user: User

    init(user: User) {
        self.user = user
        _viewModel = StateObject(wrappedValue: LocationViewModel(user: user))
    }

    var body: some View {
        Map(coordinateRegion: $viewModel.region)
            .onAppear {
                viewModel.checkIfLocationServicesIsEnabled()
            }
            .frame(width: 250, height: 250)
            .padding(10)
            .background(Color("lightPurple"))
            .cornerRadius(20)
    }
}

