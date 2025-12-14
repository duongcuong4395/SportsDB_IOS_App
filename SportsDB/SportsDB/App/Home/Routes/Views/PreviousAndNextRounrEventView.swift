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
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .backgroundByTheme(for: .Button(cornerRadius: .roundedCorners))
                    .onTapGesture {
                        previousRoundTapped()
                        
                    }
            }
            Spacer()
            Text("Round: \(currentRound)")
                .font(.callout.bold())
            Spacer()
            if hasNextRound == true {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .backgroundByTheme(for: .Button(cornerRadius: .roundedCorners))
                    .onTapGesture {
                        nextRoundTapped()
                    }
            }
        }
    }
}
