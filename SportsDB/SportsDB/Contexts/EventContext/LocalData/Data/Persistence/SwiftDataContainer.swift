//
//  SwiftDataContainer.swift
//  SportsDB
//
//  Created by Macbook on 8/8/25.
//

import SwiftData
import Foundation

@MainActor
final class SwiftDataContainer {
    static let shared = SwiftDataContainer()

    let container: ModelContainer
    let context: ModelContext

    private init() {
        let schema = Schema([EventLocalData.self])
        
        // Lấy đường dẫn lưu file
        let storeURL = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("SportsDBDataBase.store")

        // Tạo config với URL
        let configuration = ModelConfiguration(
            "SportsDBDataBase",
             //isStoredInMemoryOnly: false, // = true => khi app hoặc process bị kill/tắ app, toàn bộ dữ liệu biến mất.
            url: storeURL
        )

        // Tạo container
        self.container = try! ModelContainer(
            for: schema,
            configurations: [configuration]
        )
        
        //self.container = try! ModelContainer(for: schema, configurations: [configuration])
        self.context = container.mainContext
    }
}
