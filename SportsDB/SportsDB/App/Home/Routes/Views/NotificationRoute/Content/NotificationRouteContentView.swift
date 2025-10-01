//
//  NotificationRouteContentView.swift
//  SportsDB
//
//  Created by Macbook on 30/8/25.
//

import SwiftUI
import Kingfisher
// import UserNotifications

struct NotificationRouteContentView: View {
    @EnvironmentObject var manageNotificationRouteVM: ManageNotificationRouteViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventDetailVM: EventDetailViewModel
    
    var body: some View {
        VStack {
            if !manageNotificationRouteVM.notifications.isEmpty {
                searchBarView
                    .padding(.vertical)
            }
            if manageNotificationRouteVM.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                contentView
            }
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        if manageNotificationRouteVM.notifications.isEmpty {
            notifyStateView
        } else if manageNotificationRouteVM.filteredNotification.isEmpty && !manageNotificationRouteVM.searchText.isEmpty {
            searchEmptyStateView
        } else {
            notificationsListView
        }
    }
    
}

extension NotificationRouteContentView {
    @ViewBuilder
    private var notificationsListView: some View {
        VStack {
            // Selection toolbar
            if manageNotificationRouteVM.isSelectionMode && !manageNotificationRouteVM.selectedNotify.isEmpty {
                selectionToolbar
            }
            
            List {
                ForEach(manageNotificationRouteVM.filteredNotification, id: \.id) { event in
                    notifyRowView(event)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                }
                .onDelete(perform: manageNotificationRouteVM.deleteEvents)
            }
            .listStyle(PlainListStyle())
            .environment(\.editMode, .constant(manageNotificationRouteVM.isSelectionMode ? .active : .inactive))
            .padding(0)
        }
        .padding(0)
    }
    
    
    
    // MARK: - Selection Toolbar
    private var selectionToolbar: some View {
        HStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if manageNotificationRouteVM.selectedNotify.count == manageNotificationRouteVM.filteredNotification.count {
                        manageNotificationRouteVM.resetNotifySelected()
                        //selectedNotify.removeAll()
                    } else {
                        manageNotificationRouteVM.selectedNotify = Set(manageNotificationRouteVM.filteredNotification.compactMap { $0.id })
                    }
                }
            }) {
                
                Image(systemName: manageNotificationRouteVM.selectedNotify.count == manageNotificationRouteVM.filteredNotification.count ?  "checklist.unchecked" : "checklist.checked")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Text("\(manageNotificationRouteVM.selectedNotify.count) selected")
                .font(.caption)
                .foregroundColor(.secondary)
                .contentTransition(.numericText())
                //.animation(.easeInOut(duration: 0.5), value: selectedNotify.count)
            
            Spacer()
            
            Button(action: {
                manageNotificationRouteVM.removeSelectedNotify()
            }) {
                Label("Remove", systemImage: "heart.slash")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            .disabled(manageNotificationRouteVM.selectedNotify.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
    }
}

// MARK: Search Empty State View
extension NotificationRouteContentView {
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
}

extension NotificationRouteContentView {
    private func notifyRowView(_ noti: NotificationItem) -> some View {
        
        EventRowView(
            event: noti.toEvent()
            , isSelectionMode: manageNotificationRouteVM.isSelectionMode
            , isSelectedEvent: manageNotificationRouteVM.selectedNotify.contains(noti.id)
            , toggleSelectionRow: { event in
                manageNotificationRouteVM.toggleSelection(for: noti)
            }
            , navigateToEventDetailRoute: { event in
                let event = noti.toEvent()
                eventDetailVM.setEventDetail(event)
                sportRouter.navigateToEventDetail()
            }
            , showDeleteConfirmation: {
                manageNotificationRouteVM.showDeleteConfirmation(for: noti)
            }
            , shareEvent: { event in
                manageNotificationRouteVM.shareEvent(noti)
            }
            , onTapGesture: { event in
                let event = noti.toEvent()
                eventDetailVM.setEventDetail(event)
                sportRouter.navigateToEventDetail()
                
                if manageNotificationRouteVM.isSelectionMode {
                    manageNotificationRouteVM.toggleSelection(for: noti)
                } else {
                    // Navigate to event detail or perform default action
                    manageNotificationRouteVM.handleEventTap(noti)
                }
            })
    }
}

struct EventRowView: View {
    let event: Event
    
    var isSelectionMode: Bool
    var isSelectedEvent: Bool
    var toggleSelectionRow: (Event) -> Void
    var navigateToEventDetailRoute: (Event) -> Void
    var showDeleteConfirmation: () -> Void
    var shareEvent: (Event) -> Void
    var onTapGesture: (Event) -> Void
    
    var body: some View {
        HStack {
            // Selection checkbox
            if isSelectionMode {
                Button(action: {
                    toggleSelectionRow(event)
                }) {
                    Image(systemName: isSelectedEvent ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelectedEvent ? .blue : .secondary)
                        .font(.title3)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            KFImage(URL(string: event.poster ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .cornerRadius(15)
            VStack(alignment: .leading) {
                Text(event.eventName ?? "")
                    .font(.footnote.bold())
                HStack {
                    Text(event.leagueName ?? "")
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
                        navigateToEventDetailRoute(event)
                    }) {
                        Label("info", systemImage: "info.circle")
                    }
                    
                    Button(action: {
                        showDeleteConfirmation()
                        //manageNotificationRouteVM.showDeleteConfirmation(for: noti)
                    }) {
                        Label("Remove", systemImage: "bell.slash")
                    }
                    
                    
                    Button(action: {
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
        .background{
            Color.clear
                .liquidGlass(cornerRadius: 15, intensity: 0.3, tintColor: .orange, hasShimmer: true, hasGlow: true)
        }
        .background(.ultraThinMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        .overlay(alignment: .topLeading) {
            SportType(rawValue: event.sportName ?? "")?.getIcon()
                .frame(width: 25, height: 25)
                .offset(x: -5, y: -5)
        }
        .scaleEffect(isSelectedEvent ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelectedEvent)
        .onTapGesture {
            onTapGesture(event)
        }
    }
}


// MARK: - Empty State Views
extension NotificationRouteContentView {
    private var notifyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell")
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

// MARK: Search Bar View
extension NotificationRouteContentView {
    @ViewBuilder
    var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search notify...", text: $manageNotificationRouteVM.searchText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !manageNotificationRouteVM.searchText.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        manageNotificationRouteVM.searchText = ""
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
