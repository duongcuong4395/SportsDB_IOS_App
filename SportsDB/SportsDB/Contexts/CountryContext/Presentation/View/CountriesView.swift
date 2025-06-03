//
//  CountriesView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI

struct CountriesView: View {
    
    var countries: [Country]
    
    var tappedCountry: (Country) -> Void
    
    var body: some View {
        ForEach(countries, id: \.name) { country in
            VStack {
                CountryItemView(country: country)
            }
            .padding(0)
            //.rotateOnAppear(angle: -60, duration: 0.5, axis: .y)
            .modifier(RotateOnAppearModifier_New(angle: -60, duration: 1, direction: .leftToRight))
            .onTapGesture {
                tappedCountry(country)
            }
        }
    }
}
