//
//  ImageAnalysisView.swift
//  SportsDB
//
//  Created by Macbook on 15/11/25.
//

// ImageAnalysisView.swift - Vision Analysis Demo

import SwiftUI
import PhotosUI
import AIManageKit

struct ImageAnalysisView: View {
    @Environment(AIManager.self) private var aiManager
    
    @State private var selectedImage: UIImage?
    @State private var photoItem: PhotosPickerItem?
    @State private var prompt = "Describe this image in detail"
    @State private var response = ""
    @State private var isAnalyzing = false
    @State private var showCamera = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Image Selection
                    imageSelectionSection
                    
                    // Quick Prompts
                    if selectedImage != nil {
                        quickPromptsSection
                    }
                    
                    // Custom Prompt
                    if selectedImage != nil {
                        customPromptSection
                    }
                    
                    // Response
                    if !response.isEmpty {
                        responseSection
                    }
                }
                .padding()
            }
            .navigationTitle("Vision Analysis")
            .sheet(isPresented: $showCamera) {
                CameraView { image in
                    selectedImage = image
                    showCamera = false
                }
            }
        }
    }
    
    private var imageSelectionSection: some View {
        VStack(spacing: 16) {
            if let image = selectedImage {
                // Selected Image
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                    )
                    .contextMenu {
                        Button(role: .destructive, action: { selectedImage = nil }) {
                            Label("Remove Image", systemImage: "trash")
                        }
                    }
            } else {
                // Image Picker Buttons
                VStack(spacing: 16) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue.opacity(0.5))
                    
                    Text("Select an image to analyze")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 12) {
                        PhotosPicker(selection: $photoItem, matching: .images) {
                            Label("Photo Library", systemImage: "photo.on.rectangle")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        Button(action: { showCamera = true }) {
                            Label("Camera", systemImage: "camera.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(40)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
        }
        .onChange(of: photoItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                    response = "" // Clear previous response
                }
            }
        }
    }
    
    private var quickPromptsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Prompts")
                .font(.headline)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                QuickPromptButton(
                    icon: "text.bubble",
                    title: "Describe",
                    action: { analyzeImage(prompt: "Describe this image in detail") }
                )
                
                QuickPromptButton(
                    icon: "doc.text.magnifyingglass",
                    title: "Extract Text",
                    action: { analyzeImage(prompt: "Extract all text from this image") }
                )
                
                QuickPromptButton(
                    icon: "eye",
                    title: "What is this?",
                    action: { analyzeImage(prompt: "What is in this image? Be specific.") }
                )
                
                QuickPromptButton(
                    icon: "paintbrush",
                    title: "Art Analysis",
                    action: { analyzeImage(prompt: "Analyze this image as an art piece. Discuss composition, colors, and mood.") }
                )
                
                QuickPromptButton(
                    icon: "fork.knife",
                    title: "Recipe",
                    action: { analyzeImage(prompt: "If this is food, provide a recipe. If not food, describe what you see.") }
                )
                
                QuickPromptButton(
                    icon: "figure.walk",
                    title: "Accessibility",
                    action: { analyzeImage(prompt: "Describe this image for someone who cannot see it. Be detailed and helpful.") }
                )
            }
        }
    }
    
    private var customPromptSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Custom Prompt")
                .font(.headline)
            
            HStack(spacing: 12) {
                TextField("Ask anything about the image...", text: $prompt)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                
                Button(action: { analyzeImage(prompt: prompt) }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(prompt.isEmpty || isAnalyzing ? .gray : .blue)
                }
                .disabled(prompt.isEmpty || isAnalyzing)
            }
        }
    }
    
    private var responseSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Analysis")
                    .font(.headline)
                
                Spacer()
                
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
            
            Text(response)
                .font(.body)
                .textSelection(.enabled)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private func analyzeImage(prompt: String) {
        guard let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        isAnalyzing = true
        response = ""
        
        Task {
            do {
                let stream = try await aiManager.sendStreamingRequest(
                    prompt: prompt,
                    imageData: imageData
                )
                
                for try await chunk in stream {
                    response += chunk
                }
            } catch {
                response = "Error: \(error.localizedDescription)"
            }
            
            isAnalyzing = false
        }
    }
    
    private func copyResponse() {
        UIPasteboard.general.string = response
    }
}

// MARK: - Quick Prompt Button
struct QuickPromptButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                
                Text(title)
                    .font(.caption.bold())
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            .foregroundStyle(.blue)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Camera View
struct CameraView: UIViewControllerRepresentable {
    let onCapture: (UIImage) -> Void
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onCapture(image)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

/*
// MARK: - Preview
#Preview {
    NavigationStack {
        ImageAnalysisView()
            .environment(AIManager(
                storage: MockAIStorage(initialKey: "test"),
                service: GeminiAIService()
            ))
    }
}
*/
