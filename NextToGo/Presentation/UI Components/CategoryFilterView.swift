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
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.orange)
                        .clipShape(Circle())
                }

                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Toggle \(categoryName)")
    }
}
