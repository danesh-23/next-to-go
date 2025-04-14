//
//  MockGetNextRacesUseCase.swift
//  NextToGoTests
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import Foundation

final class MockGetNextRacesUseCase: GetNextRacesUseCase {

    // MARK: Lifecycle

    init(stubbedRaces: [Race], shouldThrow: Bool = false) {
        self.stubbedRaces = stubbedRaces
        self.shouldThrow = shouldThrow
    }

    // MARK: Internal

    let stubbedRaces: [Race]
    let shouldThrow: Bool

    func execute(for _: Set<RaceCategory>, isINTL _: Bool, currentRaces _: [Race]) async throws -> [Race] {
        if shouldThrow {
            throw NSError(domain: "mock", code: 999)
        }
        return stubbedRaces
    }
}
