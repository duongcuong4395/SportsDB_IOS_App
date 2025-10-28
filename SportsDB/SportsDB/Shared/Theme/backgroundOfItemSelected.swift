//
//  backgroundOfItemSelected.swift
//  SportsDB
//
//  Created by Macbook on 1/9/25.
//

import SwiftUI

struct BackgroundOfItemSelectedViewModifier: ViewModifier {
    var padding: CGFloat = 10
    var hasShimmer: Bool = true
    var isSelected: Bool
    var animation: Namespace.ID
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    func body(content: Content) -> some View {
        content
            .font(.callout.bold())
        
            .foregroundColor(isSelected ? .black : (colorScheme == .light ? .gray : .white))
        
            .padding(padding)
            .background{
                if isSelected {
                    Color.clear
                        .backgroundOfItemTouched(color: .blue, intensity: 0.8, hasShimmer: hasShimmer)
                        .matchedGeometryEffect(id: "season", in: animation)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
    
}
    
extension View {
    func backgroundOfItemSelected(padding: CGFloat = 10, hasShimmer: Bool = true, isSelected: Bool, animation: Namespace.ID) -> some View {
        self.modifier(BackgroundOfItemSelectedViewModifier(padding: padding, hasShimmer: hasShimmer, isSelected: isSelected, animation: animation))
    }
}

