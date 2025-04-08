//
//  Race+Extension.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import Foundation

extension Race {
    static func stub(
        id: String = UUID().uuidString,
        meetingName: String = "Test Track",
        raceNumber: Int = 1,
        category: RaceCategory = .harness,
        start: Date = .now.addingTimeInterval(60))
        -> Race {
        Race(
            id: id,
            meetingName: meetingName,
            raceNumber: raceNumber,
            category: category,
            advertisedStart: start)
    }
}

// MARK: - Poll

enum Poll {
    enum PollingError: Error {
        case timedOut
    }

    static func until(
        timeout: TimeInterval = 1,
        interval: TimeInterval = 0.01,
        _ condition: @escaping () async -> Bool)
        async throws {
        let deadline = Date().addingTimeInterval(timeout)

        while Date() < deadline {
            if await condition() {
                return
            }
            try await Task.sleep(for: .milliseconds(Int(interval * 1000)))
        }

        throw PollingError.timedOut
    }
}
