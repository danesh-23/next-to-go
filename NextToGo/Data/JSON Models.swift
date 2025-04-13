//
//  JSON Models.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import Foundation

// MARK: - AdvertisedStart

struct AdvertisedStart: Decodable {
    let seconds: TimeInterval?
}

// MARK: - RaceSummary

struct RaceSummary: Decodable {
    enum CodingKeys: String, CodingKey {
        case raceID = "race_id"
        case raceName = "race_name"
        case raceNumber = "race_number"
        case meetingID = "meeting_id"
        case meetingName = "meeting_name"
        case categoryID = "category_id"
        case advertisedStart = "advertised_start"
        case raceForm = "race_form"
        case venueName = "venue_name"
        case venueState = "venue_state"
        case venueCountry = "venue_country"
    }

    let raceID: String
    let raceName: String
    let raceNumber: Int
    let meetingID: String
    let meetingName: String
    let categoryID: String
    let advertisedStart: AdvertisedStart
    let raceForm: RaceForm?
    let venueName: String?
    let venueState: String?
    let venueCountry: String?

}

// MARK: - RaceForm

struct RaceForm: Decodable {
    let distance: Int?
    let distanceType: RaceDetail?
    let trackCondition: RaceDetail?
    let weather: RaceDetail?
    let raceComment: String?

    enum CodingKeys: String, CodingKey {
        case distance
        case distanceType = "distance_type"
        case trackCondition = "track_condition"
        case weather
        case raceComment = "race_comment"
    }
}

// MARK: - RaceDetail

struct RaceDetail: Decodable {
    let id: String
    let name: String
    let shortName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortName = "short_name"
    }
}

// MARK: - NextRacesResponse

struct NextRacesResponse: Decodable {
    let data: NextRacesData
}

// MARK: - NextRacesData

struct NextRacesData: Decodable {
    let nextToGoIDS: [String]
    let raceSummaries: [String: RaceSummary]

    enum CodingKeys: String, CodingKey {
        case nextToGoIDS = "next_to_go_ids"
        case raceSummaries = "race_summaries"
    }
}
