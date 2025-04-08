//
//  GetNextRacesUseCase.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import Foundation

// MARK: - GetNextRacesUseCase

/// Use case for retrieving the next-to-go races list, applying business rules (filtering, sorting, limiting).
protocol GetNextRacesUseCase: Sendable {
    /// Execute the use case to get next races according to selected categories.
    /// - Parameter categories: The set of categories the user wants to see. If empty, all categories are included.
    /// - Returns: Up to 5 Race entities matching the criteria (sorted by start time, not expired).
    func execute(for categories: Set<RaceCategory>, currentRaces: [Race]) async throws -> [Race]
}

// MARK: - GetNextRacesUseCaseImpl

struct GetNextRacesUseCaseImpl: GetNextRacesUseCase {

    // MARK: Lifecycle

    init(repository: RaceRepository) {
        self.repository = repository
    }

    // MARK: Internal

    func execute(for categories: Set<RaceCategory>, currentRaces: [Race]) async throws -> [Race] {
        do {
            let now = Date()
            let currentCategories = Set(currentRaces.map(\.category))

            let stillValidRaces: [Race] =
                if currentCategories == categories || categories.isEmpty {
                    // Reuse only if the same categories / no category selected to save on network call
                    currentRaces.filter {
                        categories.contains($0.category) && $0.advertisedStart.addingTimeInterval(60) > now
                    }
                } else {
                    // Don't reuse if user changed filters
                    []
                }

            var seenRaceIDs = Set(stillValidRaces.map(\.id))
            var validNewRaces: [Race] = []

            let maxDesired = 5
            var fetchCount = 10
            let maxFetchCap = 100

            while (stillValidRaces.count + validNewRaces.count) < maxDesired, fetchCount <= maxFetchCap {
                let allRaces = try await repository.fetchNextRaces(count: fetchCount)
                let newCandidates = allRaces.filter { !seenRaceIDs.contains($0.id) }

                // Break early to prevent infinite retry if no new races
                if newCandidates.isEmpty {
                    break
                }

                for race in newCandidates {
                    seenRaceIDs.insert(race.id)

                    guard categories.isEmpty || categories.contains(race.category) else { continue }
                    guard race.advertisedStart.addingTimeInterval(60) > now else { continue }

                    validNewRaces.append(race)

                    if (stillValidRaces.count + validNewRaces.count) == maxDesired {
                        break
                    }
                }

                if (stillValidRaces.count + validNewRaces.count) < maxDesired {
                    fetchCount += 10
                }
            }

            let combined = (stillValidRaces + validNewRaces)
                .sorted(by: { firstRace, secondRace in
                    let lhs = Int(firstRace.advertisedStart.timeIntervalSince1970)
                    let rhs = Int(secondRace.advertisedStart.timeIntervalSince1970)
                    if lhs != rhs {
                        return lhs < rhs
                    } else {
                        return firstRace.meetingName < secondRace.meetingName
                    }
                })

            return Array(combined.prefix(maxDesired))
        } catch {
            throw error
        }
    }

    // MARK: Private

    private let repository: RaceRepository

}
