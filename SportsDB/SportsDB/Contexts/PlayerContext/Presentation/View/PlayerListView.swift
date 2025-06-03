//
//  PlayerListView.swift
//  SportsDB
//
//  Created by Macbook on 2/6/25.
//

import SwiftUI

struct PlayerListView: View {
    var players: [Player]
    @State var selection: Int = 0
    
    @State private var offset: CGFloat = 0
    @State private var dragging: Bool = false
    
    var body: some View {
        CarouselView(
               items: players.map { player in
                   PlayerItemView(player: player)
                       .cornerRadius(10)
                       .shadow(radius: 5)
               },
               spacing: 5,
               cardWidth: UIScreen.main.bounds.width,
               cardHeight: UIScreen.main.bounds.height / 2  - 20
           )
    }
}
