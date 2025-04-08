//
//  RaceListViewModel.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-05.
//

import Foundation
import SwiftUI

@MainActor
class RaceListViewModel: ObservableObject {

    // MARK: Lifecycle

    init(useCase: GetNextRacesUseCase) {
        getNextRacesUseCase = useCase
        isLoading = true
        autoRefreshTask = Task {
            do {
                try await refreshRaces()
                self.errorMessage = nil
            } catch {
                self.errorMessage = "Failed to load races. Please check your connection and try again."
            }
            self.isLoading = false
            await startAutoRefreshLoop(interval: 5)
        }
    }

    deinit {
        autoRefreshTask?.cancel()
    }

    // MARK: Internal

    @Published private(set) var races: [Race] = []
    @Published var selectedCategories: Set<RaceCategory> = []
    @Published var errorMessage: String?
    @Published var isLoading = false

    var autoRefreshTask: Task<Void, Never>?

    func refreshManually() async {
        do {
            try await refreshRaces()
            errorMessage = nil
        } catch {
            errorMessage = "Could not refresh. Try again later."
        }
    }

    func toggleCategory(_ category: RaceCategory) async throws {
        withAnimation {
            if selectedCategories.contains(category) {
                selectedCategories.remove(category)
            } else {
                selectedCategories.insert(category)
            }
        }
        do {
            try await refreshRaces()
        } catch {
            errorMessage = "Failed to load races for selected filters."
        }
    }

    // MARK: Private

    private let getNextRacesUseCase: GetNextRacesUseCase

    /// Manually refreshes the races list (for pull-to-refresh & initial load).
    private func refreshRaces() async throws {
        do {
            let updatedRaces = try await getNextRacesUseCase.execute(
                for: selectedCategories,
                currentRaces: races)
            withAnimation {
                self.races = updatedRaces
            }
        } catch {
            throw error
        }
    }

    /// Starts an auto-refresh loop that periodically updates the races list.
    /// - Parameter interval: The interval in seconds between refresh attempts.
    private func startAutoRefreshLoop(interval: TimeInterval) async {
        // Use an indefinite loop that sleeps, refreshes, and repeats.
        while !Task.isCancelled {
            do {
                try await Task.sleep(nanoseconds: UInt64(interval * 1000000000))
            } catch {
                // Task cancelled during sleep
                break
            }
            do {
                try await refreshRaces()
                errorMessage = nil
            } catch {
                // Update error message but continue loop.
                errorMessage = "Error refreshing races. Will retry..."
            }
        }
    }

}
