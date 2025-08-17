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
    @State var keyString: String = ""
    
    @State var resultMess: String = ""
    
    var body: some View {
        VStack {
            
            HStack {
                Image(systemName: "key")
                    .font(.caption2)
                Divider()
                
                SecureField(TextGen.getText(.placeholderEnterKey), text: $keyString.max(50))
                    Divider()
                Button(action: {
                    withAnimation {
                        if keyString.count > 0 {
                            resultMess = ""
                            checkKey()
                        }
                    }
                }, label: {
                    Text(TextGen.getText(.checkAIKey))
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
                    Text(TextGen.getText(.aiNote) + ":")
                        .font(.caption.bold())
                    Spacer()
                }
                HStack {
                    Text("- \(TextGen.getText(.getKeyByLink)).")
                        .font(.caption)
                    Link(destination: URL(string: "https://aistudio.google.com/app/apikey")!) {
                        Image(systemName: "link.circle.fill")
                            .font(.title3)
                    }
                    Spacer()
                }
                HStack(alignment: .center) {
                    Text("- \(TextGen.getText(.keyOnlyOnceInApp)).")
                        .font(.caption)
                    Spacer()
                }
                HStack(alignment: .center) {
                    Text("- \(TextGen.getText(.keyNotShare)).")
                        .font(.caption)
                    Spacer()
                }
                /*
                HStack(alignment: .center) {
                    Text("- \(NSLocalizedString("stableNetworkRequires", comment: "")).")
                        .font(.caption)
                    Spacer()
                }
                */
            }
        }
        //.foregroundStyleItemView(by: appVM.appMode)
    }
    
    func checkKey() {
        
        DispatchQueueManager.share.runOnMain {
            aiManageVM.testKeyExists(with: "chỉ cần in ra text: hello", and: keyString) { messResult, geminiStatus in
                switch geminiStatus {
                case .NotExistsKey:
                    resultMess = "* \(TextGen.getText(.keyNotExists))."
                    keyString = ""
                    return
                case .ExistsKey:
                    resultMess = "* \(TextGen.getText(.ExistsKey))."
                    keyString = ""
                    return
                case .SendReqestFail:
                    resultMess = "* \(TextGen.getText(.keyNotExists))."
                    keyString = ""
                case .Success:
                    Task {
                        let success = await aiManageVM.mergeKey(with: keyString)
                        guard success else { resultMess = "* \(TextGen.getText(.tryAgain))"; return }
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
