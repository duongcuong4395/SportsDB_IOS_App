//
//  SportSingleEventItemView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI
import Kingfisher

struct SportSingleEventItemView<OptionView: View>: View {
    
    
    var event: Event
    var optionView: (Event) -> OptionView
    var eventTapped: (Event) -> Void
    
    var body: some View {
        VStack {
            // MARK: - Date Time
            HStack {
                HStack {
                    Text(AppUtility.formatDate(from: event.timestamp, to: "dd/MM") ?? "")
                    Text(event.round ?? "")
                    Text(AppUtility.formatDate(from: event.timestamp, to: "hh:mm") ?? "")
                }
                .font(.caption2)
                .padding(5)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                
                Spacer()
                
                optionView(event)
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
                            eventTapped(event)
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
