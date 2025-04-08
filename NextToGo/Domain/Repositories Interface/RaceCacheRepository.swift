//
//  RaceCacheRepository.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import Foundation

/// Cache repository interface for fetching races.
protocol RaceCacheRepository: Sendable {
    /// Saves fetched races (next-to-go) to the cache.
    /// - Parameter races: The races to save locally.
    /// - Throws: An error if the fetch fails (e.g., network issues / decoding errors).
    func saveRaces(_ races: [Race]) async throws
    /// Loads last saved races from the cache.
    /// - Parameter races: The races to save locally.
    /// - Returns: A list of races.
    /// - Throws: An error if the fetch fails (e.g., network issues / decoding errors).
    func loadCachedRaces() async throws -> [Race]
    /// Empties out all the saved races in the cache.
    /// - Throws: An error if the fetch fails (e.g., network issues / decoding errors).
    func clearCache() async throws
}
