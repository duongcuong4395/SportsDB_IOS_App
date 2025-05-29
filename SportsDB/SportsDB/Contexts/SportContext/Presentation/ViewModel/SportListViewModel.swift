//
//  SportListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//
import SwiftUI

class SportListViewModel: ObservableObject {
    @Published var listSport = SportType.AllCases()
}
