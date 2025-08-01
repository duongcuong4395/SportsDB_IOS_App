//
//  ListSportView.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI
import Kingfisher

struct ListSportView: View {
    @EnvironmentObject var sportVM: SportViewModel
    
    var tappedSport: (SportType) -> Void
    var body: some View {
        FloatingTabBar(
            activeBackground: .blue
            , activeTab: $sportVM.sportSelected
            , touchTabBar: { sport in
                withAnimation {
                    if sportVM.sportSelected == sport {
                        return
                    }
                    sportVM.sportSelected = sport
                    
                    tappedSport(sportVM.sportSelected)
                }
            })
        /*
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(SportType.allCases, id: \.self) { sport in
                        
                        if sport != .Darts {
                            VStack {
                                KFImage(URL(string: sport.getImageUrl(with: sport == sportVM.sportSelected)
                                           ))
                                    .placeholder { progress in
                                        //LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                                        ProgressView()
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    
                                Text(sport.rawValue)
                                    .font(sport == sportVM.sportSelected ? .caption.bold() : .caption)
                            }
                            .padding(.horizontal, 5)
                            
                            .onTapGesture {
                                withAnimation {
                                    if sportVM.sportSelected == sport {
                                        return
                                    }
                                    sportVM.sportSelected = sport
                                    
                                    tappedSport(sportVM.sportSelected)
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .frame(height: 50)
        .padding(5)
        .padding(.horizontal, 10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 35, style: .continuous))
         */
    }
}
