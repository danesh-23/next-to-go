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
        start: Date = .now.addingTimeInterval(60),
        raceName: String = "Test Race",
        venueCountry: String? = nil)
        -> Race {
        Race(
            id: id,
            meetingName: meetingName,
            raceNumber: raceNumber,
            raceName: raceName,
            category: category,
            advertisedStart: start,
            venueCountry: venueCountry)
    }
}

extension Date {
    var roundedToSecond: Date {
        Date(timeIntervalSince1970: floor(timeIntervalSince1970))
    }
}

// MARK: - Poll

enum Poll {
    /// Polls a condition every `interval` until it's true or `timeout` is reached.
    static func until(
        timeoutSeconds: Int = 2,
        intervalMilliseconds: Int = 50,
        condition: @Sendable @escaping () async -> Bool)
        async {
        let start = ContinuousClock.now

        let timeout = Duration.seconds(timeoutSeconds)
        let interval = Duration.milliseconds(intervalMilliseconds)

        while ContinuousClock.now.duration(to: start) < timeout {
            if await condition() { return }
            try? await Task.sleep(for: interval)
        }
    }
}
