//
//  EventItemGenericView.swift
//  SportsDB
//
//  Created by Macbook on 8/8/25.
//

import SwiftUI
import Kingfisher

struct EventItemGenericView<Builder: ItemBuilder>: View where Builder.T == Event {
    var event: Event
    @Binding var isVisible: Bool
    var delay: Double
    
    var itemBuilder: Builder
    var onEvent: (ItemEvent<Event>) -> Void
    
    var body: some View {
        switch SportType(rawValue: event.sportName ?? "")?.competitionFormat {
        case .teamVsTeam:
            EventItemGenericFor2vs2View(event: event, isVisible: $isVisible
                , delay: delay, itemBuilder: itemBuilder, onEvent: onEvent)
        case .oneVsOne, .teamVsTeams, .doubles, .freeForAll, .multiFormat:
            EventItemGenericForSingleView(event: event, itemBuilder: itemBuilder, onEvent: onEvent)
        default: EmptyView()
        }
    }
}

struct EventItemGenericForSingleView<Builder: ItemBuilder>: View where Builder.T == Event {
    var event: Event
    
    var itemBuilder: Builder
    var onEvent: (ItemEvent<Event>) -> Void
    
    var body: some View {
        VStack {
            // MARK: - Date Time
            HStack {
                HStack {
                    Text(AppUtility.formatDate(from: event.timestamp, to: "dd/MM") ?? "")
                    Text(event.round ?? "")
                    Text(AppUtility.formatDate(from: event.timestamp, to: "HH:mm") ?? "")
                }
                .font(.caption2)
                .padding(5)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                
                Spacer()
                
                //optionView(event)
                itemBuilder.buildOptions(for: event, send: onEvent)
            }
            .padding(.leading, 40)
            .padding(.trailing, 10)
            
            
            HStack {
                // MARK: - Main Match Infor
                Text(event.eventName ?? "")
                    .font(.caption.bold())
                    .lineLimit(2)
                Spacer()
            }
            .padding(5)
            .padding(.vertical, 5)
            .padding(.leading, 20)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding(.trailing, 10)
            .padding(.leading, 20)
        }
        .overlay {
            HStack {
                if let sport = SportType(rawValue: event.sportName ?? "") {
                    KFImage(URL(string: sport.getImageUrl()))
                        .placeholder({ progress in
                            //LoadingIndicator(animation: .circleBars, size: .small, speed: .normal)
                            ProgressView()
                        })
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .shadow(color: Color.yellow, radius: 3, x: 0, y: 0)
                        .padding(.leading, 5)
                        .offset(y: -10)
                        .onTapGesture {
                            //eventTapped(event)
                            onEvent(.tapped(for: event))
                        }
                }
                
                Spacer()
            }
        }
        .background{
            KFImage(URL(string: event.banner ?? ""))
                .resizable()
                .scaledToFill()
                .opacity(0.15)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
            
        }
    }
}

struct EventItemGenericFor2vs2View<Builder: ItemBuilder>: View where Builder.T == Event {
    
    var event: Event
    @Binding var isVisible: Bool
    var delay: Double
    var itemBuilder: Builder
    var onEvent: (ItemEvent<Event>) -> Void
    
    @State var showOptionsView: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Date Time
            EventDateTimeView()
            
            HStack {
                // MARK: - Home Team
                HStack {
                    TeamNameView(by: event.homeTeam ?? "", with: .HomeTeam)
                        .overlay {
                            HStack {
                                TeamBadgeView(by: event.homeTeamBadge ?? "")
                                Spacer()
                            }
                        }
                }
                .slideInEffect(isVisible: $isVisible, delay: delay, direction: .leftToRight)
                .onTapGesture {
                    onEvent(.tapOnTeam(for: event, with: .HomeTeam))
                }
                
                Spacer()
                
                // MARK: - Score
                ScoreView()
                
                Spacer()
                
                // MARK: - Away team
                HStack {
                    TeamNameView(by: event.awayTeam ?? "", with: .AwayTeam)
                        .overlay {
                            HStack {
                                Spacer()
                                TeamBadgeView(by: event.awayTeamBadge ?? "")
                            }
                        }
                }
                .slideInEffect(isVisible: $isVisible, delay: delay, direction: .rightToLeft)
                .onTapGesture {
                    onEvent(.tapOnTeam(for: event, with: .AwayTeam))
                }
            }
            .padding(0)
            .padding(.vertical, 5)
        }
        .onAppear{
            withAnimation{
                isVisible = true
            }
        }
    }
    
    @ViewBuilder
    func EventDateTimeView() -> some View {
        HStack {
            HStack {
                Text(event.round ?? "")
                    .smartFont(.caption, weight: .medium)
                    //.font(.caption2.bold())
                VStack {
                    Text(AppUtility.formatDate(from: event.timestamp, to: "dd/MM") ?? "")
                        //.font(.caption2.bold())
                        .smartFont(.caption, weight: .medium)
                    Text(AppUtility.formatDate(from: event.timestamp, to: "HH:mm") ?? "")
                        .smartFont(.caption, weight: .medium)
                        //.font(.caption2.bold())
                }
            }
            .padding(5)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
            .onTapGesture {
                withAnimation(.spring()) {
                    showOptionsView.toggle()
                }
            }
            
            //itemBuilder.buildOptions(for: event, send: onEvent)
            Spacer()
            if showOptionsView {
                itemBuilder.buildOptions(for: event, send: onEvent)
                    .padding(.horizontal, 5)
                    .liquidGlass(intensity: 0.8)
            }
            
        }
        .padding(.horizontal, 50)
        .padding(.trailing, 20)
    }
    
    @ViewBuilder
    func TeamBadgeView(by name: String) -> some View {
        KFImage(URL(string: name))
            .placeholder { progress in
                ProgressView()
            }
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .offset(y: -25)
            .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
    }
    
    @ViewBuilder
    func TeamNameView(by name: String, with kindTeam: KindTeam) -> some View {
        Text(name)
            .font(.caption2)
            //.smartFont(.caption, weight: .medium)
            //.smartFont(.caption, weight: .semibold)
            //.smartFont(.caption, weight: .ultraLight)
            .foregroundStyle(.white)
            .lineLimit(2)
            .smartPadding(.small)
            .frame(width: UIScreen.main.bounds.width/2 - 80.0)
            .background {
                ArrowShape()
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.black, .black, .black, .white.opacity(0.1)]), startPoint: .trailing, endPoint: .leading))
                    .rotation3DEffect(Angle(degrees: kindTeam == .HomeTeam ? 0 : 180), axis: (0, 1, 0))
                    .frame(width: UIScreen.main.bounds.width/2 - 80.0)
                    
            }
    }
    
    @ViewBuilder
    func ScoreView() -> some View {
        HStack {
            if ((event.homeScore?.isEmpty) == nil) || event.homeScore == "" {
                Text("VS")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .padding(5)
                    .liquidGlass(intensity: 0.5)
                    
            } else {
                Text("\(event.homeScore ?? "") - \(event.awayScore ?? "")")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .padding(5)
                    .liquidGlass(intensity: 0.5)
            }
        }
        .frame(width: 70)
        .background{
            KFImage(URL(string: event.leagueBadge ?? ""))
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .opacity(0.3)
                .padding(.bottom, 10)
        }
    }
}
