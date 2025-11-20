//
//  MessageBubble.swift
//  SportsDB
//
//  Created by Macbook on 19/11/25.
//
import SwiftUI
import MarkdownTypingKit
// MARK: - Message Bubble
struct MessageBubble: View {
    let message: ChatMessage
    let isStreaming: Bool
    
    //@State private var isTypingComplete: Bool = true
    @Binding var isTypingComplete: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if message.role == .user {
                Spacer(minLength: 50)
            }
            
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 6) {
                messageHeader
                messageContent
                messageFooter
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
    
    @ViewBuilder
    private var messageHeader: some View {
        HStack(spacing: 6) {
            if message.role == .assistant {
                Image(systemName: "sparkles")
                    .font(.caption2)
                    .foregroundStyle(.blue)
            }
            
            Text(message.role == .user ? "You" : "AI Assistant")
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
            
            if isStreaming {
                ProgressView()
                    .scaleEffect(0.6)
                    .tint(.blue)
            }
        }
    }
    
    @ViewBuilder
    private var messageContent: some View {
        Group {
            
            if message.role == .user {
                Text(message.content)
                    .font(.body)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.blue)
                            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .foregroundStyle(.white)
            } else {
                
                
                MarkdownTypewriterView(text: .constant(message.content), isTypingComplete: $isTypingComplete)
                    .typingSpeed(.fast)
                    .autoScroll(false)
                
                //Text(message.content)
                    .font(.body)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color(.systemGray6))
                            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                    )
                    .foregroundStyle(.primary)
            }
            
            if !isTypingComplete {
                Text("Typing")
            }
        }
    }
    
    @ViewBuilder
    private var messageFooter: some View {
        HStack(spacing: 4) {
            Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                .font(.caption2)
                .foregroundStyle(.tertiary)
            
            if message.role == .user {
                Image(systemName: "checkmark.circle.fill")
                    .font(.caption2)
                    .foregroundStyle(.blue.opacity(0.6))
            }
        }
    }
    
    private func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
