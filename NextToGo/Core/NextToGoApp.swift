//
//  NextToGoApp.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-05.
//

import SwiftData
import SwiftUI

// MARK: - NextToGoApp

@main
struct NextToGoApp: App {
    var body: some Scene {
        WindowGroup {
            RootContentView()
//                .modelContainer(for: RaceEntity.self) for SWiftData // TODO: SwiftData
        }
    }
}

// MARK: - RootContentView

// This view is used in case SwiftData feature would like to be enabled
// and by default this is turned off since it was not a feature specified anywhere.
// Uncomment all TODO: SwiftData lines
// TODO: SwiftData
struct RootContentView: View {
//    @Environment(\.modelContext) private var modelContext

    var body: some View {
//        let cacheRepository = RaceCacheRepositoryImpl(modelContext: modelContext)
//        let repository = RaceRepositoryImpl(local: cacheRepository)
        let repository = RaceRepositoryImpl()
        let useCase = GetNextRacesUseCaseImpl(repository: repository)

        RaceListView(viewModel: RaceListViewModel(useCase: useCase))
    }
}
