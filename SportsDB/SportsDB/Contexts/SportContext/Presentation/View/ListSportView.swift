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
                    .padding(5.5)
                    .background{
                        Color.clear
                            .liquidGlass(intensity: 0.3, tintColor: .orange, hasShimmer: true, hasGlow: true)
                    }
                    .background(.ultraThinMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                    
                } content: {
                    VStack {
                        ListSportView(sportSelected: sportVM.sportSelected, touchSport: { sport in
                            withAnimation(.interpolatingSpring(duration: 0.2, bounce: 0)) {
                                //if sportVM.sportSelected == sport { return }
                                showFullScreenCover = false
                                sportVM.sportSelected = sport
                                tappedSport(sportVM.sportSelected)
                            }
                        })
                        .frame(height: UIScreen.main.bounds.height / 2)
                        .background{
                            Color.clear
                                .liquidGlass(cornerRadius: 25, intensity: 0.1, tintColor: .white, hasShimmer: false, hasGlow: false)
                        }
                        .background(.ultraThinMaterial.opacity(0.9), in: RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .padding(.top, 15)
                        .overlay(alignment: .topTrailing) {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .padding(5)
                                .background{
                                    Color.clear
                                        .liquidGlass(cornerRadius: 25, intensity: 0.5, tintColor: .white, hasShimmer: false, hasGlow: false)
                                }
                                .background(.ultraThinMaterial.opacity(0.5), in: RoundedRectangle(cornerRadius: 25, style: .continuous))
                                .onTapGesture {
                                    withAnimation(.interpolatingSpring(duration: 0.2, bounce: 0)) {
                                        showFullScreenCover = false
                                    }
                                }
                                .padding(.top, 5)
                            
                        }
                    }
                } expandedContent: {
                    EmptyView()
                }
                

        }
        
        /*
        FloatingTabBar(
            activeBackground: .blue
            , activeTab: $sportVM.sportSelected
            , touchTabBar: { sport in
                withAnimation {
                    if sportVM.sportSelected == sport {
                        return
                    }
                    sportVM.sportSelected = sport
                    showFullScreenCover = false
                    tappedSport(sportVM.sportSelected)
                }
            })
        */
    }
}

struct ListSportView: View {
    var sportSelected: SportType
    var touchSport: (SportType) -> Void
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: AppUtility.columns, spacing: 20) {
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
            .padding()
        }
    }
}
