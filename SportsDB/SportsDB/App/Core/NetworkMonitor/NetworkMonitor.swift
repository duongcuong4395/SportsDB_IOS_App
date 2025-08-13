//
//  NetworkMonitor.swift
//  SportsDB
//
//  Created by Macbook on 10/8/25.
//

import Network
import Combine

// MARK: NetworkType & NetworkQuality Enum
import Network

enum NetworkType: String {
    case wifi = "Wi-Fi"
    case cellular = "Cellular"
    case wired = "Wired Ethernet"
    case other = "Other"
    case none = "No Connection"
}

enum NetworkQuality: String {
    case strong = "Strong"
    case medium = "Medium"
    case weak = "Weak"
    case unknown = "Unknown"
    case offline = "Offline"
}



// MARK: NetworkManager
import Foundation
import Network
import Combine

@MainActor
final class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    @Published private(set) var isConnected: Bool = false
    @Published private(set) var connectionType: NetworkType = .none
    @Published private(set) var quality: NetworkQuality = .unknown
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var timer: Timer?
    
    private init() {
        startMonitoring()
        //startQualityCheckTimer()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = path.status == .satisfied
                self?.connectionType = self?.mapInterfaceType(path) ?? .none
                if self?.isConnected == false {
                    self?.quality = .offline
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    private func mapInterfaceType(_ path: NWPath) -> NetworkType {
        if path.usesInterfaceType(.wifi) { return .wifi }
        if path.usesInterfaceType(.cellular) { return .cellular }
        if path.usesInterfaceType(.wiredEthernet) { return .wired }
        if path.usesInterfaceType(.other) { return .other }
        return .none
    }
    
    private func startQualityCheckTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            Task { await self?.checkQuality() }
        }
    }
    
    func checkQuality() async {
        guard isConnected else {
            quality = .offline
            return
        }
        
        let latency = await measureLatency()
        switch latency {
        case 0..<0.1:
            quality = .strong
        case 0.1..<0.3:
            quality = .medium
        case 0.3...:
            quality = .weak
        default:
            quality = .unknown
        }
    }
    
    private func measureLatency() async -> TimeInterval {
        guard let url = URL(string: "https://www.google.com/generate_204") else { return -1 }
        let start = Date()
        
        do {
            let (_, _) = try await URLSession.shared.data(from: url)
            return Date().timeIntervalSince(start)
        } catch {
            return -1
        }
    }
}


import SwiftUI

struct NetworkView: View {
    @EnvironmentObject var network: NetworkManager
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Connection: \(network.connectionType.rawValue)")
                .foregroundColor(network.isConnected ? .green : .red)
              
            /*
            + Text("(\(network.quality.rawValue))")
                .foregroundColor(network.quality == .strong ? .green :
                                 network.quality == .medium ? .orange :
                                 network.quality == .weak ? .red : .gray)
            */
            
        }
        .font(.caption)
        .padding()
    }
}



struct NetworkNotConnectView: View {
    @EnvironmentObject var network: NetworkManager
    
    var body: some View {
        VStack(spacing: 12) {
            
            Spacer()
            Text("Not connect Internet")
            HStack {
                Spacer()
                Text("Connection: \(network.connectionType.rawValue)")
                    .foregroundColor(network.isConnected ? .green : .red)
                Spacer()
            }
            
            Spacer()
              
            /*
            + Text("(\(network.quality.rawValue))")
                .foregroundColor(network.quality == .strong ? .green :
                                 network.quality == .medium ? .orange :
                                 network.quality == .weak ? .red : .gray)
            */
            
        }
        
        
    }
}
