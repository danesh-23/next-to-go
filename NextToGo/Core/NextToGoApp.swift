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
                .modelContainer(for: RaceEntity.self)
        }
    }
}

// MARK: - RootContentView

struct RootContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        let cacheRepository = RaceCacheRepositoryImpl(modelContext: modelContext)
        let repository = RaceRepositoryImpl(local: cacheRepository)
        let useCase = GetNextRacesUseCaseImpl(repository: repository)

        RaceListView(viewModel: RaceListViewModel(useCase: useCase))
    }
}
