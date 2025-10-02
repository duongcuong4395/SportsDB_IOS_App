//
//  LeagueTableView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI
import Kingfisher

struct LeagueTableView: View {
    var leaguesTable: [LeagueTable]
    @Binding var showRanks: [Bool]
    var tappedTeam: (LeagueTable) -> Void
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(Array(leaguesTable.enumerated()), id: \.element.id) { index, rank in
                        /*
                        HStack {
                            ArrowShape()
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.blue, .white, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 40, height: 30)
                                .overlay {
                                    Text(rank.intRank ?? "")
                                        .font(.callout.bold())
                                        .foregroundStyle(.black)
                                }
                                
                            KFImage(URL(string: rank.badge ?? ""))
                                .placeholder { progress in
                                    ProgressView()
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                                .onTapGesture {
                                    tappedTeam(rank)
                                }
                            VStack {
                                HStack {
                                    Text(rank.teamName ?? "")
                                        .font(.caption.bold())
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("Win: \(rank.win ?? "")   Loss: \(rank.loss ?? "")   Draw: \(rank.draw ?? "")")
                                        .font(.caption)
                                    Spacer()
                                    Text("Points: \(rank.points ?? "")")
                                        .font(.caption)
                                }
                            }
                            Spacer()
                        }
                        */
                        LeagueTableItemView(rank: rank, tappedTeam: tappedTeam)
                        .slideInEffect(
                            isVisible: showRanks.indices.contains(index) ?
                                               $showRanks[index] : .constant(false),
                            delay: Double(index) * 0.1,
                            direction: .leftToRight)
                        .onAppear{
                            withAnimation(.spring()) {
                                showRanks[index] = true
                            }
                        }
                    }
                }
            }
        }
    }
}

struct LeagueTableItemView: View {
    var rank: LeagueTable
    var tappedTeam: (LeagueTable) -> Void
    
    var body: some View {
        HStack {
            ArrowShape()
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.blue, .white, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 40, height: 30)
                .overlay {
                    Text(rank.intRank ?? "")
                        .font(.callout.bold())
                        .foregroundStyle(.black)
                }
                
            KFImage(URL(string: rank.badge ?? ""))
                .placeholder { progress in
                    ProgressView()
                }
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                .onTapGesture {
                    tappedTeam(rank)
                }
            VStack {
                HStack {
                    Text(rank.teamName ?? "")
                        .font(.caption.bold())
                    Spacer()
                }
                
                HStack {
                    Text("Win: \(rank.win ?? "")   Loss: \(rank.loss ?? "")   Draw: \(rank.draw ?? "")")
                        .font(.caption)
                    Spacer()
                    Text("Points: \(rank.points ?? "")")
                        .font(.caption)
                }
            }
            Spacer()
        }
    }
}
