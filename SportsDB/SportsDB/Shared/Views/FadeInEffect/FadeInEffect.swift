//
//  FadeInEffect.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI

enum FadeDirection {
    case bottomToTop, topToBottom, leftToRight, rightToLeft
}

struct FadeInEffectModifier: ViewModifier {
    @State private var revealPercentage: CGFloat = 0.0
    let duration: Double
    let direction: FadeDirection
    let isLoop: Bool

    func body(content: Content) -> some View {
        content
            .overlay(overlayView.mask(content))
            .onAppear {
                startAnimation()
            }
    }

    private func startAnimation() {
        withAnimation(.easeInOut(duration: duration)) {
            revealPercentage = 1.0
        }

        if isLoop {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                resetAnimation()
            }
        }
    }

    private func resetAnimation() {
        revealPercentage = 0.0
        startAnimation()
    }

    private var overlayView: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .clear, location: revealPercentage),
                .init(color: .black, location: revealPercentage)
            ]),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }

    private var startPoint: UnitPoint {
        switch direction {
        case .bottomToTop: return .bottom
        case .topToBottom: return .top
        case .leftToRight: return .leading
        case .rightToLeft: return .trailing
        }
    }

    private var endPoint: UnitPoint {
        switch direction {
        case .bottomToTop: return .top
        case .topToBottom: return .bottom
        case .leftToRight: return .trailing
        case .rightToLeft: return .leading
        }
    }
}

extension View {
    func fadeInEffect(duration: Double = 1.0, direction: FadeDirection = .bottomToTop, isLoop: Bool = false) -> some View {
        self.modifier(FadeInEffectModifier(duration: duration, direction: direction, isLoop: isLoop))
    }
}
