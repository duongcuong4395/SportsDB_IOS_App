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


class AppViewModel: ObservableObject {
    @Published var showDialog: Bool = false
    @Published var titleDialog: String = ""
    @Published var bodyDialog = AnyView(Text("This is my content"))
    
    @Published var appMode: ColorScheme = .light
    
    @Published var loading: Bool = false
    @Published var titleButonAction: String = ""
    
    func showDialogView(with title: String, and body: AnyView) {
        self.titleDialog = title
        self.bodyDialog = body
        self.showDialog = true
    }
}
