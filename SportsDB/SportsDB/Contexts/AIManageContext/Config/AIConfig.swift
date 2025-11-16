//
//  AIConfig.swift
//  SportsDB
//
//  Created by Macbook on 13/11/25.
//

import SwiftUI
import GoogleGenerativeAI

/*
// MARK: - AI Configuration Protocol
protocol AIConfigurationProtocol {
    var modelName: String { get }
    var temperature: Float { get }
    var topP: Float { get }
    var topK: Int { get }
    var maxOutputTokens: Int { get }
    var responseMIMEType: String { get }
    var safetySettings: [SafetySetting] { get }
    var maxKeyLength: Int { get }
    var testPrompt: String { get }
}

// MARK: - Default Configuration
struct AIConfiguration: AIConfigurationProtocol {
    var modelName: String
    var temperature: Float
    var topP: Float
    var topK: Int
    var maxOutputTokens: Int
    var responseMIMEType: String
    var safetySettings: [SafetySetting]
    var maxKeyLength: Int
    var testPrompt: String
    
    // Default initializer
    init(
        modelName: String = "gemini-2.5-flash-lite",
        temperature: Float = 1.0,
        topP: Float = 0.95,
        topK: Int = 64,
        maxOutputTokens: Int = 1048576,
        responseMIMEType: String = "text/plain",
        safetySettings: [SafetySetting] = Self.defaultSafetySettings,
        maxKeyLength: Int = 50,
        testPrompt: String = "Print text: hello"
    ) {
        self.modelName = modelName
        self.temperature = temperature
        self.topP = topP
        self.topK = topK
        self.maxOutputTokens = maxOutputTokens
        self.responseMIMEType = responseMIMEType
        self.safetySettings = safetySettings
        self.maxKeyLength = maxKeyLength
        self.testPrompt = testPrompt
    }
    
    // Predefined configurations
    static var `default`: AIConfiguration {
        AIConfiguration()
    }
    
    static var fastMode: AIConfiguration {
        AIConfiguration(
            modelName: "gemini-2.5-flash-lite",
            temperature: 0.7,
            maxOutputTokens: 2048
        )
    }
    
    static var creativeMode: AIConfiguration {
        AIConfiguration(
            modelName: "gemini-2.5-flash",
            temperature: 1.5,
            topP: 0.98,
            maxOutputTokens: 4096
        )
    }
    
    static var preciseMode: AIConfiguration {
        AIConfiguration(
            modelName: "gemini-2.5-flash",
            temperature: 0.3,
            topP: 0.8,
            topK: 40
        )
    }
    
    // Default safety settings
    static var defaultSafetySettings: [SafetySetting] {
        [
            SafetySetting(harmCategory: .harassment, threshold: .blockMediumAndAbove),
            SafetySetting(harmCategory: .hateSpeech, threshold: .blockMediumAndAbove),
            SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockMediumAndAbove),
            SafetySetting(harmCategory: .dangerousContent, threshold: .blockMediumAndAbove)
        ]
    }
    
    static var strictSafetySettings: [SafetySetting] {
        [
            SafetySetting(harmCategory: .harassment, threshold: .blockLowAndAbove),
            SafetySetting(harmCategory: .hateSpeech, threshold: .blockLowAndAbove),
            SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockLowAndAbove),
            SafetySetting(harmCategory: .dangerousContent, threshold: .blockLowAndAbove)
        ]
    }
}

// MARK: - Model Preset
enum GeminiModelPreset {
    case flashLite
    case flash
    case pro
    case custom(String)
    
    var modelName: String {
        switch self {
        case .flashLite:
            return "gemini-2.5-flash-lite"
        case .flash:
            return "gemini-2.5-flash"
        case .pro:
            return "gemini-1.5-pro-latest"
        case .custom(let name):
            return name
        }
    }
}


// MARK: - Configuration Builder (Optional)
class AIConfigurationBuilder {
    private var config = AIConfiguration()
    
    func setModel(_ preset: GeminiModelPreset) -> Self {
        config.modelName = preset.modelName
        return self
    }
    
    func setTemperature(_ value: Float) -> Self {
        config.temperature = max(0.0, min(2.0, value))
        return self
    }
    
    func setMaxTokens(_ value: Int) -> Self {
        config.maxOutputTokens = value
        return self
    }
    
    func setSafetyLevel(_ level: SafetyLevel) -> Self {
        switch level {
        case .standard:
            config.safetySettings = AIConfiguration.defaultSafetySettings
        case .strict:
            config.safetySettings = AIConfiguration.strictSafetySettings
        case .custom(let settings):
            config.safetySettings = settings
        }
        return self
    }
    
    func build() -> AIConfiguration {
        return config
    }
    
    enum SafetyLevel {
        case standard
        case strict
        case custom([SafetySetting])
    }
}
*/

// MARK: - Usage Example
/*
//  preset
let config1 = AIConfiguration.creativeMode

// builder
let config2 = AIConfigurationBuilder()
    .setModel(.flash)
    .setTemperature(0.8)
    .setMaxTokens(2048)
    .setSafetyLevel(.strict)
    .build()

//
let config3 = AIConfiguration(
    modelName: "gemini-pro-vision",
    temperature: 0.5,
    maxOutputTokens: 8192
)
*/
