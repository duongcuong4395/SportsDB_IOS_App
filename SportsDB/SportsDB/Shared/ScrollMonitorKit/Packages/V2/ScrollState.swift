//
//  ScrollState.swift
//  SportsDB
//
//  Created by Macbook on 19/11/25.
//

// MARK: - ScrollState.swift
import CoreGraphics
import Foundation

public struct ScrollState: Equatable, Sendable {
    
    // MARK: - Geometry
    public var contentHeight: CGFloat = 0
    public var containerHeight: CGFloat = 0
    public var offset: CGFloat = 0
    public var contentWidth: CGFloat = 0
    public var containerWidth: CGFloat = 0
    
    // MARK: - Motion
    public var velocity: CGFloat = 0
    public var direction: ScrollDirection = .idle
    public var phase: ScrollPhase = .idle
    public var previousOffset: CGFloat = 0
    public var lastUpdateTime: Date = Date()
    
    // MARK: - Flags
    public var isDragging: Bool = false
    public var isScrolling: Bool = false
    public var isAtRest: Bool = true
    
    // MARK: - Computed Properties
    public var distanceFromBottom: CGFloat {
        max(0, (contentHeight + offset) - containerHeight)
    }
    
    public var distanceFromTop: CGFloat {
        abs(min(0, offset))
    }
    
    public var scrollProgress: CGFloat {
        guard contentHeight > containerHeight else { return 0 }
        let scrollableHeight = contentHeight - containerHeight
        guard scrollableHeight > 0 else { return 0 }
        return distanceFromTop / scrollableHeight
    }
    
    public var scrollPercentage: CGFloat {
        scrollProgress * 100
    }
    
    // MARK: - Position Checks
    public func isAtBottom(threshold: CGFloat = 10) -> Bool {
        distanceFromBottom < threshold
    }
    
    public func isAtTop(threshold: CGFloat = 10) -> Bool {
        distanceFromTop < threshold
    }
    
    public func isNearBottom(threshold: CGFloat = 150) -> Bool {
        distanceFromBottom < threshold && distanceFromBottom > 0
    }
    
    public func isNearTop(threshold: CGFloat = 150) -> Bool {
        distanceFromTop < threshold && distanceFromTop > 0
    }
    
    public var isScrollable: Bool {
        contentHeight > containerHeight
    }
    
    public var visibleRect: CGRect {
        CGRect(x: 0, y: distanceFromTop, width: containerWidth, height: containerHeight)
    }
    
    // MARK: - Update
    public mutating func updateOffset(_ newOffset: CGFloat) {
        let now = Date()
        let timeDelta = now.timeIntervalSince(lastUpdateTime)
        
        if timeDelta > 0 {
            let offsetDelta = newOffset - offset
            velocity = offsetDelta / timeDelta
        }
        
        if abs(newOffset - offset) > 1 {
            direction = newOffset < offset ? .down : .up
        } else {
            direction = .idle
        }
        
        previousOffset = offset
        offset = newOffset
        lastUpdateTime = now
    }
    
    public mutating func resetMotion() {
        velocity = 0
        direction = .idle
        phase = .idle
        isScrolling = false
    }
}

// MARK: - ScrollDirection
public enum ScrollDirection: Equatable, Sendable {
    case up, down, left, right, idle
    
    public var isVertical: Bool { self == .up || self == .down }
    public var isHorizontal: Bool { self == .left || self == .right }
}

// MARK: - ScrollPhase
public enum ScrollPhase: Equatable, Sendable {
    case idle, dragging, decelerating, programmatic
}
