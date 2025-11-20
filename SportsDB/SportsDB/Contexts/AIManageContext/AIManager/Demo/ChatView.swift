//
//  ChatView.swift
//  SportsDB
//
//  Created by Macbook on 15/11/25.
//

//
//  ChatView.swift
//  SportsDB
//
//  Created by Macbook on 15/11/25.
//

import SwiftUI
import AIManageKit
import MarkdownTypingKit

struct ChatView: View {
    @Environment(AIManager.self) private var aiManager
    @State private var messages: [ChatMessage] = []
    @State private var inputText = ""
    @State private var isStreaming = false
    @State private var currentStreamingMessage: String = ""
    @State private var showModelPicker = false
    @State private var showScrollToBottomButton = false
    @State private var isUserScrolling = false
    @State private var isTypingComplete: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                modelSelectorHeader
                Divider()
                if showScrollToBottomButton {
                    Text("move to bottom")
                }
                ScrollViewReader { proxy in
                    ZStack(alignment: .bottomTrailing) {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(messages) { message in
                                    MessageBubble(
                                        message: message,
                                        isStreaming: false
                                        , isTypingComplete: $isTypingComplete
                                    )
                                    .id(message.id)
                                }
                                
                                if !isTypingComplete {
                                    if isStreaming && !currentStreamingMessage.isEmpty {
                                        MessageBubble(
                                            message: ChatMessage(
                                                role: .assistant,
                                                content: currentStreamingMessage,
                                                model: aiManager.configuration.model
                                            ),
                                            isStreaming: true
                                            , isTypingComplete: $isTypingComplete
                                        )
                                        .id("streaming")
                                    }
                                    
                                }
                                
                                /*
                                if isStreaming && !currentStreamingMessage.isEmpty {
                                    MessageBubble(
                                        message: ChatMessage(
                                            role: .assistant,
                                            content: currentStreamingMessage,
                                            model: aiManager.configuration.model
                                        ),
                                        isStreaming: true
                                    )
                                    .id("streaming")
                                }
                                */
                                
                                Color.clear
                                    .frame(height: 1)
                                    .id("bottom")
                            }
                            .padding()
                        }
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: ScrollPositionPreferenceKey.self,
                                    value: geo.frame(in: .named("scrollView")).minY
                                )
                            }
                        )
                        .coordinateSpace(name: "scrollView")
                        .onPreferenceChange(ScrollPositionPreferenceKey.self) { value in
                            handleScrollPosition(value)
                        }
                        .defaultScrollAnchor(.top)
                        .onChange(of: messages.count) { _, _ in
                            if !isUserScrolling {
                                scrollToBottom(proxy: proxy, animated: true)
                            }
                        }
                        .onChange(of: currentStreamingMessage) { _, _ in
                            if isStreaming && !isUserScrolling {
                                scrollToBottom(proxy: proxy, animated: false)
                            }
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                scrollToBottom(proxy: proxy, animated: false)
                            }
                        }
                        
                        if showScrollToBottomButton {
                            ScrollToBottomButton {
                                isUserScrolling = false
                                scrollToBottom(proxy: proxy, animated: true)
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.8).combined(with: .opacity),
                                removal: .scale(scale: 0.8).combined(with: .opacity)
                            ))
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showScrollToBottomButton)
                        }
                    }
                }
                
                Divider()
                inputBar
            }
            .navigationTitle("AI Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: clearChat) {
                            Label("Clear Chat", systemImage: "trash")
                        }
                        Button(action: exportChat) {
                            Label("Export Chat", systemImage: "square.and.arrow.up")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showModelPicker) {
                NavigationStack {
                    AIModelPickerView(aiManager: aiManager)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    showModelPicker = false
                                }
                            }
                        }
                }
            }
        }
    }
    
    private var modelSelectorHeader: some View {
        Button(action: { showModelPicker = true }) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(aiManager.configuration.model.displayName)
                        .font(.headline)
                    Text("Tap to change model")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .buttonStyle(.plain)
    }
    
    private var inputBar: some View {
        HStack(spacing: 12) {
            TextField("Message AI...", text: $inputText, axis: .vertical)
                .textFieldStyle(.plain)
                .lineLimit(1...6)
                .padding(12)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                .disabled(isStreaming)
            
            Button(action: sendMessage) {
                Image(systemName: isStreaming ? "stop.circle.fill" : "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(isStreaming ? .red : (inputText.isEmpty ? .gray : .blue))
            }
            .disabled(inputText.isEmpty && !isStreaming)
        }
        .padding()
    }
    
    private func handleScrollPosition(_ offset: CGFloat) {
        let threshold: CGFloat = -150
        let shouldShow = offset < threshold
        
        if shouldShow != showScrollToBottomButton {
            withAnimation(.easeInOut(duration: 0.25)) {
                showScrollToBottomButton = shouldShow
                isUserScrolling = shouldShow
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy, animated: Bool = true) {
        let targetId = isStreaming && !currentStreamingMessage.isEmpty ? "streaming" : "bottom"
        
        if animated {
            withAnimation(.easeOut(duration: 0.3)) {
                proxy.scrollTo(targetId, anchor: .bottom)
            }
        } else {
            proxy.scrollTo(targetId, anchor: .bottom)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            isUserScrolling = false
        }
    }
    
    private func sendMessage() {
        guard !isStreaming else {
            isStreaming = false
            
            if !currentStreamingMessage.isEmpty {
                let assistantMessage = ChatMessage(
                    role: .assistant,
                    content: currentStreamingMessage,
                    model: aiManager.configuration.model
                )
                messages.append(assistantMessage)
                currentStreamingMessage = ""
            }
            return
        }
        
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(role: .user, content: inputText)
        messages.append(userMessage)
        
        let prompt = inputText
        inputText = ""
        isStreaming = true
        currentStreamingMessage = ""
        
        Task {
            do {
                let stream = try await aiManager.quickStream(prompt)
                
                for try await chunk in stream {
                    guard isStreaming else { break }
                    currentStreamingMessage += chunk
                }
                
                if isStreaming {
                    let assistantMessage = ChatMessage(
                        role: .assistant,
                        content: currentStreamingMessage,
                        model: aiManager.configuration.model
                    )
                    messages.append(assistantMessage)
                    currentStreamingMessage = ""
                }
                
                /*
                if isTypingComplete {
                    let assistantMessage = ChatMessage(
                        role: .assistant,
                        content: currentStreamingMessage,
                        model: aiManager.configuration.model
                    )
                    messages.append(assistantMessage)
                    currentStreamingMessage = ""
                }
                */
            } catch {
                let errorMessage = ChatMessage(
                    role: .system,
                    content: "Error: \(error.localizedDescription)"
                )
                messages.append(errorMessage)
            }
            
            isStreaming = false
        }
    }
    
    private func clearChat() {
        withAnimation {
            messages.removeAll()
            currentStreamingMessage = ""
            isStreaming = false
            showScrollToBottomButton = false
            isUserScrolling = false
        }
    }
    
    private func exportChat() {
        let chatText = messages.map { message in
            "[\(message.role.rawValue.uppercased())] \(message.content)"
        }.joined(separator: "\n\n")
        
        let activityVC = UIActivityViewController(
            activityItems: [chatText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - Models
struct ChatMessage: Identifiable {
    let id = UUID()
    let role: Role
    let content: String
    let timestamp = Date()
    let model: AIModelType?
    
    enum Role: String {
        case user
        case assistant
        case system
    }
    
    init(role: Role, content: String, model: AIModelType? = nil) {
        self.role = role
        self.content = content
        self.model = model
    }
    
    static let sampleMessages: [ChatMessage] = [
        .init(role: .user, content: "Hey! How are you?"),
        .init(role: .system, content: "I'm doing great! How about you?"),
        .init(role: .user, content: "Pretty good! Working on a new SwiftUI project."),
        .init(role: .user, content: "Hey! How are you?"),
        .init(role: .system, content: "I'm doing great! How about you?"),
        .init(role: .user, content: "Hey! How are you?"),
        .init(role: .system, content: "I'm doing great! How about you?"),
        .init(role: .user, content: "Hey! How are you?"),
        .init(role: .system, content: "I'm doing great! How about you?")
    ]
}



// MARK: - Scroll To Bottom Button
struct ScrollToBottomButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action()
        }) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 48, height: 48)
                    .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
                    .overlay(
                        Circle()
                            .stroke(.blue.opacity(0.3), lineWidth: 1.5)
                    )
                
                Image(systemName: "arrow.down")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}

// MARK: - Preference Key
struct ScrollPositionPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
