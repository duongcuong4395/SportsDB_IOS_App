//
//  MainDB.swift
//  SportsDB
//
//  Created by Macbook on 10/8/25.
//

import SwiftData
import Foundation

enum MainDB {
    static let shared: ModelContainer = {
        let schema = Schema([EventSwiftData.self])
        
        let url = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("MainDB.sqlite")
        
        
        let config = ModelConfiguration("MainDB", isStoredInMemoryOnly: false)
        /*
        ModelConfiguration(
            schema: schema,
            url: url
            , isStoredInMemoryOnly: false
            
            //, migrationPlan: MigrationPlan.self
        )
        */
        
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("⚠️ Failed to initialize ModelContainer: \(error)")
        }
    }()
}


// MARK: SwiftData + SwiftUI + Migration

/*
 
 // MARK: 📌 Step 1 – V1: Model ban đầu
 // V1 – Event.swift
 import SwiftData
 
 @Model
 final class Event {
    @Attribute(.unique) var id: UUID
     var title: String
     var date: Date
     
     init(id: UUID = UUID(), title: String, date: Date) {
     self.id = id
     self.title = title
     self.date = date
     }
 }
 
 // MARK: 📌 Step 2 – V2: Thêm và xóa field
 
 // V2 – Event.swift
 import SwiftData

 @Model
 final class Event {
     @Attribute(.unique) var id: UUID
     var title: String
     var location: String?
     var startDate: Date
     
     init(id: UUID = UUID(), title: String, location: String? = nil, startDate: Date) {
         self.id = id
         self.title = title
         self.location = location
         self.startDate = startDate
     }
 }

 // MARK: 📌 Step 3 – Migration Plan
 // MigrationPlan.swift
 import SwiftData

 enum EventMigrationPlan: SchemaMigrationPlan {
     // V1 schema
     static var v1: Version {
         .init(schema: Schema([Event.self]), version: "V1")
     }
     
     // V2 schema
     static var v2: Version {
         .init(schema: Schema([Event.self]), version: "V2")
     }
     
     static var stages: [MigrationStage] {
         [
             .lightweight(fromVersion: v1, toVersion: v2, willMigrate: { context in
                 print("Starting migration from V1 to V2...")
             }, didMigrate: { context in
                 print("Finished migration from V1 to V2")
             }),
             
             .custom(
                 fromVersion: v1,
                 toVersion: v2,
                 willMigrate: { context in
                     // Transform dữ liệu
                     let fetchDescriptor = FetchDescriptor<Event>(predicate: nil)
                     if let oldEvents = try? context.fetch(fetchDescriptor) {
                         for oldEvent in oldEvents {
                             // Map date -> startDate
                             oldEvent.startDate = oldEvent.date
                             // Gán location mặc định
                             oldEvent.location = "Unknown"
                         }
                     }
                 },
                 didMigrate: { _ in
                     print("Custom migration complete.")
                 }
             )
         ]
     }
 }

 // MARK: 📌 Step 4 – SwiftData Stack với Migration
 // SwiftDataManager.swift
 import SwiftData

 @MainActor
 final class SwiftDataManager {
     static let shared = SwiftDataManager()
     
     let container: ModelContainer
     
     private init() {
         let config = ModelConfiguration(
             schema: Schema([Event.self]),
             migrations: [EventMigrationPlan.self],
             allowsSave: true
         )
         
         do {
             container = try ModelContainer(
                 for: Event.self,
                 migrationPlan: EventMigrationPlan.self,
                 configurations: [config]
             )
         } catch {
             fatalError("Failed to init ModelContainer: \(error)")
         }
     }
 }

 
 // MARK: 📌 Step 5 – SwiftUI Demo App
 import SwiftUI
 import SwiftData

 @main
 struct MigrationDemoApp: App {
     var body: some Scene {
         WindowGroup {
             ContentView()
                 .modelContainer(SwiftDataManager.shared.container)
         }
     }
 }

 struct ContentView: View {
     @Environment(\.modelContext) private var context
     @Query(sort: \.title) var events: [Event]
     
     var body: some View {
         NavigationStack {
             List {
                 ForEach(events) { event in
                     VStack(alignment: .leading) {
                         Text(event.title).font(.headline)
                         Text("Start: \(event.startDate.formatted())")
                         if let location = event.location {
                             Text("Location: \(location)")
                         }
                     }
                 }
                 .onDelete(perform: deleteEvents)
             }
             .navigationTitle("Events")
             .toolbar {
                 Button("Add") { addEvent() }
             }
         }
     }
     
     private func addEvent() {
         let newEvent = Event(title: "New Event", startDate: Date())
         context.insert(newEvent)
         try? context.save()
     }
     
     private func deleteEvents(at offsets: IndexSet) {
         offsets.map { events[$0] }.forEach(context.delete)
         try? context.save()
     }
 }

 */
