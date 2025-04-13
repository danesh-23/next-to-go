//
//  APIClientTests.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-13.
//

import Foundation
import Testing
@testable import NextToGo

struct RaceRepositoryTests {
    @Test("Successfully fetches and parses remote races")
    func testSuccessfulRemoteFetch() async throws {
        let mockAPI = MockAPI()
        guard
            let mockSummary = MockAPI.raceResponseSuccess.data.raceSummaries[MockAPI.raceID],
            let seconds = mockSummary.advertisedStart.seconds
        else { return }
        let dateMockStart = Date(timeIntervalSince1970: floor(seconds))

        let repository = RaceRepositoryImpl(remote: mockAPI)
        let races = try await repository.fetchNextRaces(count: 1)

        #expect(races.count == 1)
        #expect(races[0].raceNumber == mockSummary.raceNumber)
        #expect(races[0].id == mockSummary.raceID)
        #expect(races[0].raceName == mockSummary.raceName)
        #expect(races[0].category.rawValue == mockSummary.categoryID)
        #expect(races[0].meetingName == mockSummary.meetingName)
        #expect(races[0].advertisedStart.roundedToSecond == dateMockStart.roundedToSecond)
        #expect(races[0].venueCountry == mockSummary.venueCountry)
    }

    @Test("Throws error on remote failure")
    func testThrowsErrorOnFailure() async {
        let mockAPI = MockAPI(shouldThrow: true, errorToThrow: APIError.noInternet(URLError(.notConnectedToInternet)))
        let repository = RaceRepositoryImpl(remote: mockAPI)

        do {
            _ = try await repository.fetchNextRaces(count: 1)
            #expect(Bool(false), "Expected error was not thrown")
        } catch {
            #expect(error is APIError)
        }
    }

    @Test("Skips races with invalid advertisedStart seconds")
    func testSkipsInvalidTime() async throws {
        let mockData = MockAPI.raceResponseSuccess
        guard let raceWithID = mockData.data.raceSummaries[MockAPI.raceID] else { return }
        let invalidStartTTimeMock = mockData
            .copyWith(
                data: mockData.data
                    .copyWith(
                        raceSummaries: [
                            MockAPI.raceID: raceWithID
                                .copyWith(advertisedStart: AdvertisedStart(seconds: 0))
                        ]))
        let mockAPI = MockAPI(raceResponse: invalidStartTTimeMock)

        let repository = RaceRepositoryImpl(remote: mockAPI)
        let races = try await repository.fetchNextRaces(count: 1)
        #expect(races.isEmpty)
    }

    @Test("Skips races with unknown category ID")
    func testSkipsInvalidCategory() async throws {
        let mockData = MockAPI.raceResponseSuccess
        guard let raceWithID = mockData.data.raceSummaries[MockAPI.raceID] else { return }
        let invalidStartTTimeMock = mockData
            .copyWith(
                data: mockData.data
                    .copyWith(
                        raceSummaries: [
                            MockAPI.raceID: raceWithID
                                .copyWith(categoryID: "invalid-id")
                        ]))
        let mockAPI = MockAPI(raceResponse: invalidStartTTimeMock)

        let repository = RaceRepositoryImpl(remote: mockAPI)
        let races = try await repository.fetchNextRaces(count: 1)
        #expect(races.isEmpty)
    }
}
