//
//  ScrollExtensions.swift
//  SportsDB
//
//  Created by Macbook on 19/11/25.
//

import SwiftUI
import Combine

// MARK: - ScrollExtensions.swift (Enhanced)
import Combine

public extension View {
    /// Add scroll monitoring to any ScrollView content
    func monitorScroll(
        with viewModel: ScrollViewModel,
        bottomAnchor: String = "scrollBottom",
        topAnchor: String = "scrollTop"
    ) -> some View {
        ScrollMonitorView(
            viewModel: viewModel,
            scrollToBottomAnchor: bottomAnchor,
            scrollToTopAnchor: topAnchor
        ) {
            self
        }
    }
    
    /// Mark this view as a scroll anchor point
    func scrollAnchor(_ id: String) -> some View {
        self.id(id)
    }
    
    /// Fade in/out based on scroll position
    func scrollFade(
        viewModel: ScrollViewModel,
        range: ClosedRange<CGFloat> = 0...200
    ) -> some View {
        self.opacity(scrollOpacity(for: viewModel.state.distanceFromTop, in: range))
    }
    
    private func scrollOpacity(for distance: CGFloat, in range: ClosedRange<CGFloat>) -> Double {
        if distance <= range.lowerBound { return 1.0 }
        if distance >= range.upperBound { return 0.0 }
        let progress = (distance - range.lowerBound) / (range.upperBound - range.lowerBound)
        return 1.0 - progress
    }
    
    /// Scale based on scroll position
    func scrollScale(
        viewModel: ScrollViewModel,
        range: ClosedRange<CGFloat> = 0...200,
        scaleRange: ClosedRange<CGFloat> = 1.0...0.8
    ) -> some View {
        let scale = scrollScaleValue(
            for: viewModel.state.distanceFromTop,
            in: range,
            scaleRange: scaleRange
        )
        return self.scaleEffect(scale)
    }
    
    private func scrollScaleValue(
        for distance: CGFloat,
        in range: ClosedRange<CGFloat>,
        scaleRange: ClosedRange<CGFloat>
    ) -> CGFloat {
        if distance <= range.lowerBound { return scaleRange.lowerBound }
        if distance >= range.upperBound { return scaleRange.upperBound }
        let progress = (distance - range.lowerBound) / (range.upperBound - range.lowerBound)
        return scaleRange.lowerBound + progress * (scaleRange.upperBound - scaleRange.lowerBound)
    }
}

public extension ScrollViewModel {
    /// Create a binding to scroll state
    var stateBinding: Binding<ScrollState> {
        Binding(
            get: { self.state },
            set: { _ in }
        )
    }
    
    /// Subscribe to specific scroll events
    func onEvent(_ event: ScrollEvent, perform action: @escaping () -> Void) -> AnyCancellable {
        $latestEvent
            .compactMap { $0 }
            .filter { receivedEvent in
                switch (event, receivedEvent) {
                case (.dragStarted, .dragStarted),
                     (.dragEnded, .dragEnded),
                     (.reachedTop, .reachedTop),
                     (.reachedBottom, .reachedBottom),
                     (.scrollEnded, .scrollEnded):
                    return true
                default:
                    return false
                }
            }
            .sink { _ in action() }
    }
    
    /// Subscribe to distance changes
    func onDistanceChange(
        from edge: Edge.Set,
        threshold: CGFloat,
        perform action: @escaping (CGFloat) -> Void
    ) -> AnyCancellable {
        $state
            .map { state -> CGFloat in
                switch edge {
                case .top: return state.distanceFromTop
                case .bottom: return state.distanceFromBottom
                default: return 0
                }
            }
            .filter { $0 < threshold }
            .removeDuplicates()
            .sink(receiveValue: action)
    }
    
    /// Publisher for when scroll reaches bottom
    var reachedBottomPublisher: AnyPublisher<Void, Never> {
        $latestEvent
            .compactMap { $0 }
            .filter { if case .reachedBottom = $0 { return true }; return false }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    /// Publisher for when scroll reaches top
    var reachedTopPublisher: AnyPublisher<Void, Never> {
        $latestEvent
            .compactMap { $0 }
            .filter { if case .reachedTop = $0 { return true }; return false }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    /// Publisher for scroll direction changes
    var directionPublisher: AnyPublisher<ScrollDirection, Never> {
        $state
            .map(\.direction)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    /// Publisher for scroll progress (0.0 to 1.0)
    var progressPublisher: AnyPublisher<CGFloat, Never> {
        $state
            .map(\.scrollProgress)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

// MARK: - NEW: Pagination Helper
public struct PaginationHelper {
    private let viewModel: ScrollViewModel
    private let threshold: CGFloat
    
    public init(viewModel: ScrollViewModel, threshold: CGFloat = 150) {
        self.viewModel = viewModel
        self.threshold = threshold
    }
    
    @MainActor public func setupInfiniteScroll(loadMore: @escaping () async -> Void) {
        viewModel.onLoadMore = loadMore
    }
}

// MARK: - NEW: Scroll Position Saver
public struct ScrollPositionSaver {
    private let key: String
    
    public init(key: String) {
        self.key = key
    }
    
    public func save(offset: CGFloat) {
        UserDefaults.standard.set(offset, forKey: "ScrollMonitor_\(key)")
    }
    
    public func restore() -> CGFloat {
        UserDefaults.standard.double(forKey: "ScrollMonitor_\(key)")
    }
    
    public func clear() {
        UserDefaults.standard.removeObject(forKey: "ScrollMonitor_\(key)")
    }
}


// MARK: - Performance Monitoring
public struct ScrollPerformanceMetrics {
    public var averageFrameTime: TimeInterval = 0
    public var droppedFrames: Int = 0
    public var scrollEventCount: Int = 0
    public var lastUpdateTimestamp: Date = Date()
    
    public var fps: Double {
        guard averageFrameTime > 0 else { return 0 }
        return 1.0 / averageFrameTime
    }
}

public extension ScrollViewModel {
    func monitorPerformance() -> AnyPublisher<ScrollPerformanceMetrics, Never> {
        var metrics = ScrollPerformanceMetrics()
        var frameTimes: [TimeInterval] = []
        
        return $state
            .scan((Date(), metrics)) { previous, _ in
                let now = Date()
                let frameTime = now.timeIntervalSince(previous.0)
                
                frameTimes.append(frameTime)
                if frameTimes.count > 60 {
                    frameTimes.removeFirst()
                }
                
                var updatedMetrics = previous.1
                updatedMetrics.averageFrameTime = frameTimes.reduce(0, +) / Double(frameTimes.count)
                updatedMetrics.scrollEventCount += 1
                updatedMetrics.lastUpdateTimestamp = now
                
                if frameTime > 0.032 {
                    updatedMetrics.droppedFrames += 1
                }
                
                return (now, updatedMetrics)
            }
            .map(\.1)
            .eraseToAnyPublisher()
    }
}
