//
//  CountryItemView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI
import Kingfisher

struct CountryItemView: View {
    var country: Country
    var isHStack: Bool = false
    var body: some View {
        if isHStack {
            HStack(spacing: 10) {
                KFImage(URL(string: country.getFlag(by: .Medium)))
                    .placeholder {
                        //LoadingIndicator(animation: .circleBars, size: .small, speed: .normal)
                        ProgressView()
                    }
                    .font(.caption)
                
                    .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                    .frame(width: 50, height: 50)
                Text(country.name)
                    .font(.caption)
            }
            
        } else {
            VStack {
                KFImage(URL(string: country.getFlag(by: .Medium)))
                    .placeholder {
                        //LoadingIndicator(animation: .circleBars, size: .small, speed: .normal)
                        ProgressView()
                    }
                    .font(.caption)
                
                    .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                    .frame(width: 50, height: 50)
                Text(country.name)
                    .font(.caption)
            }
        }
    }
}
