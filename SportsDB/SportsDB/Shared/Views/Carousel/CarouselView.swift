//
//  CarouselView.swift
//  SportsDB
//
//  Created by Macbook on 2/6/25.
//

import Foundation
import SwiftUI

struct CarouselView<Content: View>: View {
    let items: [Content]
    let spacing: CGFloat
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    @State private var activeIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            // totalWidth
            let _ = CGFloat(items.count) * cardWidth + CGFloat(items.count - 1) * spacing
            let startOffset = (geometry.size.width - cardWidth) / 2
            
            HStack(spacing: spacing) {
                ForEach(0..<items.count, id: \.self) { index in
                    items[index]
                        .frame(width: cardWidth, height: cardHeight)
                        .scaleEffect(index == activeIndex ? 1.0 : 0.7) // Phóng to mục đang chọn
                        .animation(.easeInOut(duration: 0.5), value: activeIndex) // Hiệu ứng chuyển động
                    
                        //.scaleEffect(index == activeIndex && !isDragging ? 1.0 : 0.7)
                        //.animation(isDragging ? nil : .easeInOut(duration: 0.3), value: activeIndex)
                        
                        .onTapGesture {
                            withAnimation(.spring()) {
                                activeIndex = index
                                
                                //updateOffset(for: geometry.size.width, at: index)
                                updateOffset(for: geometry.size.width, at: activeIndex)
                            }
                            
                        }
                }
            }
            .padding(.horizontal, startOffset)
            .offset(x: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        dragOffset = value.translation.width + calculateActiveOffset(for: geometry.size.width)
                    }
                    .onEnded { value in
                        isDragging = false
                        let predictedEnd = value.predictedEndTranslation.width
                        let newIndex = calculateIndex(for: value.translation.width + predictedEnd, in: geometry.size.width)
                        activeIndex = min(max(newIndex, 0), items.count - 1)
                        withAnimation(.spring()) {
                            updateOffset(for: geometry.size.width, at: activeIndex)
                        }
                    }
            )
        }
    }
    
    private func calculateActiveOffset(for viewWidth: CGFloat) -> CGFloat {
        let totalOffset = CGFloat(activeIndex) * (cardWidth + spacing)
        let startOffset = (viewWidth - cardWidth) / 2
        return startOffset - totalOffset
    }
    
    private func updateOffset(for viewWidth: CGFloat, at index: Int) {
        let activeOffset = calculateActiveOffset(for: viewWidth)
        dragOffset = activeOffset
    }
    
    private func calculateIndex(for translation: CGFloat, in viewWidth: CGFloat) -> Int {
        let cardSpacing = cardWidth + spacing
        let offsetAmount = -translation / cardSpacing
        let newIndex = Int(round(CGFloat(activeIndex) + offsetAmount))
        return newIndex
    }
}


