//
//  NedsAPIClient.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-05.
//

import Foundation

/// A simple network client for the Neds Racing API.
struct NedsAPIClient {
    /// Fetches raw data from the Neds "next races" API.
    /// - Parameter count: Number of races to request from the API.
    /// - Returns: The raw Data of the response.
    /// - Throws: Networking error if request fails.
    func fetchNextRacesData(count: Int) async throws -> Data {
        guard let url = URL(string: "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=\(count)") else {
            throw URLError(.badURL) // Should not happen with correct URL
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
