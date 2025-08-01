//
//  ListCountryView.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI
import Kingfisher


struct ListCountryRouteView: View {
    @EnvironmentObject var sportVM: SportViewModel
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var countryListVM: CountryListViewModel
    
    var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    CountriesView(countries: countryListVM.countries, tappedCountry: tapped)
                }
            }
        }
    }
    
    func tapped(by country: Country) {
        UIApplication.shared.endEditing()
        countryListVM.setCountry(by: country)

        Task {
            sportRouter.navigateToListLeague(by: country.name, and: sportVM.sportSelected.rawValue)
            await leagueListVM.fetchLeagues(country: country.name, sport: sportVM.sportSelected.rawValue)
        }
    }
}
