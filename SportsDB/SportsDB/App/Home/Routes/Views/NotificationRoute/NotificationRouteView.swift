//
//  NotificationRouteView.swift
//  SportsDB
//
//  Created by Macbook on 12/8/25.
//

import SwiftUI
import UserNotifications
import Kingfisher

struct NotificationRouteView: View {
    @EnvironmentObject var notificationListVM: NotificationListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventSwiftDataVM: EventSwiftDataViewModel
    @EnvironmentObject var eventToggleNotificationManager: EventToggleNotificationManager
    
    @State private var notifications: [NotificationItem] = []
    
    @State private var searchText: String = ""
    @State private var showingDeleteAlert: Bool = false
    @State private var notifyToDelete: NotificationItem?
    @State private var isSelectionMode: Bool = false
    @State private var selectedNotify: Set<String> = []
    
    var filteredNotification: [NotificationItem] {
        if searchText.isEmpty {
            return notifications
        } else {
            return notifications.filter { event in
                (event.title.localizedCaseInsensitiveContains(searchText)) ||
                (event.body.localizedCaseInsensitiveContains(searchText))
            }
        }
    }
    
    var body: some View {
        VStack {
            header
            
            if !notifications.isEmpty {
                searchBarView
                    .padding(.vertical)
            }
            
            contentView
        }
        .onAppear{
            loadNotifySaved()
        }
        .alert("Remove from notification saved", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                if let notify = notifyToDelete {
                    print("=== remove noti")
                    handleToggleNotification(notify)
                } else {
                    print("=== no noti remove")
                }
            }
        } message: {
            Text("Are you sure you want to remove this item from your notification saved?")
        }
    }
    
    
    func loadNotifySaved() {
        
        
        Task {
            await notificationListVM.loadNotifications()
            withAnimation(.easeInOut(duration: 0.3)) {
                notifications = notificationListVM.notifications
            }
        }
    }
    
    
}

// MARK: Search Bar View
extension NotificationRouteView {
    
    @ViewBuilder
    var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search notify...", text: $searchText)
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
}

// MARK: Content
extension NotificationRouteView {
    @ViewBuilder
    var contentView: some View {
        if notifications.isEmpty {
            notifyStateView
        } else if filteredNotification.isEmpty && !searchText.isEmpty {
            searchEmptyStateView
        } else {
            notificationsListView
        }
    }
    
    @ViewBuilder
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
    
    @ViewBuilder
    private var notificationsListView: some View {
        // Selection toolbar
        if isSelectionMode && !selectedNotify.isEmpty {
            selectionToolbar
        }
        
        List {
            ForEach(filteredNotification, id: \.id) { event in
                notifyRowView(event)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }
            .onDelete(perform: deleteEvents)
        }
        .listStyle(PlainListStyle())
        .environment(\.editMode, .constant(isSelectionMode ? .active : .inactive))
        .padding(0)
        /*
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(notificationListVM.notifications, id: \.id) { noti in
                    notifyRowView(noti)
                }
            }
            .padding(.horizontal, 10)
        }
        */
    }
    
    private func deleteEvents(at offsets: IndexSet) {
        let eventsToDelete = offsets.map { filteredNotification[$0] }
        
        for event in eventsToDelete {
            handleToggleNotification(event)
        }
    }
    
    private func notifyRowView(_ noti: NotificationItem) -> some View {
        HStack {
            // Selection checkbox
            if isSelectionMode {
                Button(action: {
                    toggleSelection(for: noti)
                }) {
                    Image(systemName: selectedNotify.contains(noti.id) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedNotify.contains(noti.id) ? .blue : .secondary)
                        .font(.title3)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            KFImage(URL(string: noti.userInfo["poster"] ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .cornerRadius(15)
            VStack(alignment: .leading) {
                Text(noti.title)
                    .font(.footnote.bold())
                
                Text(noti.userInfo["leagueName"] ?? "")
                    .font(.caption.bold())
                + Text("(\(noti.userInfo["season"] ?? ""))")
                    .font(.caption)
                Text(noti.userInfo["dateTime"] ?? "")
                    .font(.caption2)
            }
            
            Spacer()
            
            
            // Actions
            if !isSelectionMode {
                Menu {
                    Button(action: {
                        showDeleteConfirmation(for: noti)
                    }) {
                        Label("Remove from Favorites", systemImage: "heart.slash")
                    }
                    
                    Button(action: {
                        // Add share functionality
                        shareEvent(noti)
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
        .padding(10)
        .background{
            Color.clear
                .liquidGlass(cornerRadius: 15, intensity: 0.3, tintColor: .orange, hasShimmer: true, hasGlow: true)
        }
        .background(.ultraThinMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        .padding([.top, .leading], 13)
        .overlay(alignment: .topLeading) {
            SportType(rawValue: noti.userInfo["sportType"] ?? "")?.getIcon()
                .frame(width: 30, height: 30)
                //.frame(width: 25, height: 25)
                //.offset(x: -5, y: -5)
        }
        .scaleEffect(selectedNotify.contains(noti.id) ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: selectedNotify.contains(noti.id))
        .onTapGesture {
            if isSelectionMode {
                toggleSelection(for: noti)
            } else {
                // Navigate to event detail or perform default action
                handleEventTap(noti)
            }
        }
        
        
    }
    
    private func handleEventTap(_ event: NotificationItem) {
        // Add your navigation logic here
        // For example: navigate to event detail
        print("Tapped on event: \(event.title)")
    }
    
    
    private func showDeleteConfirmation(for event: NotificationItem) {
        notifyToDelete = event
        showingDeleteAlert = true
    }
    
    private func toggleSelection(for event: NotificationItem) {
        withAnimation(.easeInOut(duration: 0.2)) {
            let eventId = event.id
            if selectedNotify.contains(eventId) {
                selectedNotify.remove(eventId)
            } else {
                selectedNotify.insert(eventId)
            }
        }
    }
    
    func handleToggleNotification(_ notify: NotificationItem) {
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        Task {
            await notificationListVM.removeNotification(id: notify.id)
            await notificationListVM.loadNotifications()
            // Remove from local list with animation
            withAnimation(.easeInOut(duration: 0.4)) {
                notifications.removeAll(where: { $0.id == notify.id })
            }
            eventToggleNotificationManager.toggleNotificationOnUI(at: notify.userInfo["idEvent"] ?? "", by: .idle)
        }
    }
    
    // MARK: - Selection Toolbar
    private var selectionToolbar: some View {
        HStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if selectedNotify.count == filteredNotification.count {
                        selectedNotify.removeAll()
                    } else {
                        selectedNotify = Set(filteredNotification.compactMap { $0.id })
                    }
                }
            }) {
                Text(selectedNotify.count == filteredNotification.count ? "Deselect All" : "Select All")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Text("\(selectedNotify.count) selected")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: {
                removeSelectedNotify()
            }) {
                Label("Remove", systemImage: "heart.slash")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            .disabled(selectedNotify.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
    }
    
    private func removeSelectedNotify() {
        let eventsToRemove = notifications.filter { event in
            selectedNotify.contains(event.id)
       }
       
       guard !eventsToRemove.isEmpty else { return }
       
       // Add haptic feedback
       let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
       impactFeedback.impactOccurred()
       
       // Update UI immediately
       withAnimation(.easeInOut(duration: 0.4)) {
           notifications.removeAll { event in
               selectedNotify.contains(event.id)
           }
           isSelectionMode = false
           selectedNotify.removeAll()
       }
       
       // Handle batch toggle like operation
       Task {
           await handleBatchToggleNotify(eventsToRemove)
       }
   }
    
    // New batch toggle like method
    private func handleBatchToggleNotify(_ events: [NotificationItem]) async {
        do {
            for notify in events {
                await notificationListVM.removeNotification(id: notify.id)
                await notificationListVM.loadNotifications()
                
                eventToggleNotificationManager.toggleNotificationOnUI(at: notify.userInfo["idEvent"] ?? "", by: .idle)
            }
        } catch {
            print("❌ Failed to batch toggle like: \(error)")
            // Reload events if batch operation fails
            DispatchQueue.main.async {
                //self.loadLikedEvents()
            }
        }
    }
    
    private func shareEvent(_ event: NotificationItem) {
        // Implement share functionality
        let eventName = event.title
        
        let shareText = "Check out this match: \(eventName)"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    // MARK: - Empty State Views
    private var notifyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("No Notifications")
                .font(.title3.bold())
            
            Text("Notifications you Saved will appear here")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}

// MARK: Header
extension NotificationRouteView {
    @ViewBuilder
    var header: some View {
        HStack(spacing: 10) {
            Button(action: {
                sportRouter.pop()
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
            })
            HStack(spacing: 5) {
                Image(systemName: notificationListVM.notifications.count > 0 ? "bell.fill" : "bell")
                    .font(.body)
                    
                Text("Notification")
                    .font(.body.bold())
            }
            .onTapGesture {
                sportRouter.pop()
            }
            Spacer()
            
            if !notifications.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isSelectionMode.toggle()
                        selectedNotify.removeAll()
                    }
                }) {
                    Text(isSelectionMode ? "Done" : "Select")
                        .font(.body)
                        .foregroundColor(.blue)
                }
            }
        }
        .backgroundOfRouteHeaderView(with: 70)
    }
}
