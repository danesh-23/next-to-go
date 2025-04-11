//
//  CategoryFilterView.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import SwiftUI

struct CategoryFilterView: View {
    let categoryName: String
    let imageName: String
    let isSelected: Bool
    let toggle: () -> Void

    var body: some View {
        Button(action: toggle) {
            HStack(spacing: 4) {
                // Always show a circle, color depends on selection
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .green : .gray)
                    .font(.title2)

                VStack(spacing: 4) {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .opacity(isSelected ? 1.0 : 0.5)

                    Text(categoryName)
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
            .padding(8)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .animation(.easeInOut(duration: 0.25), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityElement()
        .accessibilityLabel("Filter by \(categoryName)")
        .accessibilityHint(isSelected ? "Selected" : "Not selected")
    }
}
