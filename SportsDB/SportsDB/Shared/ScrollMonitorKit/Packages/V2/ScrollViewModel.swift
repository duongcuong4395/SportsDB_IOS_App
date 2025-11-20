//
//  ScrollViewModel.swift
//  SportsDB
//
//  Created by Macbook on 19/11/25.
//

// MARK: - ScrollViewModel.swift
import SwiftUI
import Combine

@MainActor
public final class ScrollViewModel: ObservableObject {
    
    @Published public private(set) var state = ScrollState()
    @Published public private(set) var showScrollToBottomButton = false
    @Published public private(set) var showScrollToTopButton = false
    @Published public private(set) var latestEvent: ScrollEvent?
    
    // NEW: Pull to refresh
    @Published public private(set) var isRefreshing = false
    
    public let configuration: ScrollConfiguration
    
    private var cancellables = Set<AnyCancellable>()
    private var updateWorkItem: DispatchWorkItem?
    private var lastEventTime = Date()
    private var hapticGenerator: UIImpactFeedbackGenerator?
    
    // Callbacks
    public var onReachBottom: (() -> Void)?
    public var onReachTop: (() -> Void)?
    public var onScrollEvent: ((ScrollEvent) -> Void)?
    public var onPullToRefresh: (() async -> Void)?
    public var onLoadMore: (() async -> Void)?
    
    // NEW: Scroll position storage key
    private var scrollPositionKey: String?
    
    public init(
        configuration: ScrollConfiguration = .chat,
        scrollPositionKey: String? = nil
    ) {
        self.configuration = configuration
        self.scrollPositionKey = scrollPositionKey
        
        if configuration.enableHaptics {
            hapticGenerator = UIImpactFeedbackGenerator(style: .light)
            hapticGenerator?.prepare()
        }
        
        setupObservers()
        restoreScrollPositionIfNeeded()
    }
    
    private func setupObservers() {
        $state
            .throttle(for: .seconds(configuration.throttleInterval), scheduler: RunLoop.main, latest: true)
            .removeDuplicates()
            .sink { [weak self] state in
                self?.handleStateUpdate(state)
                self?.saveScrollPositionIfNeeded()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    public func updateContentHeight(_ height: CGFloat) {
        guard state.contentHeight != height else { return }
        state.contentHeight = height
        publishEvent(.contentSizeChanged(CGSize(width: state.contentWidth, height: height)))
    }
    
    public func updateContainerHeight(_ height: CGFloat) {
        guard state.containerHeight != height else { return }
        state.containerHeight = height
    }
    
    public func updateOffset(_ offset: CGFloat) {
        let oldDirection = state.direction
        state.updateOffset(offset)
        
        if configuration.trackDirection && oldDirection != state.direction && state.direction != .idle {
            publishEvent(.directionChanged(state.direction))
        }
        
        if configuration.trackVelocity && abs(state.velocity) > 100 {
            publishEvent(.velocityChanged(state.velocity))
        }
    }
    
    public func setDragging(_ isDragging: Bool) {
        guard state.isDragging != isDragging else { return }
        state.isDragging = isDragging
        state.phase = isDragging ? .dragging : .idle
        publishEvent(isDragging ? .dragStarted : .dragEnded)
        
        if !isDragging {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.3))
                if !state.isDragging {
                    state.resetMotion()
                    publishEvent(.scrollEnded)
                }
            }
        }
    }
    
    public func scrollToBottom() {
        triggerHaptic()
        publishEvent(.reachedBottom)
    }
    
    public func scrollToTop() {
        triggerHaptic()
        publishEvent(.reachedTop)
    }
    
    // NEW: Animated scroll to specific offset
    public func scrollTo(offset: CGFloat, animated: Bool = true) {
        state.offset = offset
    }
    
    // NEW: Pull to refresh
    public func triggerRefresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        publishEvent(.refreshTriggered)
        await onPullToRefresh?()
        isRefreshing = false
    }
    
    // NEW: Load more for pagination
    public func loadMoreIfNeeded() async {
        guard configuration.enableInfiniteScroll else { return }
        await onLoadMore?()
    }
    
    // MARK: - Private Methods
    private func handleStateUpdate(_ state: ScrollState) {
        updateButtonVisibility(for: state)
        checkPositionEvents(for: state)
        checkPaginationEvents(for: state)
    }
    
    private func updateButtonVisibility(for state: ScrollState) {
        let shouldShowBottom = state.distanceFromBottom > configuration.scrollButtonThreshold
        let shouldShowTop = state.distanceFromTop > configuration.scrollButtonThreshold
        
        if showScrollToBottomButton != shouldShowBottom {
            withAnimation(.easeInOut(duration: configuration.buttonAnimationDuration)) {
                showScrollToBottomButton = shouldShowBottom
            }
        }
        
        if showScrollToTopButton != shouldShowTop {
            withAnimation(.easeInOut(duration: configuration.buttonAnimationDuration)) {
                showScrollToTopButton = shouldShowTop
            }
        }
    }
    
    private func checkPositionEvents(for state: ScrollState) {
        publishEvent(.distanceFromBottom(state.distanceFromBottom))
        publishEvent(.distanceFromTop(state.distanceFromTop))
        
        if state.isAtTop(threshold: configuration.atTopThreshold) {
            publishEvent(.reachedTop)
            onReachTop?()
        }
        
        if state.isAtBottom(threshold: configuration.atBottomThreshold) {
            publishEvent(.reachedBottom)
            onReachBottom?()
        }
        
        if state.isNearBottom(threshold: configuration.nearBottomThreshold) {
            publishEvent(.nearBottom(distance: state.distanceFromBottom))
        }
        
        if state.isNearTop(threshold: configuration.nearTopThreshold) {
            publishEvent(.nearTop(distance: state.distanceFromTop))
        }
    }
    
    private func checkPaginationEvents(for state: ScrollState) {
        if state.distanceFromBottom < configuration.nearBottomThreshold && state.direction == .down {
            publishEvent(.shouldLoadMore)
            Task { await loadMoreIfNeeded() }
        }
    }
    
    private func publishEvent(_ event: ScrollEvent) {
        let now = Date()
        guard now.timeIntervalSince(lastEventTime) >= configuration.debounceInterval else { return }
        lastEventTime = now
        latestEvent = event
        onScrollEvent?(event)
    }
    
    private func triggerHaptic() {
        guard configuration.enableHaptics else { return }
        hapticGenerator?.impactOccurred()
    }
    
    // NEW: Save/restore scroll position
    private func saveScrollPositionIfNeeded() {
        guard configuration.saveScrollPosition, let key = scrollPositionKey else { return }
        UserDefaults.standard.set(state.offset, forKey: "ScrollMonitor_\(key)")
    }
    
    private func restoreScrollPositionIfNeeded() {
        guard configuration.restoreScrollPosition, let key = scrollPositionKey else { return }
        let saved = UserDefaults.standard.double(forKey: "ScrollMonitor_\(key)")
        if saved != 0 {
            state.offset = saved
        }
    }
}

// MARK: - Convenience Properties
public extension ScrollViewModel {
    var isAtBottom: Bool { state.isAtBottom(threshold: configuration.atBottomThreshold) }
    var isAtTop: Bool { state.isAtTop(threshold: configuration.atTopThreshold) }
    var progress: CGFloat { state.scrollProgress }
    var isScrollable: Bool { state.isScrollable }
}
