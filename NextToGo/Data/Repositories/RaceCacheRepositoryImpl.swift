//
//  RaceCacheRepositoryImpl.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import Foundation
import SwiftData

@MainActor
final class RaceCacheRepositoryImpl: RaceCacheRepository {

    // MARK: Lifecycle

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: Internal

    func saveRaces(_ races: [Race]) async throws {
        try await clearCache() // Clear before writing
        for race in races {
            let entity = RaceEntity(
                id: race.id,
                number: race.raceNumber,
                meetingName: race.meetingName,
                category: race.category.rawValue,
                advertisedStart: race.advertisedStart,
                raceName: race.raceName,
                venueCountry: race.venueCountry)
            modelContext.insert(entity)
        }
        try modelContext.save()
    }

    func loadCachedRaces() async throws -> [Race] {
        let descriptor = FetchDescriptor<RaceEntity>(sortBy: [SortDescriptor(\.advertisedStart)])
        let entities = try modelContext.fetch(descriptor)

        return entities.map {
            Race(
                id: $0.id,
                meetingName: $0.meetingName,
                raceNumber: $0.raceNumber,
                raceName: $0.raceName,
                category: RaceCategory(rawValue: $0.category) ?? .greyhound,
                advertisedStart: $0.advertisedStart,
                venueCountry: $0.venueCountry)
        }
    }

    func clearCache() async throws {
        let descriptor = FetchDescriptor<RaceEntity>()

        let all = try modelContext.fetch(descriptor)
        for entity in all {
            modelContext.delete(entity)
        }
    }

    // MARK: Private

    private let modelContext: ModelContext
}
