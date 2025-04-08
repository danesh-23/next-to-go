//
//  RaceRowView.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-07.
//

import SwiftUI

struct RaceRowView: View {

    // MARK: Internal

    let race: Race

    var body: some View {
        HStack {
            Image(race.category.symbolName)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.black.opacity(0.5))
                .scaledToFit()
                .frame(width: 40, height: 40)
                .accessibilityHidden(true) // hide icon itself from VoiceOver, described in label.
            VStack(alignment: .leading) {
                Text(race.meetingName)
                    .font(.headline)
                Text("Race \(race.raceNumber)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            CountdownView(targetDate: race.advertisedStart)
                .frame(minWidth: 80)
                .accessibilityLabel(timeRemainingAccessibilityLabel)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            """
            \(race.category.displayName) Race \(race.raceNumber) at \(race.meetingName),
            starts in \(formattedTimeRemaining())
            """)
    }

    // MARK: Private

    /// Accessibility label for the countdown alone.
    private var timeRemainingAccessibilityLabel: String {
        let remaining = max(0, race.advertisedStart.timeIntervalSinceNow)
        if remaining <= 0 {
            return "Starting now"
        }
        let minutes = Int(remaining / 60)
        let seconds = Int(remaining.truncatingRemainder(dividingBy: 60))
        if minutes > 0 {
            return "Starts in \(minutes) minutes and \(seconds) seconds"
        } else {
            return "Starts in \(seconds) seconds"
        }
    }

    /// Compute remaining time string for accessibility.
    private func formattedTimeRemaining() -> String {
        let remaining = max(0, race.advertisedStart.timeIntervalSinceNow)
        let minutes = Int(remaining / 60)
        let seconds = Int(remaining.truncatingRemainder(dividingBy: 60))
        if minutes > 0 {
            return "\(minutes) minutes \(seconds) seconds"
        } else {
            return "\(seconds) seconds"
        }
    }
}
