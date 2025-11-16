//
//  SettingsView.swift
//  SportsDB
//
//  Created by Macbook on 15/11/25.
//

// SettingsView.swift - Complete Settings Interface

import SwiftUI
import AIManageKit

struct SettingsView: View {
    @Environment(AIManager.self) private var aiManager
    @State private var showModelPicker = false
    @State private var showAbout = false
    
    var body: some View {
        NavigationStack {
            List {
                // Status Section
                statusSection
                
                // Model Configuration
                modelSection
                
                // API Key Management
                apiKeySection
                
                // Advanced Settings
                advancedSection
                
                // About
                aboutSection
            }
            .navigationTitle("Settings")
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
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
        }
    }
    
    private var statusSection: some View {
        Section {
            HStack {
                Label("Status", systemImage: statusIcon)
                    .foregroundStyle(statusColor)
                
                Spacer()
                
                Text(statusText)
                    .foregroundStyle(.secondary)
            }
            
            if aiManager.isLoading {
                HStack {
                    ProgressView()
                        .controlSize(.small)
                    Text("Processing...")
                        .foregroundStyle(.secondary)
                }
            }
            
            if let error = aiManager.lastError {
                VStack(alignment: .leading, spacing: 4) {
                    Label("Last Error", systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        } header: {
            Text("System Status")
        }
    }
    
    private var modelSection: some View {
        Section {
            Button(action: { showModelPicker = true }) {
                HStack {
                    Label("Current Model", systemImage: "brain.head.profile")
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(aiManager.configuration.model.displayName)
                        if let description = aiManager.configuration.model.description {
                            Text(description)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            NavigationLink(destination: ConfigurationDetailView()) {
                Label("Configuration", systemImage: "slider.horizontal.3")
            }
        } header: {
            Text("AI Model")
        } footer: {
            Text("Current model: \(aiManager.configuration.model.identifier)")
                .font(.caption2)
        }
    }
    
    private var apiKeySection: some View {
        Section {
            NavigationLink(destination: AIKeyManagementView(aiManager: aiManager)) {
                Label("Manage API Key", systemImage: "key.horizontal.fill")
            }
            
            Button(action: testConnection) {
                Label("Test Connection", systemImage: "network")
            }
            .disabled(aiManager.keyStatus != .valid)
        } header: {
            Text("API Key")
        }
    }
    
    private var advancedSection: some View {
        Section {
            NavigationLink(destination: UsageStatsView()) {
                Label("Usage Statistics", systemImage: "chart.bar.fill")
            }
            
            NavigationLink(destination: ExportDataView()) {
                Label("Export Settings", systemImage: "square.and.arrow.up")
            }
            
            Button(role: .destructive, action: clearCache) {
                Label("Clear Cache", systemImage: "trash")
            }
        } header: {
            Text("Advanced")
        }
    }
    
    private var aboutSection: some View {
        Section {
            Button(action: { showAbout = true }) {
                Label("About AIManageKit", systemImage: "info.circle")
            }
            
            Link(destination: URL(string: "https://ai.google.dev/gemini-api/docs")!) {
                Label("Documentation", systemImage: "book.fill")
            }
            
            Link(destination: URL(string: "https://github.com/yourusername/AIManageKit")!) {
                Label("GitHub Repository", systemImage: "chevron.left.forwardslash.chevron.right")
            }
        } header: {
            Text("About")
        }
    }
    
    // MARK: - Helpers
    
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
        case .valid: return "Connected"
        case .invalid: return "Invalid Key"
        case .validating: return "Validating..."
        case .notConfigured: return "Not Configured"
        }
    }
    
    private func testConnection() {
        Task {
            do {
                _ = try await aiManager.quickSend("Hello")
                // Show success alert
            } catch {
                // Show error alert
            }
        }
    }
    
    private func clearCache() {
        // Implementation
    }
}

// MARK: - Configuration Detail View
struct ConfigurationDetailView: View {
    @Environment(AIManager.self) private var aiManager
    @State private var temperature: Float
    @State private var maxTokens: Int
    @State private var timeout: Double
    
    init() {
        let config = AIConfiguration.default
        _temperature = State(initialValue: config.temperature)
        _maxTokens = State(initialValue: config.maxOutputTokens)
        _timeout = State(initialValue: config.timeout)
    }
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Temperature")
                            .font(.subheadline.bold())
                        Spacer()
                        Text(String(format: "%.2f", temperature))
                            .foregroundStyle(.secondary)
                    }
                    
                    Slider(value: $temperature, in: 0...2, step: 0.1)
                    
                    HStack {
                        Text("More Precise")
                            .font(.caption2)
                        Spacer()
                        Text("More Creative")
                            .font(.caption2)
                    }
                    .foregroundStyle(.secondary)
                }
            } header: {
                Text("Creativity")
            } footer: {
                Text("Controls randomness in responses. Lower = more deterministic, Higher = more creative.")
            }
            
            Section {
                Stepper(value: $maxTokens, in: 256...32768, step: 256) {
                    HStack {
                        Text("Max Output Tokens")
                        Spacer()
                        Text("\(maxTokens)")
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Output Length")
            } footer: {
                Text("Maximum number of tokens in the response.")
            }
            
            Section {
                Stepper(value: $timeout, in: 10...120, step: 5) {
                    HStack {
                        Text("Request Timeout")
                        Spacer()
                        Text("\(Int(timeout))s")
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Network")
            } footer: {
                Text("Maximum time to wait for a response.")
            }
            
            Section {
                Button("Apply Changes") {
                    applyConfiguration()
                }
                .frame(maxWidth: .infinity)
                
                Button("Reset to Defaults", role: .destructive) {
                    resetToDefaults()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Configuration")
    }
    
    private func applyConfiguration() {
        let newConfig = AIConfiguration(
            model: aiManager.configuration.model,
            temperature: temperature,
            maxOutputTokens: maxTokens,
            timeout: timeout
        )
        aiManager.updateConfiguration(newConfig)
    }
    
    private func resetToDefaults() {
        let defaultConfig = AIConfiguration.default
        temperature = defaultConfig.temperature
        maxTokens = defaultConfig.maxOutputTokens
        timeout = defaultConfig.timeout
    }
}

// MARK: - About View
struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 80))
                        .foregroundStyle(.blue.gradient)
                    
                    Text("AIManageKit")
                        .font(.title.bold())
                    
                    Text("Version 1.0.0")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    VStack(spacing: 16) {
                        InfoRow(icon: "checkmark.circle.fill", title: "Clean Architecture")
                        InfoRow(icon: "lock.fill", title: "Secure Storage")
                        InfoRow(icon: "arrow.triangle.branch", title: "Type-Safe")
                        InfoRow(icon: "bolt.fill", title: "High Performance")
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    
                    Text("A modern, production-ready Swift package for managing Google Gemini AI integration with clean architecture, type safety, and secure storage.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.blue)
            Text(title)
            Spacer()
        }
    }
}

// MARK: - Usage Stats View (Placeholder)
struct UsageStatsView: View {
    var body: some View {
        List {
            Section("Today") {
                StatRow(title: "Requests", value: "42")
                StatRow(title: "Tokens Used", value: "1,250")
                StatRow(title: "Images Analyzed", value: "5")
            }
            
            Section("This Week") {
                StatRow(title: "Total Requests", value: "287")
                StatRow(title: "Total Tokens", value: "8,940")
                StatRow(title: "Average Response Time", value: "1.2s")
            }
        }
        .navigationTitle("Usage Statistics")
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Export Data View (Placeholder)
struct ExportDataView: View {
    var body: some View {
        List {
            Button("Export Configuration") {}
            Button("Export Chat History") {}
            Button("Export Usage Stats") {}
        }
        .navigationTitle("Export Data")
    }
}

/*
// MARK: - Preview
#Preview {
    SettingsView()
        .environment(AIManager(
            storage: MockAIStorage(initialKey: "test"),
            service: GeminiAIService()
        ))
}
*/
