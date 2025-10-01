//
//  LikeRouteContentView.swift
//  SportsDB
//
//  Created by Macbook on 30/8/25.
//

import SwiftUI
import Kingfisher

struct LikeRouteContentView: View {
    @EnvironmentObject var manageLikeRouteVM: ManageLikeRouteViewModel
    @EnvironmentObject var eventDetailVM: EventDetailViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
    var body: some View {
        VStack {
            if !manageLikeRouteVM.events.isEmpty {
                searchBarView
                    .padding(.vertical)
            }
            contentView
        }
    }
}


// MARK: contentView
extension LikeRouteContentView {
    @ViewBuilder
    private var contentView: some View {
        if manageLikeRouteVM.events.isEmpty {
            emptyStateView
        } else if manageLikeRouteVM.filteredEvents.isEmpty && !manageLikeRouteVM.searchText.isEmpty {
            searchEmptyStateView
        } else {
            eventsListView
        }
    }
}

// MARK: Events List View
extension LikeRouteContentView {
    private var eventsListView: some View {
        VStack(spacing: 0) {
            // Selection toolbar
            if manageLikeRouteVM.isSelectionMode && !manageLikeRouteVM.selectedEvents.isEmpty {
                selectionToolbar
                    .padding(.bottom, 5)
            }
            
            List {
                ForEach(manageLikeRouteVM.filteredEvents, id: \.idEvent) { event in
                    eventRowView(event)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                }
                .onDelete(perform: manageLikeRouteVM.deleteEvents)
            }
            .listStyle(PlainListStyle())
            .environment(\.editMode, .constant(manageLikeRouteVM.isSelectionMode ? .active : .inactive))
            .padding(0)
        }
        .padding(0)
    }
    
    // MARK: - Event Row View
    private func eventRowView(_ eventDT: EventSwiftData) -> some View {
        EventRowView(
            event: eventDT.toEvent()
            , isSelectionMode: manageLikeRouteVM.isSelectionMode
            , isSelectedEvent: manageLikeRouteVM.selectedEvents.contains(eventDT.idEvent ?? "")
            , toggleSelectionRow: { newEvent in
                manageLikeRouteVM.toggleSelection(for: eventDT)
            }
            , navigateToEventDetailRoute: { newEvent in
                let event = eventDT.toEvent()
                eventDetailVM.setEventDetail(event)
                sportRouter.navigateToEventDetail()
            }
            , showDeleteConfirmation: {
                manageLikeRouteVM.showDeleteConfirmation(for: eventDT)
            }
            , shareEvent: { newEvent in
                manageLikeRouteVM.shareEvent(eventDT)
            }
            , onTapGesture: { newEvent in
                let event = eventDT.toEvent()
                eventDetailVM.setEventDetail(event)
                sportRouter.navigateToEventDetail()
                
                if manageLikeRouteVM.isSelectionMode {
                    manageLikeRouteVM.toggleSelection(for: eventDT)
                } else {
                    // Navigate to event detail or perform default action
                    manageLikeRouteVM.handleEventTap(eventDT)
                }
            })
    }
    
    // MARK: - Selection Toolbar
    private var selectionToolbar: some View {
        HStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if manageLikeRouteVM.selectedEvents.count == manageLikeRouteVM.filteredEvents.count {
                        manageLikeRouteVM.resetEventsSelected()
                        //selectedEvents.removeAll()
                    } else {
                        manageLikeRouteVM.selectedEvents = Set(manageLikeRouteVM.filteredEvents.compactMap { $0.idEvent })
                    }
                }
            }) {
                
                Image(systemName: manageLikeRouteVM.selectedEvents.count == manageLikeRouteVM.filteredEvents.count ?  "checklist.unchecked" : "checklist.checked")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Text("\(manageLikeRouteVM.selectedEvents.count) selected")
                .font(.caption)
                .foregroundColor(.secondary)
                .contentTransition(.numericText())
            
            Spacer()
            
            Button(action: {
                manageLikeRouteVM.removeSelectedEvents()
            }) {
                Label("Remove", systemImage: "heart.slash")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            .disabled(manageLikeRouteVM.selectedEvents.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
    }
}

// MARK: Search Empty State View
extension LikeRouteContentView {
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

// MARK: Empty State View
extension LikeRouteContentView {
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
}

// MARK: - Search Bar View
extension LikeRouteContentView {
    @ViewBuilder
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search events...", text: $manageLikeRouteVM.searchText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !manageLikeRouteVM.searchText.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        manageLikeRouteVM.searchText = ""
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


import Kingfisher




