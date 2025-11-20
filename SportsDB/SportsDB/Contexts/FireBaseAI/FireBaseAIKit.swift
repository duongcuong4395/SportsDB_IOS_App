//
//  FireBaseAIKit.swift
//  SportsDB
//
//  Created by Macbook on 18/11/25.
//

import SwiftUI
import FirebaseAILogic

struct DemoWithFireBaseView: View {
    let ai = FirebaseAI.firebaseAI(backend: .googleAI())
    var model: GenerativeModel
    var chat: Chat
    
    @State var imageGen: UIImage = UIImage()
    // Optionally specify existing chat history
    var history = [
      ModelContent(role: "user", parts: "Hello, I have 2 dogs in my house."),
      ModelContent(role: "model", parts: "Great to meet you. What would you like to know?"),
    ]
    
    
    
    init() {
        model = ai.generativeModel(modelName: "gemini-2.5-flash-lite")
        chat = model.startChat(history: history)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Button("AI With Text") {
                Task {
                    try await callAIWithText()
                }
            }
            
            Button("AI Chat") {
                chatAI()
            }
            
            Button("AI Analyze Images") {
                callAIAnalyzeImages()
            }
            
            Button("AI Analyze Video") {
                callAIAnalyzeVideo()
            }
            
            Button("AI Analyze Documents") {
                callAIAnalyzeDocuments()
            }
            
            
            
            /*
            Button("AI Generate Images") {
                callAIGenerateImages()
            }
            
            
            Image(uiImage: imageGen)
                .resizable()
                .frame(height: 200)
                .padding()
            */
            
            
            /*
            Button("Chat AI Edit Image") {
                chatAIEditImage()
            }
            */
        }
    }
    
    func callAIAnalyzeDocuments() {
        Task {
            // Provide the video as `Data` with the appropriate MIME type
            guard let url = URL(string: "https://storage.googleapis.com/cloud-samples-data/generative-ai/pdf/2403.05530.pdf") else {
                print("Invalid URL")
                return
            }
            
            // Fetch video data asynchronously (avoid blocking main thread)
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Provide the PDF as `Data` with the appropriate MIME type
            let pdf = try InlineDataPart(data: data, mimeType: "application/pdf")

            // Provide a text prompt to include with the PDF file
            let prompt = "Summarize the important results in this report."

            // To stream generated text output, call `generateContentStream` with the PDF file and text prompt
            let contentStream = try model.generateContentStream(pdf, prompt)

            // Print the generated text, handling the case where it might be nil
            for try await chunk in contentStream {
              if let text = chunk.text {
                print(text)
              }
            }
        }
    }
    
    func callAIAnalyzeVideo() {
        Task {
            // Provide the video as `Data` with the appropriate MIME type
            guard let url = URL(string: "https://storage.googleapis.com/cloud-samples-data/video/animals.mp4") else {
                print("Invalid URL")
                return
            }
            
            // Fetch video data asynchronously (avoid blocking main thread)
            let (data, _) = try await URLSession.shared.data(from: url)

            
            let video = InlineDataPart(data: data, mimeType: "video/mp4")

            // Provide a text prompt to include with the video
            let prompt = "What is in the video?"

            // To stream generated text output, call generateContentStream with the text and video
            let contentStream = try model.generateContentStream(video, prompt)
            for try await chunk in contentStream {
              if let text = chunk.text {
                print(text)
              }
            }
        }
    }
    
    func callAIGenerateImages() {
        Task {
            // Create an `ImagenModel` instance with a model that supports your use case
            let model = ai.imagenModel(modelName: "imagen-4.0-generate-001")

            // Provide an image generation prompt
            let prompt = "An astronaut riding a horse"

            // To generate an image, call `generateImages` with the text prompt
            let response = try await model.generateImages(prompt: prompt)

            // Handle the generated image
            guard let image = response.images.first else {
              fatalError("No image in the response.")
            }
            let uiImage = UIImage(data: image.data)
            
            self.imageGen = uiImage ?? UIImage()
        }
        
    }
    
    func callAIAnalyzeImages() {
        Task {
            guard let image1 = UIImage(systemName: "car") else { fatalError() }
            guard let image2 = UIImage(systemName: "car.2") else { fatalError() }

            // Provide a text prompt to include with the images
            let prompt = "What's different between these pictures?"

            // To stream generated text output, call generateContentStream and pass in the prompt
            let contentStream = try model.generateContentStream(image1, image2, prompt)
            for try await chunk in contentStream {
              if let text = chunk.text {
                print(text)
              }
            }
        }
        
    }
    
    func chatAIEditImage() {
        Task {
            let generativeModel = FirebaseAI.firebaseAI(backend: .googleAI()).generativeModel(
              modelName: "gemini-2.5-flash-image",
              // Configure the model to respond with text and images (required)
              generationConfig: GenerationConfig(responseModalities: [.text, .image])
            )
            
            // Initialize the chat
            let chat = generativeModel.startChat()

            guard let image = UIImage(named: "Sports") else { fatalError("Image file not found.") }

            // Provide an initial text prompt instructing the model to edit the image
            let prompt = "Edit this image to make it look like a cartoon"

            // To generate an initial response, send a user message with the image and text prompt
            let response = try await chat.sendMessage(image, prompt)

            // Inspect the generated image
            guard let inlineDataPart = response.inlineDataParts.first else {
              fatalError("No image data in response.")
            }
            guard let uiImage = UIImage(data: inlineDataPart.data) else {
              fatalError("Failed to convert data to UIImage.")
            }

            // Follow up requests do not need to specify the image again
            let followUpResponse = try await chat.sendMessage("But make it old-school line drawing style")

            // Inspect the edited image after the follow up request
            guard let followUpInlineDataPart = followUpResponse.inlineDataParts.first else {
              fatalError("No image data in response.")
            }
            guard let followUpUIImage = UIImage(data: followUpInlineDataPart.data) else {
              fatalError("Failed to convert data to UIImage.")
            }
        }
        
    }
    
    func chatAI() {
        Task {
            do {
                // To stream generated text output, call sendMessageStream and pass in the message
                let contentStream = try chat.sendMessageStream("How many paws are in my house?")
                for try await chunk in contentStream {
                  if let text = chunk.text {
                    print(text)
                  }
                }
                
                print("chat.history:", chat.history.count)
            } catch {}
            
        }
        
        
    }
    
    private func callAIWithText() async throws {
        // Create a `GenerativeModel` instance with a model that supports your use case
        //let model = ai.generativeModel(modelName: "gemini-2.5-flash-lite")


        // Provide a prompt that contains text
        let prompt = "Write a story about a magic backpack."

        // To stream generated text output, call generateContentStream with the text input
        let contentStream = try model.generateContentStream(prompt)
        for try await chunk in contentStream {
          if let text = chunk.text {
            print(text)
          }
        }
    }
}
