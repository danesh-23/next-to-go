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
    let raceNumber: Int
    let meetingName: String
    let categoryID: String
    let advertisedStart: AdvertisedStart

    enum CodingKeys: String, CodingKey {
        case raceNumber = "race_number"
        case meetingName = "meeting_name"
        case categoryID = "category_id"
        case advertisedStart = "advertised_start"
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
