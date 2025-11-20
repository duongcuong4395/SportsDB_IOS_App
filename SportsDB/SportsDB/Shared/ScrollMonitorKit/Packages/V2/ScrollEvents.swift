//
//  ScrollEvents.swift
//  SportsDB
//
//  Created by Macbook on 19/11/25.
//

import Foundation
import CoreGraphics

// MARK: - ScrollEvent.swift
public enum ScrollEvent: Equatable, Sendable {
    // User Interaction
    case dragStarted
    case dragEnded
    case scrolling(velocity: CGFloat)
    case scrollEnded
    
    // Position
    case reachedTop
    case reachedBottom
    case nearTop(distance: CGFloat)
    case nearBottom(distance: CGFloat)
    case distanceFromTop(CGFloat)
    case distanceFromBottom(CGFloat)
    
    // Direction
    case directionChanged(ScrollDirection)
    case scrollingDirection(ScrollDirection)
    
    // Velocity
    case velocityChanged(CGFloat)
    case fastScrollDetected(velocity: CGFloat)
    
    // Content
    case contentSizeChanged(CGSize)
    case visibleAreaChanged(CGRect)
    
    // Pagination
    case shouldLoadMore
    case refreshTriggered
    
    // NEW: Horizontal support
    case reachedLeading
    case reachedTrailing
    case nearLeading(distance: CGFloat)
    case nearTrailing(distance: CGFloat)
}
