//
//  GetNextRacesUseCaseTests.swift
//  NextToGoTests
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import Foundation
@testable import NextToGo
import Testing

struct GetNextRacesUseCaseTests {
    @Test("Filters by selected categories")
    func testFiltersByCategory() async throws {
        let now = Date()
        let horseRace = Race.stub(id: "1", category: .horse, start: now.addingTimeInterval(300))
        let greyhoundRace = Race.stub(id: "2", category: .greyhound, start: now.addingTimeInterval(300))
        let stubbedRaces = [horseRace, greyhoundRace]

        let repo = MockRaceRepository(stubbedRaces: stubbedRaces)

        let useCase = GetNextRacesUseCaseImpl(repository: repo)
        let result = try await useCase.execute(for: [.horse], isINTL: true, currentRaces: [])

        #expect(result.allSatisfy { $0.category == .horse })
    }

    @Test("Excludes races expired by more than 60s")
    func testExcludesExpiredRaces() async throws {
        let now = Date()
        let expired = Race.stub(id: "1", category: .harness, start: now.addingTimeInterval(-120))
        let valid = Race.stub(id: "2", category: .harness, start: now.addingTimeInterval(120))
        let stubbedRaces = [expired, valid]

        let repo = MockRaceRepository(stubbedRaces: stubbedRaces)

        let useCase = GetNextRacesUseCaseImpl(repository: repo)
        let result = try await useCase.execute(for: [.harness], isINTL: true, currentRaces: [])

        #expect(result == [valid])
    }

    @Test("Preserves valid races already present")
    func testPreservesValidCurrentRaces() async throws {
        let now = Date()
        let current = Race.stub(id: "1", category: .horse, start: now.addingTimeInterval(60))
        let stubbedRaces: [Race] = [] // Empty new fetch

        let repo = MockRaceRepository(stubbedRaces: stubbedRaces)

        let useCase = GetNextRacesUseCaseImpl(repository: repo)
        let result = try await useCase.execute(for: [.horse], isINTL: true, currentRaces: [current])

        #expect(result.contains(where: { $0.id == current.id }))
    }

    @Test("Adds new races if less than 5 are present")
    func testTopsUpWhenUnderFive() async throws {
        let now = Date()
        let current = Race.stub(id: "1", category: .horse, start: now.addingTimeInterval(60))
        let secondRace = Race.stub(id: "2", category: .horse, start: now.addingTimeInterval(120))
        let thirdRace = Race.stub(id: "3", category: .horse, start: now.addingTimeInterval(180))
        let fourthRace = Race.stub(id: "4", category: .horse, start: now.addingTimeInterval(120))
        let fifthRace = Race.stub(id: "5", category: .horse, start: now.addingTimeInterval(180))
        let stubbedRaces = [secondRace, thirdRace]
        let backupStubbedRaces = [fourthRace, fifthRace]

        let repo = MockRaceRepository(stubbedRaces: stubbedRaces, backupStubbedRaces: backupStubbedRaces)

        let useCase = GetNextRacesUseCaseImpl(repository: repo)
        let result = try await useCase.execute(for: [RaceCategory.horse], isINTL: true, currentRaces: [current])

        #expect(result.count == 5)
    }

    @Test("Avoids duplicates between current and new races")
    func testAvoidsDuplicateRaces() async throws {
        let now = Date()
        let race = Race.stub(id: "1", category: .horse, start: now.addingTimeInterval(60))
        let stubbedRaces = [race] // already exists in currentRaces

        let repo = MockRaceRepository(stubbedRaces: stubbedRaces)

        let useCase = GetNextRacesUseCaseImpl(repository: repo)
        let result = try await useCase.execute(for: [.horse], isINTL: true, currentRaces: [race])
        #expect(result.count == 1)
    }

    @Test("Triggers race list refresh when more categories are selected")
    func testReplacesWhenCategoryBroadens() async throws {
        let now = Date()
        let horseRace = Race.stub(id: "1", category: .horse, start: now.addingTimeInterval(120))
        let greyhoundRace = Race.stub(id: "2", category: .greyhound, start: now.addingTimeInterval(90))
        let stubbedRaces = [horseRace, greyhoundRace]
        let previouslySelectedHarness = Race.stub(id: "3", category: .harness, start: now.addingTimeInterval(120))

        let repo = MockRaceRepository(stubbedRaces: stubbedRaces)

        let useCase = GetNextRacesUseCaseImpl(repository: repo)

        let result = try await useCase.execute(
            for: [.horse, .greyhound],
            isINTL: true,
            currentRaces: [previouslySelectedHarness])

        let containsBoth = result.contains(where: { $0.category == .horse }) && result
            .contains(where: { $0.category == .greyhound })
        #expect(containsBoth)
        #expect(result.count == 2)
    }

    @Test("Filters results based on local or INTL country", arguments: [(true, 2, ["1", "2"]), (false, 1, ["3"])])
    func testFiltersCountriesINTL(intl: Bool, expectedCount: Int, expectedIDs: [String]) async throws {
        let now = Date()
        let races: [Race] = [
            Race.stub(id: "1", category: .horse, start: now.addingTimeInterval(60), venueCountry: "CAN"),
            Race.stub(id: "2", category: .greyhound, start: now.addingTimeInterval(60), venueCountry: "USA"),
            Race.stub(id: "3", category: .harness, start: now.addingTimeInterval(60), venueCountry: "AUS")
        ]
        let stubbedRaces = races

        let repo = MockRaceRepository(stubbedRaces: stubbedRaces)

        let useCase = GetNextRacesUseCaseImpl(repository: repo)
        let result = try await useCase.execute(for: [.horse, .greyhound, .harness], isINTL: intl, currentRaces: [])

        #expect(result.count == expectedCount)
        for id in expectedIDs {
            #expect(result.contains(where: { $0.id == id }))
        }
    }
}
