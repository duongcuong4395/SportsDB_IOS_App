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
    
    @State var countryFilter : [Country] = []
    
    @State var showTextSearch: Bool = false
    @State var textSearch: String = ""
    
    var body: some View {
        VStack {
            if showTextSearch {
                HStack(spacing: 10) {
                    TextFieldSearchView(listModels: [countryFilter], textSearch: $textSearch)
                    Image(systemName: "xmark")
                        .font(.title3)
                        .backgroundByTheme(for: .Button(material: .ultraThin, cornerRadius: .roundedCorners))
                        //.backgroundOfItemTouched(hasShimmer: false)
                        .onTapGesture {
                            withAnimation {
                                textSearch = ""
                                showTextSearch.toggle()
                            }
                        }
                }
                .padding([.horizontal, .top])
            }
            ScrollView(showsIndicators: false) {
                SmartContainer(maxWidth: .grid) {
                    SmartGrid(columns: DeviceSize.current.isPad ? 5 : 3, spacing: .medium) {
                        ListCountryView(countries: countryFilter, tappedCountry: tapped)
                    }
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            if !showTextSearch {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    //.backgroundOfItemTouched(hasShimmer: false)
                    .backgroundByTheme(for: .Button(material: .ultraThin, cornerRadius: .roundedCorners))
                    .onTapGesture {
                        withAnimation {
                            showTextSearch.toggle()
                        }
                    }
                    .padding([.horizontal, .top])
                    .scaleEffect(!showTextSearch ? 1 : 0)
            }
            
            
            
        }
        .onChange(of: textSearch) { oldValue, newValue in
            withAnimation {
                let _ = filterCountry()
            }
        }
        .onAppear{
            if countryListVM.countries.count <= 0 {
                Task {
                    await countryListVM.fetchCountries()
                    self.countryFilter = countryListVM.countries
                }
            } else {
                self.countryFilter = countryListVM.countries
            }
        }
        .onDisappear{
            textSearch = ""
            showTextSearch = false
        }
        .padding(.bottom, 45)
    }
    
    func filterCountry() -> [Country] {
        
        self.countryFilter = textSearch.isEmpty ? countryListVM.countries : countryListVM.countries.filter( { $0.name.lowercased().contains(textSearch.lowercased()) } )
        return []
        
    }
    
    func tapped(by country: Country) {
        UIApplication.shared.endEditing()
        withAnimation {
            countryListVM.setCountry(by: country)
            sportRouter.navigateToListLeague(by: country.name, and: sportVM.sportSelected.rawValue)
            textSearch = ""
            Task {
                await leagueListVM.fetchLeagues(country: country.name, sport: sportVM.sportSelected.rawValue)
            }
        }
    }
}
