//
//  AIManageViewModel.swift
//  SportsDB
//
//  Created by Macbook on 13/8/25.
//

import SwiftUI
import SwiftData
import GoogleGenerativeAI


class AIUtility {
    static let key: String = "AiKey"
}

class AIManageViewModel: ObservableObject {
    @Published var aiSwiftData: AISwiftData?
    
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    var context: ModelContext
    var useCase: AIManageUseCaseProtocol
    init(context: ModelContext
         , useCase: AIManageUseCaseProtocol) {
        self.context = context
        self.useCase = useCase
        
        Task {
            _ = await self.getKey()
        }
        
    }
    
    func loadAIData() async -> AISwiftData? {
        return await performOperation {
            self.aiSwiftData = await useCase.getData(by: AIUtility.key)
            return self.aiSwiftData
        } ?? nil
    }
    
    func getKey() async -> AISwiftData? {
        return await performOperation {
            let res = await useCase.getData(by: AIUtility.key)
            DispatchQueue.main.sync {
                self.aiSwiftData = res
            }
            return res
        } ?? nil
    }
    
    func addKey(_ key: String) async -> Bool {
        return await performOperation {
            let newData = AISwiftData(itemKey: AIUtility.key, valueItem: key)
            try await useCase.addData(newData)
            _ = await getKey()
            return true
        } ?? false
    }
    
    func updateKey(_ data: AISwiftData, by newkey: String) async -> Bool {
        return await performOperation {
            try await useCase.updateKey(data, by: newkey)
            _ = await getKey()
            return true
        } ?? false
    }
    
    func getModel(with model: AIModel) -> GenerativeModel {
        return GenerativeModel(
          name:  "gemini-2.5-flash", // "gemini-1.5-flash-latest", // "gemini-1.5-pro-latest", // "gemini-1.5-flash-latest",
          apiKey:  model.valueItem,
          generationConfig: GenerationConfig(
            temperature: 1,
            topP: 0.95,
            topK: 64,
            maxOutputTokens: 1048576, //8192,
            responseMIMEType: "text/plain"
          ),
          safetySettings: [
            SafetySetting(harmCategory: .harassment, threshold: .blockMediumAndAbove),
            SafetySetting(harmCategory: .hateSpeech, threshold: .blockMediumAndAbove),
            SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockMediumAndAbove),
            SafetySetting(harmCategory: .dangerousContent, threshold: .blockMediumAndAbove)
          ]
        )
    }
    
    func mergeKey(with key: String) async -> Bool {
        let modelFromSwiftData = await getKey()
        if let data = modelFromSwiftData {
            let success = await updateKey(data, by: key)
            return success
        } else {
            let success = await addKey(key)
            return success
        }
    }
    
    
    // MARK: - Private Methods
    
    private func performOperation<T>(_ operation: () async throws -> T) async -> T? {
        DispatchQueue.main.sync {
            isLoading = true
            error = nil
        }
        
        do {
            let result = try await operation()
            DispatchQueue.main.sync {
                isLoading = false
            } 
            return result
        } catch {
            self.error = error
            isLoading = false
            print("❌ Operation failed: \(error)")
            return nil
        }
    }
}

extension AIManageViewModel {
    func checKeyExist(completed: @escaping (Bool) -> Void) {
        GeminiSend(prompt: "Print text: hello", and: true) { messResult, geminiStatus, keyString in
            DispatchQueueManager.share.runOnMain {
                switch geminiStatus {
                case .NotExistsKey, .ExistsKey, .SendReqestFail:
                    completed(false)
                case .Success:
                    completed(true)
                }
            }
        }
    }
    
    func GeminiSend(prompt: String, and hasStream: Bool, completed: @escaping (String, GeminiStatus, String) -> Void) {
        DispatchQueueManager.share.runInBackground {
            
            guard let modelData = self.aiSwiftData else { return }
            let modelKey = AIModel(itemKey: AIUtility.key, valueItem: modelData.valueItem)
            
            let model = self.getModel(with: modelKey)
            let chat = model.startChat(history: [])
            
            Task {
              do {
                  if hasStream {
                      let responseStream =  chat.sendMessageStream(prompt)
                      for try await chunk in responseStream {
                          if let text = chunk.text {
                              completed(text, .Success, modelKey.valueItem)
                          }
                      }
                  } else {
                      let response = try await chat.sendMessage(prompt)
                      let _ = try await model.countTokens(prompt)
                      completed(response.text ?? "Empty", .Success, modelKey.valueItem)
                  }
              } catch {
                  let err = self.getError(from: error)
                  completed(err.0, err.1, "")
              }
            }
        }
    }
    
    // MARK: - New
    func GeminiSend(prompt: String, and image: UIImage, completed: @escaping (String) -> Void) {
        
        guard let modelData = aiSwiftData else { return }
        let modelKey = AIModel(itemKey: AIUtility.key, valueItem: modelData.valueItem)
        let model = self.getModel(with: modelKey)
        Task {
          do {
              let contentStream = model.generateContentStream(prompt, image)
              for try await chunk in contentStream {
                if let text = chunk.text {
                    completed(text)
                }
              }
          } catch {
              completed("Data not found")
          }
        }
    }
    
    func GeminiSend(prompt: String, and hasStream: Bool, completed: @escaping (String, GeminiStatus) -> Void) {
        
        guard let modelData = aiSwiftData else { return }
        let modelKey = AIModel(itemKey: AIUtility.key, valueItem: modelData.valueItem)
        
        let model = self.getModel(with: modelKey)
        let chat = model.startChat(history: [])
        
        Task {
          do {
              if hasStream {
                  let responseStream = chat.sendMessageStream(prompt)
                  for try await chunk in responseStream {
                      if let text = chunk.text {
                          DispatchQueueManager.share.runOnMain {
                              completed(text, .Success)
                          }
                      }
                  }
              } else {
                  let response = try await chat.sendMessage(prompt)
                  let _ = try await model.countTokens(prompt)
                  DispatchQueueManager.share.runOnMain {
                      completed(response.text ?? "Empty", .Success)
                  }
              }
          } catch {
              DispatchQueueManager.share.runOnMain {
                  let err = self.getError(from: error)
                  completed(err.0, err.1)
              }
              
          }
        }
    }
    
    func testKeyExists(with prompt: String, and keyInput: String, completed: @escaping (String, GeminiStatus) -> Void) {
        let modelKey = AIModel(itemKey: AIUtility.key, valueItem: keyInput)
        
        let model = self.getModel(with: modelKey)
        let chat = model.startChat(history: [])
        
        Task {
          do {
              let response = try await chat.sendMessage(prompt)
              DispatchQueueManager.share.runOnMain {
                  completed(response.text ?? "Empty", .Success)
              }
          } catch {
              DispatchQueueManager.share.runOnMain {
                  let err = self.getError(from: error)
                  completed(err.0, err.1)
              }
              
          }
        }
    }
    
    
    
    
    func getError(from err: any Error) -> (String, GeminiStatus) {
        if let er = error as? GenerateContentError {
            switch er {
            case .invalidAPIKey(let message):
                print("❌ Invalid API Key:", message)
                if message.contains("API key not valid. Please pass a valid API key.") {
                    return (message, .NotExistsKey)
                } else {
                    return (message, .SendReqestFail)
                }
            default:
                print("❌ Other Error:", er.localizedDescription)
                return ("Data not found", .SendReqestFail)
            }
        } else {
            return ("Unexpected error", .SendReqestFail)
        }
    }
    
}
