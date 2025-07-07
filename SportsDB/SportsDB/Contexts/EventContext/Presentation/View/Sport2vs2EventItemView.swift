//
//  Sport2vs2EventItemView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI
import Kingfisher

enum KindTeam {
    case AwayTeam
    case HomeTeam
}

struct Sport2vs2EventItemView<OptionsView: View>: View {
    @Binding var isVisible: Bool
    var delay: Double
    var event: Event
    var optionView: (Event) -> OptionsView
    
    //var homeTeamTapped: (Event) -> Void
    //var awayTeamTapped: (Event) -> Void
    var tapOnTeam: (Event, KindTeam) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Date Time
            HStack {
                HStack {
                    Text(AppUtility.formatDate(from: event.timestamp, to: "dd/MM") ?? "")
                        .font(.caption2.bold())
                        
                    Text(event.round ?? "")
                        .font(.caption2.bold())
                    Text(AppUtility.formatDate(from: event.timestamp, to: "hh:mm") ?? "")
                        .font(.caption2.bold())
                }
                .padding(5)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                
                Spacer()
                
                optionView(event)
            }
            .padding(.horizontal, 50)
            .padding(.trailing, 20)
            
            HStack {
                // MARK: - Home Team
                HStack {
                    Text(event.homeTeam ?? "")
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .frame(width: UIScreen.main.bounds.width/2 - 50.0)
                        .background {
                            ArrowShape()
                                //.fill(.green)
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .black, .black, .black]), startPoint: .leading, endPoint: .trailing))
                                .frame(width: UIScreen.main.bounds.width/2 - 50.0, height: 30)
                                .overlay {
                                    HStack {
                                        KFImage(URL(string: event.homeTeamBadge ?? ""))
                                            .placeholder { progress in
                                                ProgressView()
                                            }
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .offset(y: -25)
                                            .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                                        Spacer()
                                    }
                                }
                        }
                }
                .slideInEffect(isVisible: $isVisible, delay: delay, direction: .leftToRight)
                .onAppear{
                    withAnimation{
                        isVisible = true
                    }
                }
                .onTapGesture {
                    //homeTeamTapped(event)
                    tapOnTeam(event, .HomeTeam)
                }
                
                Spacer()
                
                // MARK: - Score
                HStack {
                    if ((event.homeScore?.isEmpty) == nil) || event.homeScore == "" {
                        Text("VS")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            
                    } else {
                        Text("\(event.homeScore ?? "") - \(event.awayScore ?? "")")
                            .font(.callout)
                            .font(.system(size: 14, weight: .bold, design: .default))
                    }
                }
                .frame(width: 70)
                
                Spacer()
                
                // MARK: - Away team
                HStack {
                    Text(event.awayTeam ?? "")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .frame(width: UIScreen.main.bounds.width/2 - 50.0)
                        .background {
                            ArrowShape()
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.black, .black, .black, .white.opacity(0.1)]), startPoint: .trailing, endPoint: .leading))
                                .rotation3DEffect(Angle(degrees: 180), axis: (0, 1, 0))
                                .frame(width: UIScreen.main.bounds.width/2 - 50.0, height: 30) // width: 40,
                                .overlay {
                                    HStack {
                                        Spacer()
                                        KFImage(URL(string: event.awayTeamBadge ?? ""))
                                            .placeholder { progress in
                                                //LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                                                ProgressView()
                                            }
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .offset(y: -25)
                                            .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                                    }
                                }
                        }
                }
                .slideInEffect(isVisible: $isVisible, delay: delay, direction: .rightToLeft)
                .onTapGesture {
                    tapOnTeam(event, .AwayTeam)
                }
            }
            .padding(0)
            .padding(.vertical, 5)
        }
    }
}
