//
//  PlaygroundView.swift
//  SportsDB
//
//  Created by Macbook on 15/11/25.
//

// PlaygroundView.swift - Test Different Configurations

import SwiftUI
import AIManageKit

/*
struct PlaygroundView: View {
    @Environment(AIManager.self) private var aiManager
    
    @State private var prompt = ""
    @State private var response = ""
    @State private var isLoading = false
    @State private var tokenCount: Int?
    
    // Configuration states
    @State private var selectedModel: AIModelType = .gemini25Flash
    @State private var temperature: Float = 1.0
    @State private var maxTokens: Int = 2048
    @State private var useStreaming = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Configuration Panel
                    configurationPanel
                    
                    // Prompt Input
                    promptSection
                    
                    // Response Output
                    responseSection
                    
                    // Statistics
                    if let tokenCount = tokenCount {
                        statisticsSection(tokens: tokenCount)
                    }
                }
                .padding()
            }
            .navigationTitle("Playground")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: clearAll) {
                        Image(systemName: "trash")
                    }
                    .disabled(response.isEmpty && prompt.isEmpty)
                }
            }
        }
    }
    
    private var configurationPanel: some View {
        VStack(spacing: 16) {
            Text("Configuration")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Model Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("Model")
                    .font(.subheadline.bold())
                
                Picker("Model", selection: $selectedModel) {
                    ForEach(AIModelType.allPredefined, id: \.identifier) { model in
                        Text(model.displayName).tag(model)
                    }
                }
                .pickerStyle(.menu)
            }
            
            // Temperature
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Temperature")
                        .font(.subheadline.bold())
                    Spacer()
                    Text(String(format: "%.2f", temperature))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Slider(value: $temperature, in: 0...2, step: 0.1)
                
                HStack {
                    Text("Precise")
                        .font(.caption2)
                    Spacer()
                    Text("Creative")
                        .font(.caption2)
                }
                .foregroundStyle(.secondary)
            }
            
            // Max Tokens
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Max Output Tokens")
                        .font(.subheadline.bold())
                    Spacer()
                    Text("\(maxTokens)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Slider(value: Binding(
                    get: { Double(maxTokens) },
                    set: { maxTokens = Int($0) }
                ), in: 256...8192, step: 256)
            }
            
            // Streaming Toggle
            Toggle("Stream Response", isOn: $useStreaming)
                .font(.subheadline.bold())
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var promptSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Prompt")
                    .font(.headline)
                
                Spacer()
                
                if !prompt.isEmpty {
                    Button(action: countPromptTokens) {
                        HStack(spacing: 4) {
                            Image(systemName: "number")
                            Text("Count Tokens")
                        }
                        .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
            
            TextEditor(text: $prompt)
                .frame(minHeight: 120)
                .padding(8)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
            
            Button(action: generateResponse) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .controlSize(.small)
                            .tint(.white)
                    }
                    Text(isLoading ? "Generating..." : "Generate Response")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(prompt.isEmpty || isLoading ? Color.gray : Color.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(prompt.isEmpty || isLoading)
        }
    }
    
    private var responseSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Response")
                    .font(.headline)
                
                Spacer()
                
                if !response.isEmpty {
                    Button(action: copyResponse) {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.on.doc")
                            Text("Copy")
                        }
                        .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
            
            if response.isEmpty {
                Text("Response will appear here...")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(40)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            } else {
                ScrollView {
                    Text(response)
                        .font(.body)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .frame(minHeight: 200)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    private func statisticsSection(tokens: Int) -> some View {
        VStack(spacing: 12) {
            Text("Statistics")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                StatCard(
                    icon: "number",
                    title: "Prompt Tokens",
                    value: "\(tokens)"
                )
                
                StatCard(
                    icon: "text.alignleft",
                    title: "Response Length",
                    value: "\(response.count)"
                )
                
                StatCard(
                    icon: "brain.head.profile",
                    title: "Model",
                    value: selectedModel.displayName,
                    compact: true
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private func generateResponse() {
        guard !prompt.isEmpty else { return }
        
        isLoading = true
        response = ""
        tokenCount = nil
        
        let config = AIConfiguration(
            model: selectedModel,
            temperature: temperature,
            maxOutputTokens: maxTokens
        )
        
        Task {
            do {
                if useStreaming {
                    let stream = try await aiManager.sendStreamingRequest(
                        prompt: prompt,
                        configuration: config
                    )
                    
                    for try await chunk in stream {
                        response += chunk
                    }
                } else {
                    let result = try await aiManager.sendRequest(
                        prompt: prompt,
                        configuration: config
                    )
                    response = result.text
                }
            } catch {
                response = "Error: \(error.localizedDescription)"
            }
            
            isLoading = false
        }
    }
    
    private func countPromptTokens() {
        Task {
            do {
                let count = try await aiManager.countTokens(for: prompt)
                tokenCount = count
            } catch {
                print("Token count error: \(error)")
            }
        }
    }
    
    private func copyResponse() {
        UIPasteboard.general.string = response
    }
    
    private func clearAll() {
        prompt = ""
        response = ""
        tokenCount = nil
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    var compact: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(compact ? .body : .title2)
                .foregroundStyle(.blue)
            
            if !compact {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(value)
                .font(compact ? .caption : .headline)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}
*/
