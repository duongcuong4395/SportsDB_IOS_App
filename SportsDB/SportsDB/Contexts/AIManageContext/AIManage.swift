//
//  AIManage.swift
//  SportsDB
//
//  Created by Macbook on 13/8/25.
//

import SwiftUI
import GoogleGenerativeAI
import SwiftData

enum GeminiStatus {
    case NotExistsKey
    case ExistsKey
    case SendReqestFail
    case Success
}

// MARK: - View add Key
struct GeminiAddKeyView: View {
    @EnvironmentObject var aiManageVM: AIManageViewModel
    
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.managedObjectContext) var context
    @State var keyString: String = ""
    
    @State var resultMess: String = ""
    
    var body: some View {
        VStack {
            
            HStack {
                Image(systemName: "key")
                    .font(.caption2)
                Divider()
                // TextField
                SecureField(NSLocalizedString("Title_Enter_Key", comment: ""), text: $keyString.max(50))
                    Divider()
                Button(action: {
                    withAnimation {
                        if keyString.count > 0 {
                            resultMess = ""
                            checkKey()
                        }
                    }
                }, label: {
                    Text(NSLocalizedString("Check", comment: ""))
                        .font(.caption.bold())
                        .foregroundStyle(keyString.count > 0 ? .blue : .brown)
                })
            }
            .padding(.vertical, 3)
            .padding(.horizontal, 5)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
            )
            
            if resultMess.count > 0 {
                Text(resultMess)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .shadow(radius: 3)
                    .padding(3)
                    .padding(.horizontal, 3)
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                    )
            }
            VStack(spacing: 5) {
                HStack {
                    Text(NSLocalizedString("NOTE", comment: "") + ":")
                        .font(.caption.bold())
                    Spacer()
                }
                HStack {
                    Text("- \(NSLocalizedString("getKeyByLink", comment: "")).")
                        .font(.caption)
                    Link(destination: URL(string: "https://aistudio.google.com/app/apikey")!) {
                        Image(systemName: "link.circle.fill")
                            .font(.title3)
                    }
                    Spacer()
                }
                HStack(alignment: .center) {
                    Text("- \(NSLocalizedString("keyOnlyOnceInApp", comment: "")).")
                        .font(.caption)
                    Spacer()
                }
                HStack(alignment: .center) {
                    Text("- \(NSLocalizedString("keyNotShare", comment: "")).")
                        .font(.caption)
                    Spacer()
                }
                HStack(alignment: .center) {
                    Text("- \(NSLocalizedString("stableNetworkRequires", comment: "")).")
                        .font(.caption)
                    Spacer()
                }
            }
        }
        //.foregroundStyleItemView(by: appVM.appMode)
    }
    
    func checkKey() {
        
        DispatchQueueManager.share.runOnMain {
            aiManageVM.GeminiSend(prompt: "hãy cho tôi text: hello", and: true) { messResult, geminiStatus in
                switch geminiStatus {
                case .NotExistsKey:
                    // Key is not exists
                    return
                case .ExistsKey:
                    // Key is exists
                    return
                case .SendReqestFail:
                    resultMess = "* \(NSLocalizedString("keyNotExists", comment: ""))."
                    keyString = ""
                case .Success:
                    Task {
                        let success = await aiManageVM.mergeKey(with: keyString)
                        guard success else { resultMess = "* \(NSLocalizedString("tryAgain", comment: ""))"; return }
                    }
                    resultMess = ""
                    appVM.showDialog = false
                }
            }
        }
        
    }
}

extension Binding where Value == String {
    // MARK: - For max Length for text
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        return self
    }
}
