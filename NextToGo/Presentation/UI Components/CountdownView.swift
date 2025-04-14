//
//  CountdownView.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import SwiftUI

/// A view that displays a live countdown to a target date/time.
struct CountdownView: View {

    // MARK: Internal

    let targetDate: Date // The time the countdown is counting down to

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { context in
            // Compute remaining time at this point in time
            let now = context.date
            let remaining = targetDate.timeIntervalSince(now)
            Text(formattedTime(from: remaining))
                .font(.body)
                .foregroundColor(remaining < 0 ? .red : .primary)
                .frame(minWidth: 50, alignment: .trailing)
        }
    }

    // MARK: Private

    /// Format a TimeInterval (seconds) into a M min S s string (or H h M min S s if >= 1 hour).
    private func formattedTime(from interval: TimeInterval) -> String {
        let seconds = Int(interval) >= 60 ? Int(interval) % 60 : Int(interval)
        let minutes = (Int(interval) / 60) % 60
        let hours = Int(interval) / 3600

        return [
            hours > 0 ? "\(hours) h" : nil,
            minutes > 0 ? "\(minutes) m" : nil,
            "\(seconds) s"
        ]
        .compactMap { $0 }
        .joined(separator: " ")
    }
}
