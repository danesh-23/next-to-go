//
//  RaceRepositoryImpl.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import Foundation

final class RaceRepositoryImpl<Remote: API>: RaceRepository where Remote.Endpoint == RacingEndpoint {

    // MARK: Lifecycle

    init(remote: Remote = APIImpl<RacingEndpoint>(), local: LocalRaceDataSource? = nil) {
        self.remote = remote
        self.local = local
    }

    // MARK: Internal

    typealias RemoteRaceDataSource = API
    typealias LocalRaceDataSource = RaceCacheRepository

    func fetchNextRaces(count: Int) async throws -> [Race] {
        do {
            let endpoint = RacingEndpoint.nextRaces(count: count)
            let apiResponse: NextRacesResponse = try await remote.request(endpoint)

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
                    raceName: summary.raceName, category: category,
                    advertisedStart: startDate,
                    venueCountry: summary.venueCountry)
                races.append(race)
            }
            try await local?.saveRaces(races)

            return races
        } catch {
            // swiftlint:disable:next todo
            // TODO: SwiftData
            // fetchRacesLocalCopy()
            // Uncomment above line and comment the below one to have a rough persistent storage solution
            throw error
        }
    }

    func fetchRacesLocalCopy() async throws -> [Race] {
        guard let local else { return [] }
        return try await local.loadCachedRaces()
    }

    // MARK: Private

    private let remote: Remote
    private let local: LocalRaceDataSource?
}
