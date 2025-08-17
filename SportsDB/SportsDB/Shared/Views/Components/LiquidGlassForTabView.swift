//
//  LiquidGlassForTabView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

extension View {
    func liquidGlassForTabView<T>(with tag: T) -> some View where T : Hashable {
        self.liquidGlass(intensity: 0.8)
            .padding(.horizontal, 5)
            .tag(tag)
    }
}

extension View {
    func liquidGlassForCardView() -> some View {
        self.liquidGlass(intensity: 0.8)
            .padding(.horizontal, 5)
    }
}

import Kingfisher

extension View {
    func backgroundOfRouteView(with image: String) -> some View {
        self.background {
            KFImage(URL(string: image))
                .placeholder { progress in
                    ProgressView()
                }
                .opacity(0.1)
                .ignoresSafeArea(.all)
        }
    }
}


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
