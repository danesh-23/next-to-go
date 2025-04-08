//
//  Race.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-05.
//

import Foundation

/// The Race entity represents a single racing event (horse, harness, or greyhound race).
struct Race: Identifiable, Equatable {
    let id: String
    let meetingName: String
    let raceNumber: Int
    let category: RaceCategory
    let advertisedStart: Date
}
