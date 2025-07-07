//
//  AsyncImageView.swift
//  SportsDB
//
//  Created by Macbook on 6/6/25.
//

import SwiftUI

struct AsyncImageView: View {
    let url: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .shadow(color: .blue, radius: 2)
        }
        .frame(width: width, height: height)
        .cornerRadius(8)
    }
}


struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
