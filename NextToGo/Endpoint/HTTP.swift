//
//  HTTP.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-13.
//

import Foundation

// MARK: - HTTPStatusCode

// An enumeration of all HTTP status codes and their corresponding descriptions.

enum HTTPStatusCode: Int {
    /// 2xx Success
    case success = 200

    // 4xx Client error
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case preconditionFail = 412
    case tooManyRequests = 429

    // 5xx Server error
    case serverError = 500
    case serviceUnavailable = 503
}

// MARK: - HTTPMethod

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

typealias HTTPHeaders = [String: String]

// MARK: - APIError

enum APIError: Error, LocalizedError {
    case invalidURL
    case noInternet(URLError)
    case badStatusCode(Int)
    case decodingError(DecodingError)
    case generic(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: "Invalid URL"
        case .noInternet(let err): "No internet: \(err.localizedDescription)"
        case .badStatusCode(let code): "Bad status code: \(code)"
        case .decodingError(let err): "Decoding failed: \(err.localizedDescription)"
        case .generic(let err): "Something went wrong: \(err.localizedDescription)"
        }
    }
}
