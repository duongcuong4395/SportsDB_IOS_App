//
//  TeamItemView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//
import SwiftUI
import Kingfisher

struct TeamItemView: View {
    let team: Team
    var badgeImageSize: (width: CGFloat, height: CGFloat)
    
    var body: some View {
        
        VStack{
            KFImage(URL(string: team.badge ?? ""))
                .placeholder { progress in
                    //LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                    ProgressView()
                    //Image("Sports")
                        //.resizable()
                        //.scaledToFill()
                }
                .resizable()
                .scaledToFill()
                .frame(width: badgeImageSize.width, height: badgeImageSize.height)
                .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
            Text(team.teamName)
                .font(.caption.bold())
            
            
        }
    }
}
