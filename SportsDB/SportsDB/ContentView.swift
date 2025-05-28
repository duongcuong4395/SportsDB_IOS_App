//
//  ContentView.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var leagueListVM: LeagueListViewModel
    
    init() {
        let repository = LeagueAPIService()
        let getLeaguesUseCase = GetLeaguesUseCase(repository: repository)
        let lookupLeagueUseCase = LookupLeagueUseCase(repository: repository)
        let lookupLeagueTableUseCase = LookupLeagueTableUseCase(repository: repository)
        
        self._leagueListVM = StateObject(wrappedValue: LeagueListViewModel(
            getLeaguesUseCase: getLeaguesUseCase,
            lookupLeagueUseCase: lookupLeagueUseCase,
            lookupLeagueTableUseCase: lookupLeagueTableUseCase))
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .environmentObject(leagueListVM)
        
        .onAppear {
            Task {
                await leagueListVM.fetchLeagues(country: "England", sport: "Soccer")
                print("=== fetchLeagues.leagues.count", leagueListVM.leagues.count)
                print("=== fetchLeagues.leagues.message", leagueListVM.errorMessage ?? "")
                
            }
            
            
        }
    }
}

#Preview {
    ContentView()
}
