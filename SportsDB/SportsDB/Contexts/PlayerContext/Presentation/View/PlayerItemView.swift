//
//  PlayerItemView.swift
//  SportsDB
//
//  Created by Macbook on 2/6/25.
//
import SwiftUI
import Kingfisher


struct PlayerItemView: View {
    
    let player: Player
    var animation: Namespace.ID
    var sizeImage: (width: CGFloat, height: CGFloat) = (width: 70.0, height: 70.0)
    var body: some View {
        VStack {
            KFImage(URL(string: player.sport == .Motorsport ? player.cutout ?? "" : player.render ?? ""))
                .placeholder { progress in
                    //LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                    ProgressView()
                }
                .resizable()
                .scaledToFill()
                .frame(width: sizeImage.width * 3, height: sizeImage.height * 3)
                .matchedGeometryEffect(id: "player_\(player.player ?? "")", in: animation)
            Text(player.player ?? "")
                .font(.callout.bold())
            //Text(player.position ?? "")
                //.font(.callout)
            
            /*
            SocialView(facebook: player.facebook
                       , twitter: player.twitter
                       , instagram: player.instagram
                       , youtube: player.youtube
                       , website: player.website)
            .scaleEffect(0.9)
             */
        }
        /*
        VStack {
            HStack {
                KFImage(URL(string: player.sport == .Motorsport ? player.cutout ?? "" : player.render ?? ""))
                    .placeholder { progress in
                        //LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: sizeImage.width * 3, height: sizeImage.height * 3)
                
                    .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                VStack(alignment: .leading, spacing: 5) {
                    Text(player.player ?? "")
                        .font(.callout.bold())
                    Text(player.position ?? "")
                        .font(.caption.bold())
                    HStack {
                        Text(player.height ?? "")
                            .font(.caption)
                        Text(player.weight ?? "")
                            .font(.caption)
                        
                        
                        Spacer()
                    }
                    ScrollView(showsIndicators: false) {
                        Text(player.descriptionEN ?? "")
                            .font(.caption)
                            .lineLimit(nil)
                            .frame(height: 200, alignment: .leading)
                    }
                }
            
                Spacer()
                
            }
            SocialView(facebook: player.facebook
                       , twitter: player.twitter
                       , instagram: player.instagram
                       , youtube: player.youtube
                       , website: player.website)
            .scaleEffect(0.9)
        }
        */
    }
}


struct PlayerDetailView: View {
    var player: Player
    var sizeImage: (width: CGFloat, height: CGFloat) = (width: 70.0, height: 70.0)
    var animation: Namespace.ID
    var body: some View {
        VStack {
            HStack {
                KFImage(URL(string: player.sport == .Motorsport ? player.cutout ?? "" : player.render ?? ""))
                    .placeholder { progress in
                        //LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFit()
                    //.frame(width: sizeImage.width * 3, height: sizeImage.height * 3)
                    .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                    .matchedGeometryEffect(id: "player_\(player.player ?? "")", in: animation)
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(player.player ?? "")\n(\(player.dateBorn ?? ""))")
                        .font(.callout.bold())
                    Text("\(player.birthLocation ?? "")")
                        .font(.caption.bold())
                    Text("\(player.position ?? "")(\(player.number ?? ""))")
                        .font(.caption.bold())
                    HStack {
                        Text(player.height ?? "")
                            .font(.caption)
                        Text(player.weight ?? "")
                            .font(.caption)
                        Spacer()
                    }
                    Text("Signing: \(player.signing ?? "")")
                        .font(.caption)
                    Text("Wage: \(player.wage ?? "")")
                        .font(.caption)
                    Text("Kit: \(player.kit ?? "")")
                        .font(.caption)
                    
                }
            
                Spacer()
                
            }
            ScrollView(showsIndicators: false) {
                Text(player.descriptionEN ?? "")
                    .font(.caption)
                    .lineLimit(nil)
                    .frame(height: 200, alignment: .leading)
            }
            SocialView(facebook: player.facebook
                       , twitter: player.twitter
                       , instagram: player.instagram
                       , youtube: player.youtube
                       , website: player.website)
            .scaleEffect(0.9)
        }
    }
}
