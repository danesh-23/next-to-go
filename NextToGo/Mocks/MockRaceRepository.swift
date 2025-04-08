//
//  MockRaceRepository.swift
//  NextToGoTests
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import Foundation

final class MockRaceRepository: RaceRepository {

    // MARK: Lifecycle

    init(stubbedRaces: [Race], shouldThrow: Bool = false, backupStubbedRaces: [Race] = []) {
        self.stubbedRaces = stubbedRaces
        self.shouldThrow = shouldThrow
        self.backupStubbedRaces = backupStubbedRaces
    }

    // MARK: Internal

    let stubbedRaces: [Race]
    let backupStubbedRaces: [Race]
    let shouldThrow: Bool

    func fetchNextRaces(count: Int) async throws -> [Race] {
        if count <= 10 {
            stubbedRaces
        } else {
            backupStubbedRaces
        }
    }
}
