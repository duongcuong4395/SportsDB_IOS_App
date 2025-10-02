//
//  CountriesView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI


struct ListCountryView: View {
    var countries: [Country]
    var tappedCountry: (Country) -> Void
    
    var body: some View {
        ForEach(countries, id: \.name) { country in
            CountryItemView(country: country)
                .padding(0)
                .modifier(RotateOnAppearModifier_New(angle: -60, duration: 1, direction: .leftToRight))
                .onTapGesture {
                    tappedCountry(country)
                }
        }
    }
}
