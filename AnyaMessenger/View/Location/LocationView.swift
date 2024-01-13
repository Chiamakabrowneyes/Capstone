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
                viewModel.getCurrentLocation { coordinates in
                    if let coordinates = coordinates {
                        // Use the coordinates (latitude and longitude) as needed
                        print("Latitude: \(coordinates.latitude), Longitude: \(coordinates.longitude)")
                    } else {
                        // Handle the case where location couldn't be determined
                        print("Unable to determine location.")
                    }
                }
            }
            .colorScheme(.dark)
            .frame(width: 400, height: 500)
            .padding(10)
            .background(Color("lightPurple"))
            .cornerRadius(20)
            
        Spacer()
    }
}

