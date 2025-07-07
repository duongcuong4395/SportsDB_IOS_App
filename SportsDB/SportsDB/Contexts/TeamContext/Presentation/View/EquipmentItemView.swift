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
                    //LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                    ProgressView()
                }
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
            Text(equipment.season ?? "")
                .font(.callout.bold())
        }
    }
}
