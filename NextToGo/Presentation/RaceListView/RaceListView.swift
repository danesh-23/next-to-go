//
//  RaceListView.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import SwiftUI

struct RaceListView: View {

    // MARK: Internal

    @State var viewModel: RaceListViewModel

    var body: some View {
        NavigationView {
            VStack {
                categoryHeader
                Spacer()
                if viewModel.races.isEmpty {
                    if viewModel.isLoading {
                        ProgressView("Loading races...")
                            .accessibilityLabel("Loading races")
                    } else {
                        Text("No upcoming races")
                            .padding()
                    }
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        retryButton
                    }
                    .padding()
                } else {
                    racesList
                }
                Spacer()
            }
            .animation(.easeInOut(duration: 0.4), value: viewModel.races)
            .navigationTitle("Next To Go")
        }
    }

    // MARK: Private

    private var categoryHeader: some View {
        HStack(spacing: 12) {
            ForEach(RaceCategory.allCases, id: \.self) { category in
                CategoryFilterView(
                    categoryName: category.displayName,
                    imageName: category.symbolName,
                    isSelected: isFilterOn(category),
                    toggle: { Task { @MainActor in
                        try await viewModel.toggleCategory(category)
                    }
                    })
            }
        }
        .padding(.horizontal)
        .padding()
    }

    private var retryButton: some View {
        Button(action: {
            Task {
                viewModel.isLoading = true
                await viewModel.refreshManually()
                viewModel.isLoading = false
            }
        }, label: {
            HStack(spacing: 8) {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .imageScale(.medium)
                Text("Try Again")
                    .fontWeight(.semibold)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .accessibilityLabel("Retry loading races")
        })
    }

    private var racesList: some View {
        List(viewModel.races) { race in
            RaceRowView(race: race)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.races)
                .id(race.id)
        }
        .listStyle(PlainListStyle())
        .refreshable {
            await viewModel.refreshManually()
        }
    }

    /// Helper to determine if a category filter is on.
    private func isFilterOn(_ category: RaceCategory) -> Bool {
        viewModel.selectedCategories.isEmpty || viewModel.selectedCategories.contains(category)
    }
}
