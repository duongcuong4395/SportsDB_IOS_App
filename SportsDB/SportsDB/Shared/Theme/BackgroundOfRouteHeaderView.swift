//
//  BackgroundOfRouteHeaderView.swift
//  SportsDB
//
//  Created by Macbook on 1/9/25.
//

import SwiftUI

extension View {
    func backgroundOfRouteHeaderView(with height: CGFloat = 70) -> some View {
        self.padding(.horizontal)
            .frame(height: height)
            .background {
                Color.clear
                    .liquidGlass(intensity: 0.8)
                    .ignoresSafeArea(.all)
            }
    }
}
