//
//  SportListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//
import SwiftUI

class SportViewModel: ObservableObject {
    @Published var listSport = SportType.AllCases()
    
    @Published var sportSelected: SportType = .Soccer
}
