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
    private func eventRowView(_ event: EventSwiftData) -> some View {
        HStack {
            // Selection checkbox
            if manageLikeRouteVM.isSelectionMode {
                Button(action: {
                    manageLikeRouteVM.toggleSelection(for: event)
                }) {
                    Image(systemName: manageLikeRouteVM.selectedEvents.contains(event.idEvent ?? "") ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(manageLikeRouteVM.selectedEvents.contains(event.idEvent ?? "") ? .blue : .secondary)
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
            if !manageLikeRouteVM.isSelectionMode {
                Menu {
                    Button(action: {
                        manageLikeRouteVM.showDeleteConfirmation(for: event)
                    }) {
                        Label("Remove from Favorites", systemImage: "heart.slash")
                    }
                    
                    Button(action: {
                        // Add share functionality
                        manageLikeRouteVM.shareEvent(event)
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
        .scaleEffect(manageLikeRouteVM.selectedEvents.contains(event.idEvent ?? "") ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: manageLikeRouteVM.selectedEvents.contains(event.idEvent ?? ""))
        .onTapGesture {
            if manageLikeRouteVM.isSelectionMode {
                manageLikeRouteVM.toggleSelection(for: event)
            } else {
                // Navigate to event detail or perform default action
                manageLikeRouteVM.handleEventTap(event)
            }
        }
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
