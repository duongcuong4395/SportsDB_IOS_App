//
//  VenueListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

class VenueListViewModel: ObservableObject {
    @Published var venuesByLookup: [Venue] = []
    @Published var venuesBySearch: [Venue] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private var lookupVenueUseCase: LookupVenueUseCase
    private var searchVenuesUseCase: SearchVenuesUseCase
    
    init(lookupVenueUseCase: LookupVenueUseCase,
         searchVenuesUseCase: SearchVenuesUseCase) {
        self.lookupVenueUseCase = lookupVenueUseCase
        self.searchVenuesUseCase = searchVenuesUseCase
    }
    
    func lookupVenue(eventID: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            venuesByLookup = try await lookupVenueUseCase.execute(eventID: eventID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func searchVenuesUseCase(venueName: String) async {
        isLoading = true
        defer { isLoading = false }
        do{
            venuesBySearch = try await searchVenuesUseCase.execute(venueName: venueName)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
