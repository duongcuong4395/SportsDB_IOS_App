//
//  EquipmentsListView.swift
//  SportsDB
//
//  Created by Macbook on 4/6/25.
//

import SwiftUI

struct EquipmentsListView: View {
    var equipments: [Equipment]
    
    var body: some View {
        SmartContainer(hasScroll: true, maxWidth: .grid) {
            SmartGrid(columns: DeviceSize.current.isPad ? 5 : 3, spacing: .medium) {
                ListEquipmentView(equipments: equipments)
            }
        }
    }
}

struct ListEquipmentView: View {
    var equipments: [Equipment]
    var body: some View {
        ForEach(equipments, id: \.id) { equipment in
            EquipmentItemView(equipment: equipment)
        }
    }
}
