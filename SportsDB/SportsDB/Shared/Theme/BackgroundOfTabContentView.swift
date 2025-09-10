//
//  BackgroundOfTabContentView.swift
//  SportsDB
//
//  Created by Macbook on 1/9/25.
//

import SwiftUI

/*
extension View {
    func backgroundOfTabContentView<T>(with tag: T) -> some View where T: Hashable {
        self.backgroundOfCardView()
            .tag(tag)
    }
}
*/


extension View {
    func backgroundOfCardView(intensity: Double = 0.8,
                                cornerRadius: CGFloat = 20) -> some View {
        self.liquidGlass(intensity: intensity, cornerRadius: cornerRadius)
            .padding(.horizontal, 5)
    }
}

// backgroundOfCardView
