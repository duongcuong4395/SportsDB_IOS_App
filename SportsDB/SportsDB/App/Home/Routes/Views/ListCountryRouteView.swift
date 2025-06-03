//
//  ListCountryView.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI
import Kingfisher


struct ListCountryRouteView: View {
    
    @EnvironmentObject var countryListVM: CountryListViewModel
    var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    var tappedCountry: (Country) -> Void
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    CountriesView(countries: countryListVM.countries, tappedCountry: tappedCountry)
                }
            }
        }
    }
}
