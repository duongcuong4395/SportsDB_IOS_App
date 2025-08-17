//
//  LikeRouteView.swift
//  SportsDB
//
//  Created by Macbook on 12/8/25.
//

import SwiftUI
import SwiftData
import Kingfisher

struct LikeRouteView: View {
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventSwiftDataVM: EventSwiftDataViewModel
    @Environment(\.modelContext) var context
    
    @State var events: [EventSwiftData] = []
    
    var body: some View {
        VStack {
            // MARK: Header
            HStack(spacing: 10) {
                Button(action: {
                    //leagueListVM.resetAll()
                    sportRouter.pop()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                })
                HStack {
                    Image(systemName: events.count > 0 ? "heart.fill" : "heart")
                        .font(.title3)
                    Text("Favotire")
                        .font(.title3.bold())
                }
                .onTapGesture {
                    sportRouter.pop()
                }
                
                Spacer()
            }
            .backgroundOfRouteHeaderView(with: 70)
            
            ScrollView(showsIndicators: false) {
                ForEach(events, id: \.idEvent) { event in
                    LazyVStack {
                        getEvent(event)
                    }
                    .padding(.horizontal, 10)
                    
                }
            }
        }
        .onAppear{
            self.events = eventSwiftDataVM.events.filter({ $0.like == true })
        }
    }
    
    @ViewBuilder
    func getEvent(_ event: EventSwiftData) -> some View {
        HStack {
            KFImage(URL(string: event.poster ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .cornerRadius(15)
            VStack(alignment: .leading) {
                Text(event.eventName ?? "")
                    .font(.footnote.bold())
                
                Text(event.leagueName ?? "")
                    .font(.caption.bold())
                + Text("(\(event.season ?? ""))")
                    .font(.caption)
                Text(event.getDateTime())
                    .font(.caption2)
            }
            
            Spacer()
            
            
            Image(systemName: "ellipsis")
                .font(.title2.bold())
                .padding()
                .onTapGesture {
                    
                    
                    Task {
                        _ = try await eventSwiftDataVM.toggleLike(event)
                        withAnimation {
                            self.events.removeAll(where: { $0.idEvent == event.idEvent })
                        }
                        
                        //await notificationListVM.removeNotification(id: noti.id)
                    }
                }
        }
        .padding(10)
        .background{
            Color.clear
                .liquidGlass(cornerRadius: 15, intensity: 0.3, tintColor: .orange, hasShimmer: true, hasGlow: true)
        }
        .background(.ultraThinMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        .padding([.top, .leading], 13)
        .overlay(alignment: .topLeading) {
            SportType(rawValue: event.sportName ?? "")?.getIcon()
                .frame(width: 30, height: 30)
        }
    }
}
