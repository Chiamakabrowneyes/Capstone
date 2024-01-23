//
//  WeatherView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/10/24.
//

import SwiftUI

struct WeatherView: View {
    @State private var searchText = ""
    
    var searchResults: [Forecast] {
        if searchText.isEmpty {
            return Forecast.cities
        } else {
            return Forecast.cities.filter { $0.location.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: Background
                Color("darkGray")
                    .ignoresSafeArea()
                
                // MARK: Weather Widgets
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(searchResults) { forecast in
                            WeatherWidget(forecast: forecast)
                        }
                    }
                }
                .safeAreaInset(edge: .top) {
                    EmptyView()
                        .frame(height: 70)
                }
            }
            .overlay {
                // MARK: Navigation Bar
                NavigationBar(searchText: $searchText)
            }
            .navigationBarHidden(true)
        }
    }
}
