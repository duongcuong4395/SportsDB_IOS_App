//
//  PreviousAndNextRounrEventView.swift
//  SportsDB
//
//  Created by Macbook on 31/5/25.
//

import SwiftUI

struct PreviousAndNextRounrEventView: View {
    
    var currentRound: Int
    var hasNextRound: Bool
    var nextRoundTapped: () -> Void
    var previousRoundTapped: () -> Void
    
    var body: some View {
        HStack {
            if currentRound > 1 {
                Text("< Previous")
                    .font(.callout)
                    .onTapGesture {
                        previousRoundTapped()
                        
                    }
            }
            Text("Round: \(currentRound)")
                .font(.callout.bold())
            
            if hasNextRound == true {
                Text("Next >")
                    .font(.callout)
                    .onTapGesture {
                        nextRoundTapped()
                    }
            }
            
            Spacer()
        }
    }
}
