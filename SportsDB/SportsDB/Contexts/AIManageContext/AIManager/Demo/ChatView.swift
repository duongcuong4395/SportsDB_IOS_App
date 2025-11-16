//
//  ChatView.swift
//  SportsDB
//
//  Created by Macbook on 15/11/25.
//

// ChatView.swift - Advanced Chat Interface

import SwiftUI
import AIManageKit

struct ChatView: View {
    @Environment(AIManager.self) private var aiManager
    @State private var messages: [ChatMessage] = []
    @State private var inputText = ""
    @State private var isStreaming = false
    @State private var currentStreamingMessage: String = ""
    @State private var showModelPicker = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Model Selector Header
                modelSelectorHeader
                
                Divider()
                
                // Messages List
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                            
                            // Streaming message
                            if isStreaming && !currentStreamingMessage.isEmpty {
                                MessageBubble(
                                    message: ChatMessage(
                                        role: .assistant,
                                        content: currentStreamingMessage,
                                        model: aiManager.configuration.model
                                    )
                                )
                                .id("streaming")
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _, _ in
                        withAnimation {
                            proxy.scrollTo(messages.last?.id.uuidString ?? "streaming", anchor: .bottom)
                        }
                    }
                    .onChange(of: currentStreamingMessage) { _, _ in
                        withAnimation {
                            proxy.scrollTo("streaming", anchor: .bottom)
                        }
                    }
                }
                
                Divider()
                
                // Input Bar
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
    
    private func sendMessage() {
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
                    currentStreamingMessage += chunk
                }
                
                // Save completed message
                let assistantMessage = ChatMessage(
                    role: .assistant,
                    content: currentStreamingMessage,
                    model: aiManager.configuration.model
                )
                messages.append(assistantMessage)
                currentStreamingMessage = ""
                
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
        messages.removeAll()
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

// MARK: - Chat Message Model
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
}

// MARK: - Message Bubble
struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if message.role == .user {
                Spacer(minLength: 50)
            }
            
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                HStack(spacing: 6) {
                    if message.role == .assistant {
                        Image(systemName: "brain.head.profile")
                            .font(.caption2)
                            .foregroundStyle(.blue)
                    }
                    
                    Text(message.role == .user ? "You" : "AI")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    
                    if let model = message.model {
                        Text("•")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                        Text(model.displayName)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
                
                Text(message.content)
                    .font(.body)
                    .padding(12)
                    .background(
                        backgroundColor,
                        in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                    )
                    .foregroundStyle(textColor)
                
                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            
            if message.role != .user {
                Spacer(minLength: 50)
            }
        }
        .contextMenu {
            Button(action: { copyToClipboard(message.content) }) {
                Label("Copy", systemImage: "doc.on.doc")
            }
        }
    }
    
    private var backgroundColor: Color {
        switch message.role {
        case .user:
            return .blue
        case .assistant:
            return Color(.systemGray6)
        case .system:
            return Color(.systemRed).opacity(0.1)
        }
    }
    
    private var textColor: Color {
        message.role == .user ? .white : .primary
    }
    
    private func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
    }
}

/*
// MARK: - Preview
#Preview {
    NavigationStack {
        ChatView()
            .environment(AIManager(
                storage: MockAIStorage(initialKey: "test"),
                service: GeminiAIService()
            ))
    }
}
*/
