//
//  EventItemGenericView.swift
//  SportsDB
//
//  Created by Macbook on 8/8/25.
//

import SwiftUI
import Kingfisher


struct ListEventGenericView<Builder: ItemBuilder>: View where Builder.T == Event {
    var events: [Event]
    @State private var showModels: [Bool] = []
    @State private var repeatAnimationOnApear = false
    
    var itemBuilder: Builder
    var onEvent: (ItemEvent<Event>) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            if events.count > 3 {
                ScrollView(showsIndicators: false) {
                    listEventView
                }
            } else {
                listEventView
            }
        }
        .onAppear{
            withAnimation {
                if showModels.count != events.count {
                    self.showModels = Array(repeating: false, count: events.count)
               }
            }
            
        }
    }
    
    var listEventView: some View {
        LazyVStack(spacing: 20) {
            ForEach(Array(events.enumerated()), id: \.element.idEvent) { index, event in
                EventItemGenericView(
                    event: event
                    , isVisible: $showModels.indices.indices.contains(index) ?
                    $showModels[index] : .constant(false)
                    , delay: Double(index) * 0.01
                    , itemBuilder: itemBuilder
                    , onEvent: onEvent)
                .rotateOnAppear()
                .onAppear{
                    guard showModels[index] == false else { return }
                    withAnimation {
                        showModels[index] = true
                    }
                    onEvent(.onApear(for: event))
                }
                .onDisappear{
                    guard showModels[index] == true else { return }
                    if repeatAnimationOnApear {
                        self.showModels[index] = false
                    }
                    
                }
            }
        }
    }
}

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
                    .onTapGesture {
                        print("ScheduleMoto:")
                    }
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
    
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Date Time
            HStack {
                HStack {
                    Text(AppUtility.formatDate(from: event.timestamp, to: "dd/MM") ?? "")
                        .font(.caption2.bold())
                        
                    Text(event.round ?? "")
                        .font(.caption2.bold())
                    Text(AppUtility.formatDate(from: event.timestamp, to: "HH:mm") ?? "")
                        .font(.caption2.bold())
                }
                .padding(5)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                
                Spacer()
                
                //optionView(event)
                itemBuilder.buildOptions(for: event, send: onEvent)
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
                        .frame(width: UIScreen.main.bounds.width/2 - 80.0)
                        .background {
                            ArrowShape()
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .black, .black, .black]), startPoint: .leading, endPoint: .trailing))
                                .frame(width: UIScreen.main.bounds.width/2 - 80.0, height: 30)
                                
                        }
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
                .slideInEffect(isVisible: $isVisible, delay: delay, direction: .leftToRight)
                .onAppear{
                    withAnimation{
                        isVisible = true
                    }
                }
                .onTapGesture {
                    //homeTeamTapped(event)
                    //tapOnTeam(event, .HomeTeam)
                    onEvent(.tapOnTeam(for: event, with: .HomeTeam))
                }
                
                Spacer()
                
                // MARK: - Score
                HStack {
                    if ((event.homeScore?.isEmpty) == nil) || event.homeScore == "" {
                        Text("VS")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .padding(5)
                            .liquidGlass(intensity: 0.5)
                            
                    } else {
                        Text("\(event.homeScore ?? "") - \(event.awayScore ?? "")")
                            //.font(.callout)
                            //.font(.system(size: 14, weight: .bold, design: .default))
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
                        .frame(height: 65)
                        .opacity(0.3)
                        .padding(.bottom, 10)
                }
                
                Spacer()
                
                // MARK: - Away team
                HStack {
                    Text(event.awayTeam ?? "")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .frame(width: UIScreen.main.bounds.width/2 - 80.0)
                        .background {
                            ArrowShape()
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.black, .black, .black, .white.opacity(0.1)]), startPoint: .trailing, endPoint: .leading))
                                .rotation3DEffect(Angle(degrees: 180), axis: (0, 1, 0))
                                .frame(width: UIScreen.main.bounds.width/2 - 80.0, height: 30)
                                
                        }
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
                .slideInEffect(isVisible: $isVisible, delay: delay, direction: .rightToLeft)
                .onTapGesture {
                    //tapOnTeam(event, .AwayTeam)
                    onEvent(.tapOnTeam(for: event, with: .AwayTeam))
                }
            }
            .padding(0)
            .padding(.vertical, 5)
            
        }
        /*
        .background {
            KFImage(URL(string: event.square ?? ""))
                .resizable()
                .scaledToFill()
                .opacity(0.5)
        }
        */
    }
}
