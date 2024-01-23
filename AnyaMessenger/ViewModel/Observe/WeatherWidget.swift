//
//  WeatherWidget.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/10/24.
//

import SwiftUI

struct WeatherWidget: View {
    var forecast: Forecast
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: Trapezoid
            Trapezoid()
                .fill(Color("darkPink"))
                .frame(width: 342, height: 174)
            Trapezoid()
                .fill(Color("darkPurple"))
                .frame(width: 342, height: 174)
                .rotationEffect(.degrees(180))
            
            // MARK: Content
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        // MARK: Forecast Temperature Range
                        Text(forecast.reportText)
                            .foregroundColor(Color.black)
                            .font(.custom("chalkduster", size: 13))
                            .padding(10)    // 10 points of padding to the top
                            .bold()
                        
                        Spacer()
                            .frame(height: 5)
                        
                        // MARK: Forecast Location
                        Text(forecast.location)
                            .foregroundColor(Color.black)
                            .font(.custom("chalkduster", size: 15))
                            .padding([.bottom], 10)
                            .bold()
                    }
                    .frame(width: 300, height: 150)
                }
            }
            .padding(.bottom, 20)
            .padding(.leading, 20)
        }
        .frame(width: 342, height: 184, alignment: .bottom)
    }
}
