//
//  RaceRepository.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import Foundation

/// Repository interface for fetching races.
protocol RaceRepository: Sendable {
    /// Fetches upcoming races (next-to-go) from the data source.
    /// - Parameter count: The maximum number of races to fetch (the API supports a 'count' parameter).
    /// - Returns: An array of Race entities.
    /// - Throws: An error if the fetch fails (e.g., network issues / decoding errors).
    func fetchNextRaces(count: Int) async throws -> [Race]
}
