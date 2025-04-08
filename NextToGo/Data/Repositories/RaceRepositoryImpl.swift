//
//  RaceRepositoryImpl.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import Foundation

final class RaceRepositoryImpl: RaceRepository {

    // MARK: Lifecycle

    init(remote: NedsAPIClient = NedsAPIClient(), local: LocalRaceDataSource) {
        self.remote = remote
        self.local = local
    }

    // MARK: Internal

    typealias RemoteRaceDataSource = NedsAPIClient
    typealias LocalRaceDataSource = RaceCacheRepository

    func fetchNextRaces(count: Int) async throws -> [Race] {
        do {
            let data = try await remote.fetchNextRacesData(count: count)

            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(NextRacesResponse.self, from: data)

            var races: [Race] = []
            let raceData = apiResponse.data
            for raceID in raceData.nextToGoIDS {
                guard let summary = raceData.raceSummaries[raceID] else {
                    continue // if an ID is missing a summary, skip it.
                }
                guard let seconds = summary.advertisedStart.seconds, seconds > 0 else {
                    continue
                }
                let startDate = Date(timeIntervalSince1970: seconds)
                // Map category_id string to our RaceCategory enum (if the ID isn't one of the known categories, skip).
                guard let category = RaceCategory(rawValue: summary.categoryID) else {
                    continue
                }

                let race = Race(
                    id: raceID,
                    meetingName: summary.meetingName,
                    raceNumber: summary.raceNumber,
                    category: category,
                    advertisedStart: startDate)
                races.append(race)
            }
            try await local.saveRaces(races)

            return races
        } catch {
            // fetchRacesLocalCopy() // Uncomment this line and comment the below one to have a rough persistent storage
            // solution
            throw error
        }
    }

    func fetchRacesLocalCopy() async throws -> [Race] {
        try await local.loadCachedRaces()
    }

    // MARK: Private

    private let remote: RemoteRaceDataSource
    private let local: LocalRaceDataSource

}
