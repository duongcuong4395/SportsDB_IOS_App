//
//  ItemDelegate.swift
//  SportsDB
//
//  Created by Macbook on 2/6/25.
//

import SwiftUI

enum EventAction {
    case toggleFavorite
    case toggleNotify
    case openPlayVideo
    case viewDetail
    case pushFireBase
    case selected
    case drawOnMap
}

protocol ItemDelegate {
    func performAction<T: Equatable>(_ action: EventAction, for model: T)
    
    func toggleLike<T: Equatable>(for model: T)
    func toggleFavorite<T: Equatable>(for model: T)
    func toggleNotify<T: Equatable>(for model: T)
    func openPlayVideo<T: Equatable>(for model: T)
    
    func viewDetail<T: Equatable>(for model: T)
    func pushFireBase<T: Equatable>(for model: T)
    func selected<T: Equatable>(for model: T)
}

extension ItemDelegate {
    func viewOnMap<T: Equatable>(for model: T) {
        return
    }
    
    func toggleLike<T: Equatable>(for model: T) {
        return
    }
    
    func toggleFavorite<T: Equatable>(for model: T) {
        return
    }
    
    func toggleNotify<T: Equatable>(for model: T) {
        return
    }
    
    func openPlayVideo<T: Equatable>(for model: T) {
        return
    }
    
    func viewRoute<T: Equatable>(for model: T) {
        return
    }
    
    func viewDetail<T: Equatable>(for model: T) {
        return
    }
    
    
    func pushFireBase<T: Equatable>(for model: T) {
        return
    }
    
    func drawOnMap<T: Equatable>(for model: T) {
        return
    }
    
    func selected<T: Equatable>(for model: T) {
        return
    }
    
    func getRoute<T: Equatable>(for model: T) {
        return
    }
}

// MARK: - Item Options View
enum IconDetailType: String {
    case Default = "ellipsis.circle"
    case Down = "chevron.down"
    case Up = "chevron.up"
    case Right = "chevron.right"
    case Route3D = "move.3d"
    case Route = "point.topleft.down.curvedto.point.filled.bottomright.up"
    case RouteBranch = "arrow.triangle.branch"
    case RouteSwap = "arrow.triangle.swap"
    case Star = "wand.and.stars"
    case MultiStar = "sparkles"
}


protocol ItemOptionsBuilder: Equatable {
    
    func getFavorite() -> Bool
    func getNotify() -> Bool
}

extension ItemOptionsBuilder {
    
    @ViewBuilder
    func getBtnAction(with event: ItemDelegate, icon: String, action: EventAction) -> some View {
        buildItemButton(with: icon) {
            event.performAction(action, for: self)
        }
    }
    
    @ViewBuilder
    private func buildItemButton(with imageName: String,  action: @escaping () -> Void) -> some View {
        Image(systemName: imageName)
            .onTapGesture {
                action()
            }
    }
    
    // =======================
    
    @ViewBuilder
    func getBtnFavorie(with event: ItemDelegate) -> some View {
        getBtnAction(with: event, icon: getFavorite() ? "heart.fill" : "heart", action: .toggleFavorite)
    }
    
    @ViewBuilder
    func getBtnNotify(with event: ItemDelegate) -> some View {
        getBtnAction(with: event, icon: getNotify() ? "bell.fill" : "bell", action: .toggleNotify)
    }
    
    @ViewBuilder
    func getBtnOpenVideo(with event: ItemDelegate) -> some View {
        getBtnAction(with: event, icon: "play.rectangle", action: .openPlayVideo)
    }
    
    @ViewBuilder
    func getBtnViewDetail(with event: ItemDelegate, type: IconDetailType = .Default) -> some View {
        getBtnAction(with: event, icon: type.rawValue, action: .viewDetail)
    }
    
    @ViewBuilder
    func getBtnPushFireBase(with event: ItemDelegate) -> some View {
        getBtnAction(with: event, icon: "clound", action: .pushFireBase)
    }
    
    @ViewBuilder
    func getBtnDrawOnMap(with event: ItemDelegate) -> some View {
        getBtnAction(with: event, icon: "gearshape.2", action: .drawOnMap)
    }
    
    @ViewBuilder
    func getBtnSelected(with event: ItemDelegate) -> some View {
        getBtnAction(with: event, icon: "hand.tap.fill", action: .selected)
    }
}
