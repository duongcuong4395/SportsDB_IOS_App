//
//  ScrollConfiguration.swift
//  SportsDB
//
//  Created by Macbook on 19/11/25.
//

import CoreGraphics
import Foundation

// MARK: - ScrollConfiguration.swift
public struct ScrollConfiguration: Sendable {
    
    // Thresholds
    public var nearBottomThreshold: CGFloat
    public var nearTopThreshold: CGFloat
    public var atBottomThreshold: CGFloat
    public var atTopThreshold: CGFloat
    public var scrollButtonThreshold: CGFloat
    
    // Performance
    public var debounceInterval: TimeInterval
    public var throttleInterval: TimeInterval
    
    // Behavior
    public var autoScrollToBottom: Bool
    public var enableHaptics: Bool
    public var trackVelocity: Bool
    public var trackDirection: Bool
    public var axis: Axis
    
    // Animation
    public var scrollAnimationDuration: TimeInterval
    public var buttonAnimationDuration: TimeInterval
    
    // NEW: Advanced features
    public var enablePullToRefresh: Bool
    public var enableInfiniteScroll: Bool
    public var saveScrollPosition: Bool
    public var restoreScrollPosition: Bool
    
    public init(
        nearBottomThreshold: CGFloat = 150,
        nearTopThreshold: CGFloat = 150,
        atBottomThreshold: CGFloat = 10,
        atTopThreshold: CGFloat = 10,
        scrollButtonThreshold: CGFloat = 200,
        debounceInterval: TimeInterval = 0.05,
        throttleInterval: TimeInterval = 0.016,
        autoScrollToBottom: Bool = true,
        enableHaptics: Bool = true,
        trackVelocity: Bool = true,
        trackDirection: Bool = true,
        axis: Axis = .vertical,
        scrollAnimationDuration: TimeInterval = 0.3,
        buttonAnimationDuration: TimeInterval = 0.22,
        enablePullToRefresh: Bool = false,
        enableInfiniteScroll: Bool = false,
        saveScrollPosition: Bool = false,
        restoreScrollPosition: Bool = false
    ) {
        self.nearBottomThreshold = nearBottomThreshold
        self.nearTopThreshold = nearTopThreshold
        self.atBottomThreshold = atBottomThreshold
        self.atTopThreshold = atTopThreshold
        self.scrollButtonThreshold = scrollButtonThreshold
        self.debounceInterval = debounceInterval
        self.throttleInterval = throttleInterval
        self.autoScrollToBottom = autoScrollToBottom
        self.enableHaptics = enableHaptics
        self.trackVelocity = trackVelocity
        self.trackDirection = trackDirection
        self.axis = axis
        self.scrollAnimationDuration = scrollAnimationDuration
        self.buttonAnimationDuration = buttonAnimationDuration
        self.enablePullToRefresh = enablePullToRefresh
        self.enableInfiniteScroll = enableInfiniteScroll
        self.saveScrollPosition = saveScrollPosition
        self.restoreScrollPosition = restoreScrollPosition
    }
    
    // Presets
    public static let chat = ScrollConfiguration(
        scrollButtonThreshold: 150,
        autoScrollToBottom: true,
        enableHaptics: true
    )
    
    public static let feed = ScrollConfiguration(
        scrollButtonThreshold: 300,
        autoScrollToBottom: false,
        enableHaptics: false,
        enableInfiniteScroll: true
    )
    
    public static let minimal = ScrollConfiguration(
        throttleInterval: 0.1,
        enableHaptics: false,
        trackVelocity: false,
        trackDirection: false
    )
    
    public enum Axis: Sendable {
        case vertical, horizontal, both
    }
}
