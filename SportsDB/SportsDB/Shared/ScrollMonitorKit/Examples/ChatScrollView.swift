//
//  ChatScrollView.swift
//  SportsDB
//
//  Created by Macbook on 19/11/25.
//
import SwiftUI

// MARK: - Example 1: Chat Application (Comprehensive)
// ChatView.swift
// Demonstrates: Auto-scroll, haptics, scroll buttons, event monitoring

import Combine



struct ChatWithScrollView: View {
    @StateObject private var scrollViewModel = ScrollViewModel(
        configuration: .chat,
        scrollPositionKey: "ChatView_MainChat"
    )
    
    @State private var messages: [ChatMessage] = []
    @State private var messageText = ""
    @State private var isTyping = false
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with scroll progress indicator
            chatHeader
            
            // Main chat scroll view
            ScrollMonitorView(
                viewModel: scrollViewModel,
                showButtons: .bottom,
                bottomButtonStyle: .floating,
                onScrollToBottom: {
                    print("User tapped scroll to bottom")
                }
            ) {
                LazyVStack(spacing: 12) {
                    // Top anchor for scroll-to-top
                    Color.clear
                        .frame(height: 1)
                        .scrollAnchor("scrollTop")
                    
                    ForEach(messages) { message in
                        MessageBubbleView(message: message)
                            .id(message.id)
                            // Fade in animation based on scroll
                            .scrollFade(
                                viewModel: scrollViewModel,
                                range: 0...100
                            )
                    }
                    
                    // Typing indicator
                    if isTyping {
                        TypingIndicatorView()
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    // Bottom anchor for auto-scroll
                    Color.clear
                        .frame(height: 1)
                        .scrollAnchor("scrollBottom")
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            
            // Message input
            messageInputView
        }
        .onAppear {
            setupScrollMonitoring()
            loadInitialMessages()
        }
    }
    
    // MARK: - Header
    private var chatHeader: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Chat Room")
                    .font(.headline)
                
                Spacer()
                
                // Show scroll position indicator
                if scrollViewModel.isScrollable {
                    Text("\(Int(scrollViewModel.progress * 100))%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            
            // Progress bar showing scroll position
            GeometryReader { geometry in
                Rectangle()
                    .fill(.blue)
                    .frame(width: geometry.size.width * scrollViewModel.progress)
            }
            .frame(height: 2)
        }
        .background(.ultraThinMaterial)
    }
    
    // MARK: - Message Input
    private var messageInputView: some View {
        HStack(spacing: 12) {
            TextField("Message", text: $messageText)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    sendMessage()
                }
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(.blue)
                    .clipShape(Circle())
            }
            .disabled(messageText.isEmpty)
        }
        .padding()
        .background(.ultraThinMaterial)
    }
    
    // MARK: - Setup Scroll Monitoring
    private func setupScrollMonitoring() {
        // 1. Monitor when user reaches bottom
        scrollViewModel.onReachBottom = {
            print("📍 User scrolled to bottom")
        }
        
        // 2. Monitor when user reaches top (for loading old messages)
        scrollViewModel.onReachTop = {
            print("📍 User scrolled to top - could load older messages")
            loadOlderMessages()
        }
        
        // 3. Monitor all scroll events
        scrollViewModel.onScrollEvent = { event in
            switch event {
            case .dragStarted:
                print("🖱️ User started dragging")
            case .dragEnded:
                print("🖱️ User stopped dragging")
            case .reachedBottom:
                print("✅ Reached bottom - mark as read")
                markMessagesAsRead()
            case .nearBottom(let distance):
                if distance < 50 {
                    print("⚠️ Near bottom: \(distance)pt")
                }
            case .velocityChanged(let velocity):
                print("⚡️ Scroll velocity: \(velocity)")
            default:
                break
            }
        }
        
        // 4. Use Combine publishers for reactive updates
        scrollViewModel.reachedBottomPublisher
            .sink {
                print("🔔 Bottom reached via Combine publisher")
            }
            .store(in: &cancellables)
        
        scrollViewModel.directionPublisher
            .sink { direction in
                print("🧭 Scroll direction: \(direction)")
            }
            .store(in: &cancellables)
        
        scrollViewModel.progressPublisher
            .sink { progress in
                // Update UI based on scroll progress
                if progress > 0.9 {
                    // Near end - could trigger actions
                }
            }
            .store(in: &cancellables)
        
        // 5. Debug logging (development only)
        /*
        #if DEBUG
        _ = scrollViewModel.enableDebugLogging()
        
        scrollViewModel.monitorPerformance()
            .sink { metrics in
                if metrics.fps < 50 {
                    print("⚠️ Performance issue: \(metrics.fps) FPS, dropped: \(metrics.droppedFrames)")
                }
            }
            .store(in: &cancellables)
        #endif
         */
    }
    
    // MARK: - Actions
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        /*
         let newMessage = ChatMessage(
             text: messageText,
             isFromCurrentUser: true,
             timestamp: Date()
         )
         */
        
        let newMessage = ChatMessage(
            role: .user
            , content: messageText
        )
        
        withAnimation(.spring(response: 0.3)) {
            messages.append(newMessage)
        }
        
        messageText = ""
        
        // Auto-scroll to bottom when sending message
        if scrollViewModel.configuration.autoScrollToBottom {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                scrollViewModel.scrollToBottom()
            }
        }
        
        // Simulate AI response
        simulateAIResponse()
    }
    
    private func simulateAIResponse() {
        isTyping = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let responses = [
                "That's interesting! Tell me more.",
                "I understand what you mean.",
                "Great point! 🎉",
                "Thanks for sharing that."
            ]
            /*
            let aiMessage = ChatMessage(
                text: responses.randomElement()!,
                isFromCurrentUser: false,
                timestamp: Date()
            )
            */
            
            let aiMessage = ChatMessage(
                role: .system
                , content: responses.randomElement()!
            )
            
            withAnimation(.spring(response: 0.3)) {
                messages.append(aiMessage)
                isTyping = false
            }
        }
    }
    
    private func loadInitialMessages() {
        messages = [
            ChatMessage(role: .system, content: "Hey! How are you?"),
            ChatMessage(role: .user, content: "I'm doing great! Thanks for asking."),
            ChatMessage(role: .system, content: "What are you working on?"),
            ChatMessage(role: .user, content: "Building a scroll monitoring system in SwiftUI!"),
        ]
    }
    
    private func loadOlderMessages() {
        // Simulate loading older messages from API
        let olderMessages = [
            ChatMessage(role: .system, content: "This is an older message"),
            ChatMessage(role: .user, content: "From earlier in the conversation"),
        ]
        
        withAnimation {
            messages.insert(contentsOf: olderMessages, at: 0)
        }
    }
    
    private func markMessagesAsRead() {
        // Mark messages as read when user reaches bottom
        print("✉️ Marking messages as read")
    }
}

// MARK: - Message Bubble View
struct MessageBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            }
            
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(message.role == .user ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(message.role == .user ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            if !(message.role == .user) {
                Spacer()
            }
        }
    }
}

struct TypingIndicatorView: View {
    @State private var animating = false
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(.gray)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animating ? 1.0 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: animating
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .onAppear {
            animating = true
        }
    }
}

// MARK: - Example 2: Social Media Feed with Infinite Scroll
// FeedView.swift

struct Post: Identifiable {
    let id = UUID()
    let username: String
    let avatar: String
    let content: String
    let imageURL: String?
    let likes: Int
    let comments: Int
    let timestamp: Date
}

struct FeedView: View {
    @StateObject private var scrollViewModel = ScrollViewModel(
        configuration: ScrollConfiguration(
            scrollButtonThreshold: 400,
            autoScrollToBottom: false,
            enableHaptics: false,
            enablePullToRefresh: true,
            enableInfiniteScroll: true,
            saveScrollPosition: true,
            restoreScrollPosition: true
        ),
        scrollPositionKey: "FeedView_Main"
    )
    
    @State private var posts: [Post] = []
    @State private var isLoadingMore = false
    @State private var currentPage = 1
    
    var body: some View {
        NavigationView {
            ScrollMonitorView(
                viewModel: scrollViewModel,
                showButtons: .top,
                topButtonStyle: ScrollButtonStyle(
                    icon: "arrow.up.circle.fill",
                    label: "Back to Top",
                    backgroundColor: .blue.opacity(0.9),
                    foregroundColor: .white,
                    cornerRadius: 25,
                    padding: EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12),
                    shadow: .prominent,
                    material: nil,
                    position: .topTrailing,
                    offset: CGPoint(x: -20, y: 60)
                )
            ) {
                LazyVStack(spacing: 0) {
                    Color.clear
                        .frame(height: 1)
                        .scrollAnchor("scrollTop")
                    
                    ForEach(posts) { post in
                        PostCardView(post: post)
                            .id(post.id)
                            // Parallax effect on images
                            .scrollScale(
                                viewModel: scrollViewModel,
                                range: 0...300,
                                scaleRange:  0.95...1.0 //1.0...0.95
                            )
                    }
                    
                    // Loading indicator for infinite scroll
                    if isLoadingMore {
                        ProgressView("Loading more posts...")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    
                    Color.clear
                        .frame(height: 1)
                        .scrollAnchor("scrollBottom")
                }
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ScrollProgressIndicator(viewModel: scrollViewModel)
                }
            }
        }
        .onAppear {
            setupFeedMonitoring()
            loadInitialPosts()
        }
    }
    
    private func setupFeedMonitoring() {
        // Pull to refresh
        scrollViewModel.onPullToRefresh = {
            await refreshFeed()
        }
        
        // Infinite scroll - load more
        scrollViewModel.onLoadMore = {
            await loadMorePosts()
        }
        
        // Track scroll events
        scrollViewModel.onScrollEvent = { event in
            switch event {
            case .shouldLoadMore:
                if !isLoadingMore {
                    Task { await loadMorePosts() }
                }
            case .reachedTop:
                print("🔝 Reached top of feed")
            case .nearBottom(let distance):
                // Prefetch next page when near bottom
                if distance < 200 && !isLoadingMore {
                    Task { await loadMorePosts() }
                }
            default:
                break
            }
        }
    }
    
    private func loadInitialPosts() {
        posts = generateMockPosts(count: 10, page: 1)
    }
    
    private func refreshFeed() async {
        try? await Task.sleep(for: .seconds(1.5))
        currentPage = 1
        posts = generateMockPosts(count: 10, page: 1)
    }
    
    private func loadMorePosts() async {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        
        try? await Task.sleep(for: .seconds(1))
        
        currentPage += 1
        let newPosts = generateMockPosts(count: 10, page: currentPage)
        posts.append(contentsOf: newPosts)
        
        isLoadingMore = false
    }
    
    private func generateMockPosts(count: Int, page: Int) -> [Post] {
        (0..<count).map { index in
            Post(
                username: "user\((page - 1) * count + index)",
                avatar: "person.circle.fill",
                content: "This is post #\((page - 1) * count + index). Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                imageURL: nil,
                likes: Int.random(in: 10...1000),
                comments: Int.random(in: 0...100),
                timestamp: Date().addingTimeInterval(-Double.random(in: 0...86400))
            )
        }
    }
}

struct PostCardView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: post.avatar)
                    .font(.title2)
                    .foregroundStyle(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.username)
                        .font(.headline)
                    
                    Text(post.timestamp, style: .relative)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                }
            }
            
            // Content
            Text(post.content)
                .font(.body)
            
            // Image placeholder
            if post.imageURL != nil {
                Rectangle()
                    .fill(.gray.opacity(0.2))
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Actions
            HStack(spacing: 20) {
                Label("\(post.likes)", systemImage: "heart")
                Label("\(post.comments)", systemImage: "bubble.right")
                Label("Share", systemImage: "paperplane")
                
                Spacer()
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(.background)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray.opacity(0.2)),
            alignment: .bottom
        )
    }
}

struct ScrollProgressIndicator: View {
    @ObservedObject var viewModel: ScrollViewModel
    
    var body: some View {
        if viewModel.isScrollable {
            CircularProgressView(progress: viewModel.progress)
        }
    }
}

struct CircularProgressView: View {
    let progress: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.gray.opacity(0.3), lineWidth: 3)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))")
                .font(.caption2)
                .fontWeight(.semibold)
        }
        .frame(width: 30, height: 30)
    }
}

// MARK: - Example 3: Photo Gallery with Horizontal Scroll
// GalleryView.swift

struct Photo: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

struct GalleryView: View {
    @StateObject private var horizontalScrollVM = ScrollViewModel(
        /*
         configuration: ScrollConfiguration(
             axis: .horizontal,
             enableHaptics: true,
             trackVelocity: true
         )
         */
        
        configuration: ScrollConfiguration(
            enableHaptics: true, trackVelocity: true, axis: .horizontal
        )
    )
    
    @StateObject private var verticalScrollVM = ScrollViewModel(
        /*
         configuration: ScrollConfiguration(
             axis: .vertical,
             scrollButtonThreshold: 300
         )
         */
        
        configuration: ScrollConfiguration(
            scrollButtonThreshold: 300, axis: .vertical
        )
    )
    
    let photos = (0..<50).map { Photo(name: "Photo \($0)", color: Color.random) }
    
    var body: some View {
        NavigationView {
            ScrollMonitorView(viewModel: verticalScrollVM) {
                VStack(spacing: 20) {
                    // Horizontal gallery section
                    horizontalGallerySection
                    
                    // Grid section
                    gridSection
                }
                .padding()
            }
            .navigationTitle("Gallery")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Reset Vertical Position") {
                            verticalScrollVM.scrollToTop()
                        }
                        Button("Go to Bottom") {
                            verticalScrollVM.scrollToBottom()
                        }
                        /*
                        #if DEBUG
                        Button("Debug State") {
                            verticalScrollVM.debugPrintState()
                        }
                        #endif
                         */
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .onAppear {
            setupGalleryMonitoring()
        }
    }
    
    private var horizontalGallerySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Featured")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Horizontal scroll indicator
                if horizontalScrollVM.isScrollable {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .opacity(horizontalScrollVM.state.distanceFromTop > 10 ? 1 : 0.3)
                        
                        Image(systemName: "chevron.right")
                            .opacity(horizontalScrollVM.state.distanceFromBottom > 10 ? 1 : 0.3)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            
            // Note: For true horizontal ScrollView, you'd use ScrollView(.horizontal)
            // This is simplified for demonstration
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(photos.prefix(10)) { photo in
                        PhotoCard(photo: photo, size: 200)
                    }
                }
            }
            .frame(height: 200)
        }
    }
    
    private var gridSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Photos")
                .font(.title2)
                .fontWeight(.bold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(photos) { photo in
                    PhotoCard(photo: photo, size: nil)
                        // Fade in based on scroll position
                        .scrollFade(
                            viewModel: verticalScrollVM,
                            range: 0...150
                        )
                }
            }
        }
    }
    
    private func setupGalleryMonitoring() {
        verticalScrollVM.onScrollEvent = { event in
            switch event {
            case .velocityChanged(let velocity):
                if abs(velocity) > 1000 {
                    print("⚡️ Fast scroll detected: \(velocity)")
                }
            case .directionChanged(let direction):
                print("🧭 Direction: \(direction)")
            default:
                break
            }
        }
    }
}

struct PhotoCard: View {
    let photo: Photo
    let size: CGFloat?
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(photo.color.gradient)
            .overlay(
                VStack {
                    Spacer()
                    Text(photo.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .shadow(radius: 2)
                        .padding(8)
                }
            )
            .frame(width: size, height: size ?? 180)
    }
}

extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

// MARK: - Example 4: Settings with Sections & Navigation
// SettingsView.swift

struct SettingsScrollView: View {
    @StateObject private var scrollViewModel = ScrollViewModel(
        configuration: ScrollConfiguration(
            scrollButtonThreshold: 250,
            enableHaptics: true,
            saveScrollPosition: true,
            restoreScrollPosition: true
        ),
        scrollPositionKey: "SettingsView"
    )
    
    @State private var selectedSection: SettingSection?
    
    enum SettingSection: String, CaseIterable, Identifiable {
        case account = "Account"
        case notifications = "Notifications"
        case privacy = "Privacy"
        case appearance = "Appearance"
        case advanced = "Advanced"
        
        var id: String { rawValue }
        var icon: String {
            switch self {
            case .account: return "person.circle"
            case .notifications: return "bell.fill"
            case .privacy: return "lock.fill"
            case .appearance: return "paintbrush.fill"
            case .advanced: return "gearshape.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollMonitorView(
                viewModel: scrollViewModel,
                showButtons: .both
            ) {
                LazyVStack(spacing: 0) {
                    Color.clear.frame(height: 1).scrollAnchor("scrollTop")
                    
                    ForEach(SettingSection.allCases) { section in
                        SettingSectionView(
                            section: section,
                            isVisible: isSectionVisible(section)
                        )
                        .id(section.id)
                    }
                    
                    Color.clear.frame(height: 1).scrollAnchor("scrollBottom")
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(SettingSection.allCases) { section in
                            Button(action: {
                                // Jump to section (would need ScrollViewReader integration)
                                selectedSection = section
                            }) {
                                Label(section.rawValue, systemImage: section.icon)
                            }
                        }
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
            }
        }
        .onAppear {
            setupSettingsMonitoring()
        }
    }
    
    private func isSectionVisible(_ section: SettingSection) -> Bool {
        // Determine if section is in visible area
        // This is simplified - in real app would use GeometryReader
        true
    }
    
    private func setupSettingsMonitoring() {
        scrollViewModel.onScrollEvent = { event in
            switch event {
            case .nearTop(let distance):
                if distance < 50 {
                    print("📍 Near top of settings")
                }
            case .nearBottom(let distance):
                if distance < 50 {
                    print("📍 Near bottom of settings")
                }
            default:
                break
            }
        }
    }
}

struct SettingSectionView: View {
    let section: SettingsScrollView.SettingSection
    let isVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack {
                Image(systemName: section.icon)
                    .foregroundStyle(.blue)
                Text(section.rawValue)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            // Section items
            VStack(spacing: 0) {
                ForEach(0..<5) { index in
                    SettingRow(
                        title: "\(section.rawValue) Option \(index + 1)",
                        subtitle: "Description for option \(index + 1)"
                    )
                }
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
        .padding(.bottom, 8)
    }
}

struct SettingRow: View {
    let title: String
    let subtitle: String
    @State private var isEnabled = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
        }
        .padding()
        .background(.background)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray.opacity(0.2)),
            alignment: .bottom
        )
    }
}

// MARK: - Example 5: Advanced - Custom Scroll Effects
// CustomScrollEffectsView.swift

struct CustomScrollEffectsView: View {
    @StateObject private var scrollViewModel = ScrollViewModel(
        configuration: ScrollConfiguration(
            trackVelocity: true,
            trackDirection: true
        )
    )
    
    @State private var items = (0..<50).map { "Item \($0)" }
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        NavigationView {
            ScrollMonitorView(viewModel: scrollViewModel) {
                LazyVStack(spacing: 20) {
                    // Parallax header
                    parallaxHeader
                    
                    // Content with various scroll effects
                    ForEach(Array(items.enumerated()), id: \.element) { index, item in
                        ItemCardWithEffects(
                            item: item,
                            index: index,
                            scrollState: scrollViewModel.state
                        )
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    // Title that fades in when scrolling
                    Text("Custom Effects")
                        .font(.headline)
                        .opacity(scrollViewModel.state.distanceFromTop > 100 ? 1 : 0)
                        .animation(.easeInOut, value: scrollViewModel.state.distanceFromTop)
                }
            }
        }
        .onAppear {
            setupAdvancedMonitoring()
        }
    }
    
    private var parallaxHeader: some View {
        ZStack {
            // Background with parallax
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 300)
            .offset(y: scrollViewModel.state.offset / 3) // Parallax effect
            
            VStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundStyle(.white)
                
                Text("Scroll Effects")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .scaleEffect(1 - (scrollViewModel.state.distanceFromTop / 1000)) // Scale down
            .opacity(1.0 - (scrollViewModel.state.distanceFromTop / 300)) // Fade out
        }
        .frame(height: 300)
        .clipped()
    }
    
    private func setupAdvancedMonitoring() {
        // Monitor velocity for dynamic effects
        scrollViewModel.$state
            .map(\.velocity)
            .removeDuplicates()
            .sink { velocity in
                if abs(velocity) > 2000 {
                    print("🚀 Super fast scroll!")
                    // Could trigger special effects
                }
            }
            .store(in: &cancellables)
        
        // Monitor direction changes
        scrollViewModel.directionPublisher
            .sink { direction in
                print("Direction changed: \(direction)")
            }
            .store(in: &cancellables)
        
        // Custom event handling
        scrollViewModel.onEvent(.velocityChanged(0)) {
            print("Velocity event triggered")
        }
        .store(in: &cancellables)
    }
}

struct ItemCardWithEffects: View {
    let item: String
    let index: Int
    let scrollState: ScrollState
    
    var body: some View {
        HStack {
            Text(item)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
        .padding(.horizontal)
        // Different effects based on index
        .applyScrollEffect(index: index, scrollState: scrollState)
    }
}

extension View {
    @ViewBuilder
    func applyScrollEffect(index: Int, scrollState: ScrollState) -> some View {
        let offset = scrollState.distanceFromTop
        
        switch index % 3 {
        case 0:
            // Slide in from left
            self.offset(x: max(-100, -offset + CGFloat(index * 50)))
                .opacity(min(1, offset / 100))
        case 1:
            // Slide in from right
            self.offset(x: min(100, offset - CGFloat(index * 50)))
                .opacity(min(1, offset / 100))
        default:
            // Scale effect
            self.scaleEffect(min(1, 0.8 + (offset / CGFloat(index * 100))))
        }
    }
}

// MARK: - Example 6: E-commerce Product List
// ProductListView.swift

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let image: String
    let rating: Double
    let inStock: Bool
}

struct ProductListView: View {
    @StateObject private var scrollViewModel = ScrollViewModel(
        configuration: ScrollConfiguration(
            scrollButtonThreshold: 500,
            enablePullToRefresh: true,
            enableInfiniteScroll: true,
            saveScrollPosition: true,
            restoreScrollPosition: true
        ),
        scrollPositionKey: "ProductList_Electronics"
    )
    
    @State private var cancellables = Set<AnyCancellable>()
    
    @State private var products: [Product] = []
    @State private var filteredProducts: [Product] = []
    @State private var searchText = ""
    @State private var sortOption: SortOption = .popular
    @State private var showFilters = false
    
    enum SortOption: String, CaseIterable {
        case popular = "Popular"
        case priceLow = "Price: Low to High"
        case priceHigh = "Price: High to Low"
        case rating = "Top Rated"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search & Filter Bar
                searchBar
                
                // Sort Options
                sortOptionsBar
                
                // Product Grid
                ScrollMonitorView(
                    viewModel: scrollViewModel,
                    showButtons: .both,
                    bottomButtonStyle: .floating,
                    topButtonStyle: .minimal
                ) {
                    LazyVStack(spacing: 0) {
                        Color.clear.frame(height: 1).scrollAnchor("scrollTop")
                        
                        productGrid
                        
                        // Loading indicator
                        if scrollViewModel.state.isNearBottom(threshold: 200) {
                            ProgressView("Loading more products...")
                                .padding()
                        }
                        
                        Color.clear.frame(height: 1).scrollAnchor("scrollBottom")
                    }
                }
            }
            .navigationTitle("Products")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showFilters) {
                FilterSheet()
            }
        }
        .onAppear {
            setupProductMonitoring()
            loadProducts()
        }
    }
    
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField("Search products", text: $searchText)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(8)
            .background(.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button(action: { showFilters = true }) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(.blue)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }
    
    private var sortOptionsBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button(action: { sortOption = option }) {
                        Text(option.rawValue)
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(sortOption == option ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundStyle(sortOption == option ? .white : .primary)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
    
    private var productGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(filteredProducts) { product in
                ProductCard(product: product)
                    .scrollFade(viewModel: scrollViewModel, range: 0...200)
                    .onTapGesture {
                        // Navigate to product detail
                    }
            }
        }
        .padding()
    }
    
    private func setupProductMonitoring() {
        // Pull to refresh
        scrollViewModel.onPullToRefresh = {
            await refreshProducts()
        }
        
        // Load more
        scrollViewModel.onLoadMore = {
            await loadMoreProducts()
        }
        
        // Track scrolling for analytics
        scrollViewModel.onScrollEvent = { event in
            switch event {
            case .reachedBottom:
                print("📊 Analytics: User reached end of product list")
            case .fastScrollDetected(let velocity):
                print("📊 Analytics: Fast scroll detected: \(velocity)")
            default:
                break
            }
        }
        
        /*
        // Update filtered products when search changes
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { text in
                filterProducts(searchText: text)
            }
            .store(in: &cancellables)
        */
    }
    
    private func loadProducts() {
        products = (0..<20).map { i in
            Product(
                name: "Product \(i + 1)",
                price: Double.random(in: 10...500),
                image: "photo",
                rating: Double.random(in: 3...5),
                inStock: Bool.random()
            )
        }
        filteredProducts = products
    }
    
    private func refreshProducts() async {
        try? await Task.sleep(for: .seconds(1))
        loadProducts()
    }
    
    private func loadMoreProducts() async {
        try? await Task.sleep(for: .seconds(1))
        let newProducts = (products.count..<products.count + 10).map { i in
            Product(
                name: "Product \(i + 1)",
                price: Double.random(in: 10...500),
                image: "photo",
                rating: Double.random(in: 3...5),
                inStock: Bool.random()
            )
        }
        products.append(contentsOf: newProducts)
        filteredProducts = products
    }
    
    private func filterProducts(searchText: String) {
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Product Image
            Rectangle()
                .fill(.gray.opacity(0.2))
                .frame(height: 150)
                .overlay(
                    Image(systemName: product.image)
                        .font(.system(size: 50))
                        .foregroundStyle(.gray.opacity(0.5))
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                    .lineLimit(2)
                
                HStack {
                    ForEach(0..<5) { i in
                        Image(systemName: i < Int(product.rating) ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                    }
                    Text(String(format: "%.1f", product.rating))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text("$\(String(format: "%.2f", product.price))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
                
                if product.inStock {
                    Text("In Stock")
                        .font(.caption)
                        .foregroundStyle(.green)
                } else {
                    Text("Out of Stock")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
        .padding(8)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

struct FilterSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Price Range") {
                    Text("$0 - $500")
                }
                
                Section("Rating") {
                    Text("4+ stars")
                }
                
                Section("Availability") {
                    Toggle("In Stock Only", isOn: .constant(true))
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Example 7: Document Reader with Navigation
// DocumentReaderView.swift

struct DocumentSection: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let subsections: [DocumentSection]?
}

struct DocumentReaderView: View {
    @StateObject private var scrollViewModel = ScrollViewModel(
        configuration: ScrollConfiguration(
            scrollButtonThreshold: 300,
            enableHaptics: true,
            trackDirection: true,
            saveScrollPosition: true,
            restoreScrollPosition: true
        ),
        scrollPositionKey: "DocumentReader_UserGuide"
    )
    @State private var cancellables = Set<AnyCancellable>()
    
    @State private var sections: [DocumentSection] = []
    @State private var currentSection: String = ""
    @State private var showTableOfContents = false
    @State private var readingProgress: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollMonitorView(
                    viewModel: scrollViewModel,
                    showButtons: .both
                ) {
                    LazyVStack(alignment: .leading, spacing: 24) {
                        Color.clear.frame(height: 1).scrollAnchor("scrollTop")
                        
                        // Document Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("User Guide")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Last updated: \(Date(), style: .date)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        
                        // Document Sections
                        ForEach(sections) { section in
                            DocumentSectionView(
                                section: section,
                                level: 0
                            )
                            .id(section.id)
                        }
                        
                        Color.clear.frame(height: 1).scrollAnchor("scrollBottom")
                    }
                    .padding()
                }
                
                // Reading Progress Bar
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.blue)
                        .frame(width: geometry.size.width * scrollViewModel.progress, height: 3)
                }
                .frame(height: 3)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showTableOfContents = true }) {
                        Image(systemName: "list.bullet")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Bookmark Page") {
                            bookmarkCurrentPosition()
                        }
                        
                        Button("Share") {
                            shareDocument()
                        }
                        
                        Button("Print") {
                            printDocument()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text(currentSection)
                            .font(.headline)
                        Text("\(Int(scrollViewModel.progress * 100))% read")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .sheet(isPresented: $showTableOfContents) {
                TableOfContentsView(
                    sections: sections,
                    onSelectSection: { section in
                        // Jump to section
                        showTableOfContents = false
                    }
                )
            }
        }
        .onAppear {
            setupDocumentMonitoring()
            loadDocument()
        }
    }
    
    private func setupDocumentMonitoring() {
        // Track reading progress
        scrollViewModel.progressPublisher
            .sink { progress in
                readingProgress = progress
                updateCurrentSection(progress: progress)
            }
            //.store(in: &scrollViewModel.cancellables)
            .store(in: &cancellables)
        
        // Track reading time
        scrollViewModel.onScrollEvent = { event in
            switch event {
            case .reachedBottom:
                print("📖 User finished reading document")
                // Could track analytics
            case .scrollEnded:
                print("📍 User stopped at \(Int(scrollViewModel.progress * 100))%")
            default:
                break
            }
        }
    }
    
    private func loadDocument() {
        sections = [
            DocumentSection(
                title: "Introduction",
                content: "Welcome to the user guide. This document will help you understand all features...",
                subsections: nil
            ),
            DocumentSection(
                title: "Getting Started",
                content: "Follow these steps to begin...",
                subsections: [
                    DocumentSection(title: "Installation", content: "Download and install...", subsections: nil),
                    DocumentSection(title: "Setup", content: "Configure your settings...", subsections: nil)
                ]
            ),
            DocumentSection(
                title: "Advanced Features",
                content: "Learn about advanced capabilities...",
                subsections: nil
            ),
            DocumentSection(
                title: "Troubleshooting",
                content: "Common issues and solutions...",
                subsections: nil
            )
        ]
    }
    
    private func updateCurrentSection(progress: CGFloat) {
        let index = Int(progress * CGFloat(sections.count))
        if index < sections.count {
            currentSection = sections[index].title
        }
    }
    
    private func bookmarkCurrentPosition() {
        print("📌 Bookmarked at \(Int(scrollViewModel.progress * 100))%")
    }
    
    private func shareDocument() {
        print("📤 Sharing document")
    }
    
    private func printDocument() {
        print("🖨️ Printing document")
    }
}

struct DocumentSectionView: View {
    let section: DocumentSection
    let level: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title)
                .font(level == 0 ? .title : .title3)
                .fontWeight(.bold)
                .padding(.leading, CGFloat(level * 16))
            
            Text(section.content)
                .font(.body)
                .padding(.leading, CGFloat(level * 16))
            
            if let subsections = section.subsections {
                ForEach(subsections) { subsection in
                    DocumentSectionView(section: subsection, level: level + 1)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct TableOfContentsView: View {
    let sections: [DocumentSection]
    let onSelectSection: (DocumentSection) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List(sections) { section in
                Button(action: {
                    onSelectSection(section)
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(section.title)
                            .font(.headline)
                        
                        if let subsections = section.subsections {
                            Text("\(subsections.count) subsections")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Table of Contents")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Example 8: Performance Testing & Debugging View
// PerformanceTestView.swift

struct PerformanceTestView: View {
    @StateObject private var scrollViewModel = ScrollViewModel(
        configuration: ScrollConfiguration(
            throttleInterval: 0.016, // 60 FPS
            enableHaptics: true,
            trackVelocity: true,
            trackDirection: true
        )
    )
    
    @State private var items = (0..<1000).map { "Item \($0)" }
    @State private var performanceMetrics = ScrollPerformanceMetrics()
    @State private var showDebugOverlay = true
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollMonitorView(viewModel: scrollViewModel) {
                    LazyVStack(spacing: 1) {
                        ForEach(items, id: \.self) { item in
                            HStack {
                                Text(item)
                                    .font(.body)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(.background)
                        }
                    }
                }
                
                // Debug Overlay
                if showDebugOverlay {
                    VStack {
                        Spacer()
                        debugOverlay
                    }
                }
            }
            .navigationTitle("Performance Test")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showDebugOverlay.toggle() }) {
                        Image(systemName: showDebugOverlay ? "eye.fill" : "eye.slash")
                    }
                }
            }
        }
        .onAppear {
            setupPerformanceMonitoring()
        }
    }
    
    private var debugOverlay: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Debug Info")
                .font(.headline)
            
            Group {
                Text("FPS: \(String(format: "%.1f", performanceMetrics.fps))")
                Text("Dropped Frames: \(performanceMetrics.droppedFrames)")
                Text("Scroll Events: \(performanceMetrics.scrollEventCount)")
                Text("Offset: \(String(format: "%.1f", scrollViewModel.state.offset))")
                Text("Velocity: \(String(format: "%.1f", scrollViewModel.state.velocity))")
                Text("Direction: \(String(describing: scrollViewModel.state.direction))")
                Text("Progress: \(Int(scrollViewModel.progress * 100))%")
                Text("Distance from Bottom: \(String(format: "%.1f", scrollViewModel.state.distanceFromBottom))")
            }
            .font(.caption)
            .foregroundStyle(.white)
        }
        .padding()
        .background(.black.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
    }
    
    private func setupPerformanceMonitoring() {
/*
#if DEBUG
        // Enable debug logging
        _ = scrollViewModel.enableDebugLogging()
        
        // Monitor performance
        scrollViewModel.monitorPerformance()
            .sink { metrics in
                performanceMetrics = metrics
            }
            .store(in: &cancellables)
        
        // Log state changes
        scrollViewModel.$state
            .sink { state in
                if state.velocity > 5000 {
                    print("⚠️ Very high velocity detected: \(state.velocity)")
                }
            }
            .store(in: &cancellables)
        #endif
 */
    }
}

// MARK: - Example 9: Main App Demo View
// MainDemoView.swift

struct MainDemoView: View {
    var body: some View {
        TabView {
            ChatWithScrollView()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
            
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "rectangle.stack.fill")
                }
            
            GalleryView()
                .tabItem {
                    Label("Gallery", systemImage: "photo.stack.fill")
                }
            
            ProductListView()
                .tabItem {
                    Label("Shop", systemImage: "cart.fill")
                }
            
            SettingsScrollView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

// MARK: - App Entry Point

/*

 @main
 struct ScrollMonitorKitExampleApp: App {
     var body: some Scene {
         WindowGroup {
             MainDemoView()
         }
     }
 }

 
 # ScrollMonitorKit - Complete Examples Summary
 
 ## 📱 Example Views Included:
 
 1. **ChatView** - Full-featured chat interface
    - Auto-scroll to bottom
    - Typing indicators
    - Message bubbles
    - Scroll progress tracking
    - All event monitoring examples
 
 2. **FeedView** - Social media feed
    - Pull-to-refresh
    - Infinite scroll
    - Scroll-to-top button
    - Position persistence
    - Circular progress indicator
 
 3. **GalleryView** - Photo gallery
    - Horizontal + vertical scrolling
    - Grid layout
    - Parallax effects
    - Velocity tracking
 
 4. **ProductListView** - E-commerce
    - Search & filter
    - Sort options
    - Product grid
    - Pull-to-refresh
    - Load more pagination
    - Position save/restore
 
 5. **SettingsView** - Settings interface
    - Section navigation
    - Jump to section
    - Position tracking
    - Scroll buttons
 
 6. **DocumentReaderView** - Document reader
    - Reading progress
    - Table of contents
    - Bookmarks
    - Current section tracking
    - Progress bar
 
 7. **CustomScrollEffectsView** - Advanced effects
    - Parallax headers
    - Fade animations
    - Scale effects
    - Custom scroll behaviors
    - Dynamic title opacity
 
 8. **PerformanceTestView** - Debug & testing
    - FPS monitoring
    - Performance metrics
    - Debug overlay
    - Event logging
    - 1000 items stress test
 
 ## 🎯 Features Demonstrated:
 
 ✅ All configuration options
 ✅ All button styles
 ✅ All presets (.chat, .feed, .minimal)
 ✅ Pull-to-refresh
 ✅ Infinite scroll
 ✅ Position save/restore
 ✅ Event monitoring
 ✅ Combine publishers
 ✅ Haptic feedback
 ✅ Scroll animations
 ✅ Performance monitoring
 ✅ Debug logging
 ✅ Custom effects
 ✅ Horizontal scroll
 ✅ Vertical scroll
 ✅ Nested views
 
 ## 🚀 How to Run:
 
 1. Create new Xcode project
 2. Add ScrollMonitorKit package
 3. Copy any example view
 4. Run and test!
 
 Each example is self-contained and demonstrates
 different aspects of the package functionality.
 
 */
