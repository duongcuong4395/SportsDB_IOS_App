//
//  TitleComponentView.swift
//  SportsDB
//
//  Created by Macbook on 31/5/25.
//

import SwiftUI

struct TitleComponentView: View {
    var title: String
    var body: some View {
        HStack {
            Text("\(title):")
                .font(.callout.bold())
            Spacer()
        }
    }
}
