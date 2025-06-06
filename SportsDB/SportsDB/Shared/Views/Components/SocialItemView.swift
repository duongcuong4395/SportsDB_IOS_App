//
//  SocialItemView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI

struct SocialItemView: View {
    @Environment(\.openURL) var openURL
    var socialLink: String?
    var iconName: String
    var body: some View {
        if let socialLink = socialLink {
            Button (action: {
                openURL(URL(string: "https://\(socialLink)")!)
            }, label: {
                Image(iconName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            })
        }
    }
}
