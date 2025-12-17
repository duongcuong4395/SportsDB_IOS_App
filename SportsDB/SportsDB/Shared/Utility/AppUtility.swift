//
//  AppUtility.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import Foundation
import Alamofire

class TextGen {
    static func getText(_ texType: TexType, with comment: String = "") -> String {
        return NSLocalizedString(texType.rawValue, comment: comment)
    }
}

enum TexType: String {
    
    case promptEvent2vs2Analysis = "promptEvent2vs2Analysis"
    case placeholderEnterKey = "Title_Enter_Key"
    
    case checkAIKey = "Check"
    case aiNote = "NOTE"
    case getKeyByLink = "getKeyByLink"
    case keyOnlyOnceInApp = "keyOnlyOnceInApp"
    case keyNotShare = "keyNotShare"
    case keyNotExists = "keyNotExists"
    case ExistsKey = "ExistsKey"
    case tryAgain = "tryAgain"
    
    func localized(with comment: String = "") -> String {
        return NSLocalizedString(self.rawValue, comment: comment)
    }
}

class AppUtility {
    static let envDict = Bundle.main.infoDictionary?["LSEnvironment"] as! Dictionary<String, String>
    static let SportBaseURL = envDict["BaseURL_Sport"]! as String
    static let KeySystem = envDict["Key_System"]! as String
    static let KeyUser = envDict["Key_User"]! as String
    
    static var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    static func formatDate(from input: String?, to outputFormat: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        var date: Date?
        
        if let input = input {
            date = inputFormatter.date(from: input)
        } else {
            date = Date()
        }
        
        guard let validDate = date else {
            print("Invalid date format")
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        
        let formattedDateString = outputFormatter.string(from: validDate)
        
        return formattedDateString
    }
    
    static func getCurrentLanguage() -> (full: String, tet: String) {
       guard let languageCode = Locale.preferredLanguages.first else {
           return ("Undetermined", "ko")
       }

        let te = languageCode.split(separator: "-")
        return (full: "\(languageCode)", tet: String(te[0]))
   }
}


class DateUtility {
    static func calculateDate(from today: Date = Date(), offset: Int, to format: String = "yyyy-MM-dd") -> String {
        let calendar = Calendar.current
        
        let validDate = calendar.date(byAdding: .day, value: offset, to: today)!
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = format
        
        let formattedDateString = outputFormatter.string(from: validDate)
        
        return formattedDateString
    }
    
    static func formatDate(_ date: Date, to format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func convertToDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            print("Failed to convert string to date")
            return nil
        }
    }
}


class DispatchQueueManager {
    static let share = DispatchQueueManager()
    
    func runInBackground(task: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            task()
        }
    }
    
    func runInBackground(task: @escaping () async -> Void) {
        DispatchQueue.global(qos: .background).async {
            Task {
                await task()
            }
        }
    }
    
    func runInBackground(task: @escaping () -> Any) {
        DispatchQueue.global(qos: .background).async {
            return task() as! Void
        }
    }
    
    func runOnMain(task: @escaping () -> Void) {
        DispatchQueue.main.async {
            task()
        }
    }
}


import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
