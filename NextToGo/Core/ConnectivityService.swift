//
//  ConnectivityService.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-09.
//

import Foundation
import Network

// MARK: - ConnectivityService

@Observable
@MainActor
final class ConnectivityService {

    // MARK: Lifecycle

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }

    // MARK: Internal

    static let shared = ConnectivityService()

    private(set) var isConnected = true

    // MARK: Private

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ConnectivityMonitor")

}

// MARK: - NetworkError

enum NetworkError: Error {
    case offline
}
