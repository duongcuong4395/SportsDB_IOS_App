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
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(equipments, id: \.id) { equipment in
                        EquipmentItemView(equipment: equipment)
                            .rotateOnAppear(angle: -90, duration: 0.5, axis: .y)
                            
                    }
                }
            }
        }
    }
}
