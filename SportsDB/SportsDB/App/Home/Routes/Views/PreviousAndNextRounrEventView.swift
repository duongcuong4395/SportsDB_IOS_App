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
                //Text("< Previous")
                Image(systemName: "chevron.left")
                    //.font(.callout.bold())
                    .font(.title3)
                    .backgroundByTheme(for: .Button(material: .ultraThin, cornerRadius: .roundedCorners))
                    //.backgroundOfItemTouched()
                    .onTapGesture {
                        previousRoundTapped()
                        
                    }
            }
            Spacer()
            Text("Round: \(currentRound)")
                .font(.callout.bold())
            Spacer()
            if hasNextRound == true {
                //Text("Next >")
                Image(systemName: "chevron.right")
                    //.font(.callout.bold())
                    .font(.title3)
                    //.backgroundOfItemTouched()
                    .backgroundByTheme(for: .Button(material: .ultraThin, cornerRadius: .roundedCorners))
                    .onTapGesture {
                        nextRoundTapped()
                    }
            }
        }
    }
}
