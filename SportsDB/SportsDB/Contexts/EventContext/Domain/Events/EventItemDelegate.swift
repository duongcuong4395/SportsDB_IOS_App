//
//  EventItemDelegate.swift
//  SportsDB
//
//  Created by Macbook on 2/6/25.
//


import SwiftUI


extension Event: ItemOptionsBuilder {
    func getFavorite() -> Bool {
        return true
    }
    
    func getNotify() -> Bool {
        return true
    }
}


