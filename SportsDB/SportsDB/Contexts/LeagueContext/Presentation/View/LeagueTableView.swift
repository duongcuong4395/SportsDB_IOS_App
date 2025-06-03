//
//  LeagueTableView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI
import Kingfisher

struct LeagueTableView: View {
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    var leagueTables: [LeagueTable]
    var tappedTeam: (LeagueTable) -> Void
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(Array(leagueTables.enumerated()), id: \.element.id) { index, rank in
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
                                    /*
                                    //Image("Sports")
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundStyle(.black)
                                        .opacity(0.3)
                                        .fadeInEffect(duration: 1, isLoop: true)
                                    */
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
                        .slideInEffect(
                            isVisible: leagueListVM.showRanks.indices.contains(index) ?
                                               $leagueListVM.showRanks[index] : .constant(false),
                            delay: Double(index) * 0.1,
                            direction: .leftToRight)
                        .onAppear{
                            leagueListVM.showRanks[index] = true
                        }
                    }
                }
            }
        }
    }
}
