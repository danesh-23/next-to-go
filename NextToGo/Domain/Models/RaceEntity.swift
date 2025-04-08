//
//  RaceEntity.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-05.
//

import Foundation
import SwiftData

@Model
final class RaceEntity {

    // MARK: Lifecycle

    init(id: String, number: Int, meetingName: String, category: String, advertisedStart: Date) {
        self.id = id
        raceNumber = number
        self.meetingName = meetingName
        self.category = category
        self.advertisedStart = advertisedStart
    }

    // MARK: Internal

    @Attribute(.unique) var id: String
    var raceNumber: Int
    var meetingName: String
    var category: String
    var advertisedStart: Date

}
