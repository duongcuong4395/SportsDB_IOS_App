//
//  EquipmentsTabOfTeamDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

struct EquipmentsTabOfTeamDetailRouteView: View {
    
    @Binding var isVisibleViews: (
        forEvents: Bool,
        forEquipment: Bool
    )
    
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    var body: some View {
        EquipmentsListView(equipments: teamDetailVM.equipments)
            .onAppear{
                isVisibleViews.forEquipment = true
            }
            .padding(.vertical)
    }
}
