//
//  AppUtility.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import Foundation
import Alamofire

class AppUtility {
    static let envDict = Bundle.main.infoDictionary?["LSEnvironment"] as! Dictionary<String, String>
    
    static let SportScoreBaseURL = envDict["BaseURL_SportScore"]! as String
    static let FootballBaseURL = envDict["BaseURL_Football"]! as String
    static let MapsBaseURL = envDict["BaseURL_MapsData"]! as String
    
    static let SportBaseURL = envDict["BaseURL_Sport"]! as String
    
    
    
    static let headers: HTTPHeaders = ["x-rapidapi-host": "sportscore1.p.rapidapi.com"
                                      , "x-rapidapi-key": "648d829bdbmshf8961c0edaf9408p15a3fcjsn9ec521f88da8"]
    static let headersMaps: HTTPHeaders = ["x-rapidapi-host": "maps-data.p.rapidapi.com"
                                      , "x-rapidapi-key": "648d829bdbmshf8961c0edaf9408p15a3fcjsn9ec521f88da8"]
    
    static let headersFootball: HTTPHeaders = ["x-rapidapi-host": "football-highlights-api.p.rapidapi.com"
                                      , "x-rapidapi-key": "648d829bdbmshf8961c0edaf9408p15a3fcjsn9ec521f88da8"]
    
    static func formatDate(from input: String?, to outputFormat: String) -> String? {
        let inputFormatter = DateFormatter()
        //inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        var date: Date?
        
        // Nếu có chuỗi đầu vào, chuyển đổi nó thành Date
        if let input = input {
            date = inputFormatter.date(from: input)
        } else {
            // Nếu không có chuỗi đầu vào, sử dụng ngày hiện tại
            date = Date()
        }
        
        // Đảm bảo rằng date không phải là nil
        guard let validDate = date else {
            print("Invalid date format")
            return nil
        }
        
        // Tạo đối tượng DateFormatter cho đầu ra
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        
        // Chuyển đổi đối tượng Date thành chuỗi theo định dạng mong muốn
        let formattedDateString = outputFormatter.string(from: validDate)
        
        return formattedDateString
    }
    
    static func getCurrentLanguage() -> (full: String, tet: String) {
       guard let languageCode = Locale.preferredLanguages.first else {
           return ("Không xác định", "ko")
       }

        let te = languageCode.split(separator: "-")
        return (full: "\(languageCode)", tet: String(te[0]))
   }
}


class DateUtility {
    static func calculateDate(from today: Date = Date(), offset: Int, to format: String = "yyyy-MM-dd") -> String {
        let calendar = Calendar.current
        
        print("date after \(offset)", calendar.date(byAdding: .day, value: offset, to: today)!)
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
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Điều chỉnh timeZone nếu cần
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Sử dụng locale tiêu chuẩn

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
