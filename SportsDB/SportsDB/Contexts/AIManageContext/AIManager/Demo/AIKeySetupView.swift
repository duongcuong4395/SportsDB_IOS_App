//
//  AIKeySetupView.swift
//  SportsDB
//
//  Created by Macbook on 15/11/25.
//

// Sources/AIManageKit/UI/SwiftUI/AIKeyManagementView.swift

import SwiftUI
import AIManageKit

// MARK: - AI Key Setup View
public struct AIKeySetupView: View {
    @State private var aiManager: AIManager
    @State private var keyInput: String = ""
    @State private var showError = false
    @State private var isValidating = false
    
    private let onComplete: () -> Void
    
    public init(
        aiManager: AIManager,
        onComplete: @escaping () -> Void = {}
    ) {
        self.aiManager = aiManager
        self.onComplete = onComplete
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue.gradient)
                
                Text("AI Setup")
                    .font(.title.bold())
                
                Text("Enter your Gemini API key to continue")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            // Key Input
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "key.fill")
                        .foregroundStyle(.blue)
                    
                    SecureField("API Key", text: $keyInput)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    if isValidating {
                        ProgressView()
                            .controlSize(.small)
                    }
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                
                if showError, let error = aiManager.lastError {
                    Label(error.localizedDescription, systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)
            
            // Action Button
            Button(action: validateAndSave) {
                HStack {
                    if isValidating {
                        ProgressView()
                            .controlSize(.small)
                            .tint(.white)
                    }
                    Text(isValidating ? "Validating..." : "Continue")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(keyInput.isEmpty ? Color.gray : Color.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(keyInput.isEmpty || isValidating)
            .padding(.horizontal)
            
            // Help Section
            VStack(alignment: .leading, spacing: 12) {
                Text("How to get your API key:")
                    .font(.caption.bold())
                
                Link(destination: URL(string: "https://aistudio.google.com/app/apikey")!) {
                    HStack {
                        Image(systemName: "link.circle.fill")
                        Text("Get API Key from Google AI Studio")
                            .font(.caption)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("• Your key is stored securely in Keychain")
                    Text("• Key is never shared with third parties")
                    Text("• You can delete it anytime")
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            
            Spacer()
        }
        .onChange(of: aiManager.keyStatus) { _, newStatus in
            if newStatus == .valid {
                onComplete()
            }
        }
    }
    
    private func validateAndSave() {
        isValidating = true
        showError = false
        
        Task {
            do {
                try await aiManager.setAPIKey(keyInput)
                keyInput = ""
            } catch {
                showError = true
            }
            isValidating = false
        }
    }
}

// MARK: - AI Key Management View (Settings)
public struct AIKeyManagementView: View {
    @State private var aiManager: AIManager
    @State private var showDeleteAlert = false
    @State private var showChangeKeySheet = false
    
    public init(aiManager: AIManager) {
        self.aiManager = aiManager
    }
    
    public var body: some View {
        List {
            Section {
                HStack {
                    Label("Status", systemImage: statusIcon)
                        .foregroundStyle(statusColor)
                    
                    Spacer()
                    
                    Text(statusText)
                        .foregroundStyle(.secondary)
                }
            }
            
            Section {
                Button(action: { showChangeKeySheet = true }) {
                    Label("Change API Key", systemImage: "key.horizontal.fill")
                }
                
                Button(role: .destructive, action: { showDeleteAlert = true }) {
                    Label("Delete API Key", systemImage: "trash.fill")
                }
            }
            
            Section {
                Link(destination: URL(string: "https://aistudio.google.com/app/apikey")!) {
                    Label("Get New API Key", systemImage: "link.circle.fill")
                }
                
                Link(destination: URL(string: "https://ai.google.dev/gemini-api/docs")!) {
                    Label("API Documentation", systemImage: "book.fill")
                }
            } header: {
                Text("Resources")
            }
        }
        .navigationTitle("AI Configuration")
        .alert("Delete API Key?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    try? await aiManager.deleteAPIKey()
                }
            }
        } message: {
            Text("This will remove your API key from the device. You'll need to add it again to use AI features.")
        }
        .sheet(isPresented: $showChangeKeySheet) {
            NavigationStack {
                AIKeySetupView(aiManager: aiManager) {
                    showChangeKeySheet = false
                }
                .navigationTitle("Change API Key")
                //.navigationBarTitleDisplayMode(.inline)
                
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showChangeKeySheet = false
                        }
                    }
                }
            }
        }
    }
    
    private var statusIcon: String {
        switch aiManager.keyStatus {
        case .valid: return "checkmark.circle.fill"
        case .invalid: return "xmark.circle.fill"
        case .validating: return "hourglass.circle.fill"
        case .notConfigured: return "exclamationmark.circle.fill"
        }
    }
    
    private var statusColor: Color {
        switch aiManager.keyStatus {
        case .valid: return .green
        case .invalid: return .red
        case .validating: return .orange
        case .notConfigured: return .gray
        }
    }
    
    private var statusText: String {
        switch aiManager.keyStatus {
        case .valid: return "Active"
        case .invalid: return "Invalid"
        case .validating: return "Validating..."
        case .notConfigured: return "Not Configured"
        }
    }
}

/*
// MARK: - Preview
#Preview("Setup") {
    AIKeySetupView(
        aiManager: AIManager(
            storage: MockAIStorage(),
            service: GeminiAIService()
        )
    )
}
 */

/*
#Preview("Management") {
    NavigationStack {
        AIKeyManagementView(
            aiManager: AIManager(
                storage: MockAIStorage(initialKey: "test-key"),
                service: GeminiAIService()
            )
        )
    }
}
*/
