//
//  NotificationRouteView.swift
//  SportsDB
//
//  Created by Macbook on 12/8/25.
//

import SwiftUI
import UserNotifications
import Kingfisher

struct NotificationRouteView: View {
    @EnvironmentObject var notificationListVM: NotificationListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventSwiftDataVM: EventSwiftDataViewModel
    
    var body: some View {
        VStack {
            // MARK: Header
            HStack(spacing: 10) {
                Button(action: {
                    sportRouter.pop()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                })
                HStack(spacing: 5) {
                    Image(systemName: notificationListVM.notifications.count > 0 ? "bell.fill" : "bell")
                        .font(.body)
                        
                    Text("Notification")
                        .font(.body.bold())
                }
                .onTapGesture {
                    sportRouter.pop()
                }
                Spacer()
            }
            .backgroundOfRouteHeaderView(with: 70)
            
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(notificationListVM.notifications, id: \.id) { noti in
                        HStack {
                            KFImage(URL(string: noti.userInfo["poster"] ?? ""))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .cornerRadius(15)
                            VStack(alignment: .leading) {
                                Text(noti.title)
                                    .font(.footnote.bold())
                                
                                Text(noti.userInfo["leagueName"] ?? "")
                                    .font(.caption.bold())
                                + Text("(\(noti.userInfo["season"] ?? ""))")
                                    .font(.caption)
                                Text(noti.userInfo["dateTime"] ?? "")
                                    .font(.caption2)
                            }
                            
                            Spacer()
                            
                            
                            Image(systemName: "ellipsis")
                                .font(.title2.bold())
                                .padding()
                                .onTapGesture {
                                    
                                    Task {
                                        await notificationListVM.removeNotification(id: noti.id)
                                        await notificationListVM.loadNotifications()
                                        
                                        
                                    }
                                    
                                }
                            /*
                            NotificationItem(
                                id: idEvent ?? "",// id.uuidString,
                                title: eventName ?? "Upcoming Event",
                                body: "\(homeTeam ?? "") vs \(awayTeam ?? "")",
                                triggerDate: date,
                                userInfo: [
                                    "idEvent": idEvent ?? "",
                                    "eventName": eventName ?? "",
                                    "sportType": sportName ?? "", // hoặc sportType.rawValue
                                    "homeTeamName": homeTeam ?? "",
                                    "awayTeamName": awayTeam ?? "",
                                    "idHomeTeam": idHomeTeam ?? "",
                                    "idAwayTeam": idAwayTeam ?? "",
                                    "idVenue": idVenue ?? "",
                                    "strVenue": venue ?? "",
                                    "poster": poster ?? "",
                                    "thumb": thumb ?? "",
                                    "banner": banner ?? "",
                                    "square": square ?? ""
                                ],
                                hasRead: false
                            )
                            */
                        }
                        .padding(10)
                        .background{
                            Color.clear
                                .liquidGlass(cornerRadius: 15, intensity: 0.3, tintColor: .orange, hasShimmer: true, hasGlow: true)
                        }
                        .background(.ultraThinMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .padding([.top, .leading], 13)
                        .overlay(alignment: .topLeading) {
                            SportType(rawValue: noti.userInfo["sportType"] ?? "")?.getIcon()
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .onAppear{
            Task {
                await notificationListVM.loadNotifications()
            }
        }
    }
}
