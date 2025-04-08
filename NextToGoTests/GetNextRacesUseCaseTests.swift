//
//  GetNextRacesUseCaseTests.swift
//  NextToGoTests
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import Foundation
import Testing
@testable import NextToGo

struct GetNextRacesUseCaseTests {
    @Test("Filters by selected categories")
    func testFiltersByCategory() async throws {
        let now = Date()
        let horseRace = Race.stub(id: "1", category: .horse, start: now.addingTimeInterval(300))
        let greyhoundRace = Race.stub(id: "2", category: .greyhound, start: now.addingTimeInterval(300))
        let stubbedRaces = [horseRace, greyhoundRace]

        let repo = MockRaceRepository(stubbedRaces: stubbedRaces)

        let useCase = GetNextRacesUseCaseImpl(repository: repo)
        let result = try await useCase.execute(for: [.horse], currentRaces: [])

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
        let result = try await useCase.execute(for: [.harness], currentRaces: [])

        #expect(result == [valid])
    }

    @Test("Preserves valid races already present")
    func testPreservesValidCurrentRaces() async throws {
        let now = Date()
        let current = Race.stub(id: "1", category: .horse, start: now.addingTimeInterval(60))
        let stubbedRaces: [Race] = [] // Empty new fetch

        let repo = MockRaceRepository(stubbedRaces: stubbedRaces)

        let useCase = GetNextRacesUseCaseImpl(repository: repo)
        let result = try await useCase.execute(for: [.horse], currentRaces: [current])

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
        let result = try await useCase.execute(for: [RaceCategory.horse], currentRaces: [current])

        #expect(result.count == 5)
    }

    @Test("Avoids duplicates between current and new races")
    func testAvoidsDuplicateRaces() async throws {
        let now = Date()
        let race = Race.stub(id: "1", category: .horse, start: now.addingTimeInterval(60))
        let stubbedRaces = [race] // already exists in currentRaces

        let repo = MockRaceRepository(stubbedRaces: stubbedRaces)

        let useCase = GetNextRacesUseCaseImpl(repository: repo)
        let result = try await useCase.execute(for: [.horse], currentRaces: [race])
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

        let result = try await useCase.execute(for: [.horse, .greyhound], currentRaces: [previouslySelectedHarness])

        let containsBoth = result.contains(where: { $0.category == .horse }) && result
            .contains(where: { $0.category == .greyhound })
        #expect(containsBoth)
        #expect(result.count == 2)
    }
}
