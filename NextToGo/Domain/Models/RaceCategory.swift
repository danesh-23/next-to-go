//
//  RaceCategory.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import Foundation

/// RaceCategory represents the type of race.
enum RaceCategory: String, Codable, CaseIterable {
    case horse = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
    case greyhound = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
    case harness = "161d9be2-e909-4326-8c2c-35ed71fb460b"

    // MARK: Internal

    /// A readable name for the category (for display / accessibility).
    var displayName: String {
        switch self {
        case .horse: "Horse"
        case .greyhound: "Greyhound"
        case .harness: "Harness"
        }
    }

    /// An image name for an icon representing this category.
    /// Due to lack of SF symbol support for all of these categories, we have custom images to fit these
    var symbolName: String {
        switch self {
        case .horse: "horse"
        case .greyhound: "greyhound"
        case .harness: "harness"
        }
    }
}
