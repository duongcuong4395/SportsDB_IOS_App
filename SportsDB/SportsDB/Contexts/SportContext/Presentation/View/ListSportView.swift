//
//  ListSportView.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI
import Kingfisher

struct SelectSportView : View {
    @EnvironmentObject var sportVM: SportViewModel
    var tappedSport: (SportType) -> Void
    
    @State var showExpandedContent: Bool = false
    @State var showFullScreenCover: Bool = false
    
    var body: some View {
        VStack {
            MorphingButton(
                backgroundColor: .black
                , showExpandedContent: $showExpandedContent
                , showFullScreenCover: $showFullScreenCover) {
                    HStack(spacing: 5) {
                        sportVM.sportSelected.getIcon()
                            .frame(width: 25, height: 25)
                        Text(sportVM.sportSelected.displayName)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .padding(5)
                    .backgroundByTheme(for: .Button(material: .ultraThin, cornerRadius: .roundedCorners))
                } content: {
                    VStack {
                        SmartContainer(hasScroll: true, maxWidth: .grid) {
                            SmartGrid(columns: DeviceSize.current.isPad ? 5 : 3, spacing: .medium) {
                                ListSportView(sportSelected: sportVM.sportSelected, touchSport: { sport in
                                    withAnimation(.interpolatingSpring(duration: 0.2, bounce: 0)) {
                                        
                                        showFullScreenCover = false
                                        sportVM.sportSelected = sport
                                        tappedSport(sportVM.sportSelected)
                                    }
                                })
                            }
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height / 2)
                    .padding([.top, .bottom], 10)
                    .backgroundByTheme(for: .Card(material: .ultraThin, cornerRadius: .moderateAngle))
                    .padding(.top, 15)
                    .overlay(alignment: .topTrailing) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .padding(5)
                            .backgroundByTheme(for: .Card(material: .none, cornerRadius: .roundedCorners))
                            .onTapGesture {
                                withAnimation(.interpolatingSpring(duration: 0.2, bounce: 0)) {
                                    showFullScreenCover = false
                                }
                            }
                            .padding(.top, 5)
                        
                    }
                } expandedContent: {
                    EmptyView()
                }
        }
    }
}

struct ListSportView: View {
    var sportSelected: SportType
    var touchSport: (SportType) -> Void
    var body: some View {
        
        
        ForEach(SportType.allCases, id: \.self) { sport in
            if sport != sportSelected {
                VStack(spacing: 5) {
                    sport.getIcon()
                        .font(.title3)
                        .frame(width: 30, height: 30)
                    Text(sport.displayName)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
                
                .onTapGesture {
                    touchSport(sport)
                }
            }
            
        }
    }
}
