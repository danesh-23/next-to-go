//
//  RaceEntity.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-05.
//

import Foundation
import SwiftData

/// RaceEntity represents struct used for persistent storage using SwiftData
@Model
final class RaceEntity {

    // MARK: Lifecycle

    init(
        id: String,
        number: Int,
        meetingName: String,
        category: String,
        advertisedStart: Date,
        raceName: String,
        venueCountry: String?) {
        self.id = id
        raceNumber = number
        self.meetingName = meetingName
        self.category = category
        self.advertisedStart = advertisedStart
        self.raceName = raceName
        self.venueCountry = venueCountry
    }

    // MARK: Internal

    @Attribute(.unique) var id: String
    var raceNumber: Int
    var raceName: String
    var meetingName: String
    var category: String
    var advertisedStart: Date
    var venueCountry: String?
}
