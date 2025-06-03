//
//  SocialView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI

struct SocialView: View {
    var facebook: String?
    var twitter: String?
    var instagram: String?
    var youtube: String?
    var website: String?
    
    var body: some View {
        HStack {
            SocialItemView(socialLink: youtube, iconName: "youtube")
            Spacer()
            SocialItemView(socialLink: twitter, iconName: "twitter")
            Spacer()
            SocialItemView(socialLink: instagram, iconName: "instagram")
            Spacer()
            SocialItemView(socialLink: facebook, iconName: "facebook")
            Spacer()
            SocialItemView(socialLink: website, iconName: "Sports")
        }.padding(5)
            .padding(.horizontal, 5)
            .background(.thinMaterial.opacity(0.9), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
