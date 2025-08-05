//
//  EquipmentItemView.swift
//  SportsDB
//
//  Created by Macbook on 4/6/25.
//

import SwiftUI
import Kingfisher

struct EquipmentItemView: View {
    
    var equipment: Equipment
    
    var body: some View {
        VStack {
            KFImage(URL(string: equipment.equipment ?? ""))
                .placeholder { progress in
                    ProgressView()
                }
                .resizable()
                .scaledToFill()
                .rotateOnAppear(angle: -90, duration: 0.5, axis: .y)
            Text(equipment.season ?? "")
                .font(.callout.bold())
        }
    }
}
