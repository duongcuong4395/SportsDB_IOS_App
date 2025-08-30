//
//  LikeRouteView.swift
//  SportsDB
//
//  Created by Macbook on 12/8/25.
//

import SwiftUI
import SwiftData
import Kingfisher

struct LikeRouteView: View {
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventSwiftDataVM: EventSwiftDataViewModel
    @EnvironmentObject var eventToggleLikeManager: EventToggleLikeManager
    
    @State private var events: [EventSwiftData] = []
    @State private var searchText: String = ""
    @State private var showingDeleteAlert: Bool = false
    @State private var eventToDelete: EventSwiftData?
    @State private var isSelectionMode: Bool = false
    @State private var selectedEvents: Set<String> = []
    
    var filteredEvents: [EventSwiftData] {
        if searchText.isEmpty {
            return events
        } else {
            return events.filter { event in
                (event.eventName?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (event.leagueName?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: Header
            headerView
            
            // MARK: Search Bar
            if !events.isEmpty {
                searchBarView
                    .padding(.vertical)
            }
            
            // MARK: Content
            contentView
        }
        .onAppear {
            loadLikedEvents()
        }
        .onChange(of: eventSwiftDataVM.events) { _, _ in
            loadLikedEvents()
        }
        .alert("Remove from Favorites", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                if let event = eventToDelete {
                    handleToggleLike(event)
                }
            }
        } message: {
            Text("Are you sure you want to remove this event from your favorites?")
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack(spacing: 10) {
            Button(action: {
                if isSelectionMode {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isSelectionMode = false
                        selectedEvents.removeAll()
                    }
                } else {
                    sportRouter.pop()
                }
            }) {
                Image(systemName: isSelectionMode ? "xmark" : "chevron.left")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            HStack(spacing: 8) {
                Image(systemName: events.count > 0 ? "heart.fill" : "heart")
                    .font(.body)
                    .foregroundColor(events.count > 0 ? .red : .primary)
                
                Text("Favorites")
                    .font(.body.bold())
                
                if !events.isEmpty {
                    Text("(\(events.count))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .contentTransition(.numericText())
                }
            }
            .onTapGesture {
                if !isSelectionMode {
                    sportRouter.pop()
                }
            }
            
            Spacer()
            
            if !events.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isSelectionMode.toggle()
                        selectedEvents.removeAll()
                    }
                }) {
                    Image(systemName: isSelectionMode ?  "checkmark.circle.fill" : "checklist")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
                }
            }
        }
        .padding(.horizontal, 16)
        .backgroundOfRouteHeaderView(with: 70)
    }
    
    // MARK: - Search Bar View
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search events...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !searchText.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        searchText = ""
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
    
    // MARK: - Content View
    @ViewBuilder
    private var contentView: some View {
        if events.isEmpty {
            emptyStateView
        } else if filteredEvents.isEmpty && !searchText.isEmpty {
            searchEmptyStateView
        } else {
            eventsListView
        }
    }
    
    // MARK: - Events List View
    private var eventsListView: some View {
        VStack(spacing: 0) {
            // Selection toolbar
            if isSelectionMode && !selectedEvents.isEmpty {
                selectionToolbar
                    .padding(.bottom, 5)
            }
            
            List {
                ForEach(filteredEvents, id: \.idEvent) { event in
                    eventRowView(event)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                }
                .onDelete(perform: deleteEvents)
            }
            .listStyle(PlainListStyle())
            .environment(\.editMode, .constant(isSelectionMode ? .active : .inactive))
            .padding(0)
        }
        .padding(0)
    }
    
    // MARK: - Event Row View
    private func eventRowView(_ event: EventSwiftData) -> some View {
        HStack {
            // Selection checkbox
            if isSelectionMode {
                Button(action: {
                    toggleSelection(for: event)
                }) {
                    Image(systemName: selectedEvents.contains(event.idEvent ?? "") ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedEvents.contains(event.idEvent ?? "") ? .blue : .secondary)
                        .font(.title3)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Event poster
            KFImage(URL(string: event.poster ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.ultraThinMaterial, lineWidth: 1)
                )
            
            // Event details
            VStack(alignment: .leading, spacing: 4) {
                Text(event.eventName ?? "Unknown Event")
                    .font(.footnote.bold())
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Text(event.leagueName ?? "Unknown League")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    
                    Text("(\(event.season ?? ""))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(event.getDateTime())
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Actions
            if !isSelectionMode {
                Menu {
                    Button(action: {
                        showDeleteConfirmation(for: event)
                    }) {
                        Label("Remove from Favorites", systemImage: "heart.slash")
                    }
                    
                    Button(action: {
                        // Add share functionality
                        shareEvent(event)
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background {
            Color.clear
                .liquidGlass(cornerRadius: 15, intensity: 0.3, tintColor: .orange, hasShimmer: true, hasGlow: true)
        }
        .background(.ultraThinMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        .overlay(alignment: .topLeading) {
            SportType(rawValue: event.sportName ?? "")?.getIcon()
                .frame(width: 25, height: 25)
                .offset(x: -5, y: -5)
        }
        .scaleEffect(selectedEvents.contains(event.idEvent ?? "") ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: selectedEvents.contains(event.idEvent ?? ""))
        .onTapGesture {
            if isSelectionMode {
                toggleSelection(for: event)
            } else {
                // Navigate to event detail or perform default action
                handleEventTap(event)
            }
        }
    }
    
    // MARK: - Selection Toolbar
    private var selectionToolbar: some View {
        HStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if selectedEvents.count == filteredEvents.count {
                        selectedEvents.removeAll()
                    } else {
                        selectedEvents = Set(filteredEvents.compactMap { $0.idEvent })
                    }
                }
            }) {
                
                Image(systemName: selectedEvents.count == filteredEvents.count ?  "checklist.unchecked" : "checklist.checked")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Text("\(selectedEvents.count) selected")
                .font(.caption)
                .foregroundColor(.secondary)
                .contentTransition(.numericText())
            
            Spacer()
            
            Button(action: {
                removeSelectedEvents()
            }) {
                Label("Remove", systemImage: "heart.slash")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            .disabled(selectedEvents.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
    }
    
    // MARK: - Empty State Views
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("No Favorite Events")
                .font(.title3.bold())
            
            Text("Events you like will appear here")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
    
    private var searchEmptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            Text("No Results")
                .font(.title3.bold())
            
            Text("Try searching with different keywords")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}

// MARK: - Methods
extension LikeRouteView {
    private func loadLikedEvents() {
        withAnimation(.easeInOut(duration: 0.3)) {
            events = eventSwiftDataVM.events.filter { $0.like == true }
        }
    }
    
    private func toggleSelection(for event: EventSwiftData) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if let eventId = event.idEvent {
                if selectedEvents.contains(eventId) {
                    selectedEvents.remove(eventId)
                } else {
                    selectedEvents.insert(eventId)
                }
            }
        }
    }
    
    private func showDeleteConfirmation(for event: EventSwiftData) {
        eventToDelete = event
        showingDeleteAlert = true
    }
    
    private func handleToggleLike(_ event: EventSwiftData) {
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        Task {
            do {
                _ = try await eventSwiftDataVM.toggleLike(event)
                
                // Remove from local list with animation
                withAnimation(.easeInOut(duration: 0.4)) {
                    events.removeAll(where: { $0.idEvent == event.idEvent })
                }
                
                // Update the toggle manager
                eventToggleLikeManager.toggleLikeOnUI(at: event.idEvent ?? "", by: false)
                
            } catch {
                print("❌ Failed to toggle like: \(error)")
                // You might want to show an error message here
            }
        }
    }
    
    private func deleteEvents(at offsets: IndexSet) {
        let eventsToDelete = offsets.map { filteredEvents[$0] }
        
        for event in eventsToDelete {
            handleToggleLike(event)
        }
    }
    
    private func removeSelectedEvents() {
       let eventsToRemove = events.filter { event in
           selectedEvents.contains(event.idEvent ?? "")
       }
       
       guard !eventsToRemove.isEmpty else { return }
       
       // Add haptic feedback
       let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
       impactFeedback.impactOccurred()
       
       // Update UI immediately
       withAnimation(.easeInOut(duration: 0.4)) {
           events.removeAll { event in
               selectedEvents.contains(event.idEvent ?? "")
           }
           isSelectionMode = false
           selectedEvents.removeAll()
       }
       
       // Handle batch toggle like operation
       Task {
           await handleBatchToggleLike(eventsToRemove)
       }
   }
    
    // New batch toggle like method
    private func handleBatchToggleLike(_ events: [EventSwiftData]) async {
        do {
            for event in events {
                _ = try await eventSwiftDataVM.toggleLike(event)
                eventToggleLikeManager.toggleLikeOnUI(at: event.idEvent ?? "", by: false)
            }
        } catch {
            print("❌ Failed to batch toggle like: \(error)")
            // Reload events if batch operation fails
            DispatchQueue.main.async {
                self.loadLikedEvents()
            }
        }
    }
    
    private func handleEventTap(_ event: EventSwiftData) {
        // Add your navigation logic here
        // For example: navigate to event detail
        print("Tapped on event: \(event.eventName ?? "")")
    }
    
    private func shareEvent(_ event: EventSwiftData) {
        // Implement share functionality
        guard let eventName = event.eventName else { return }
        
        let shareText = "Check out this match: \(eventName)"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}
