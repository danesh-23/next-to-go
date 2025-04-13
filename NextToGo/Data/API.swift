//
//  NedsAPIClient.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-05.
//

import Foundation

// MARK: - APIProtocol

protocol API<Endpoint>: Sendable {
    associatedtype Endpoint: EndpointType

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

// MARK: - API

/// A simple network client for the Neds Racing API.
final class APIImpl<Endpoint: EndpointType>: API {

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var request = URLRequest(url: endpoint.baseURL)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.generic(NSError(domain: "Invalid response", code: -1))
            }
            guard 200..<300 ~= httpResponse.statusCode else {
                throw APIError.badStatusCode(httpResponse.statusCode)
            }

            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as URLError {
            throw APIError.noInternet(error)
        } catch let decodingError as DecodingError {
            throw APIError.decodingError(decodingError)
        } catch {
            throw APIError.generic(error)
        }
    }
}
