//
//  RacingEndpoint.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-13.
//

import Foundation

// MARK: - RacingEndpoint

// Enum to represent different racing endpoints.

enum RacingEndpoint {
    case nextRaces(count: Int)
}

// MARK: EndpointType

/// Extend RacingEndpoint to conform to EndpointType protocol.
extension RacingEndpoint: EndpointType {

    var path: String {
        switch self {
        case .nextRaces:
            "racing/" // Path for retrieving next races.
        }
    }

    var query: [String: String] {
        switch self {
        case .nextRaces(let count):
            [
                "method": "nextraces", // Specify the method for retrieving next races.
                "count": "\(count)" // Include the count parameter in the query.
            ]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .nextRaces:
            .get // Use GET method for retrieving next races.
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .nextRaces:
            [:] // No headers needed to retrieve next races.
        }
    }

}
