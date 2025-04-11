//
//  RaceListViewModelTests.swift
//  NextToGoTests
//
//  Created by Danesh Rajasolan on 2025-04-05.
//

import Foundation
import Testing
@testable import NextToGo

@MainActor
struct RaceListViewModelTests {
    @Test("Initial values loaded after init")
    func testInitialLoadSetsRaces() async throws {
        let stubbedRaces: [Race] = [
            .stub(id: "r1"),
            .stub(id: "r2")
        ]
        let mockUseCase = MockGetNextRacesUseCase(stubbedRaces: stubbedRaces)

        let viewModel = RaceListViewModel(useCase: mockUseCase)

        await Poll.until(timeoutSeconds: 2) {
            await MainActor.run {
                !viewModel.isLoading
            }
        }

        #expect(viewModel.races.count == 2)
        #expect(viewModel.races.map(\.id).contains("r1"))
    }

    @Test("Refresh adds new data to races")
    func testRefreshWorks() async throws {
        let stubbedRaces: [Race] = [.stub(id: "manual")]
        let mockUseCase = MockGetNextRacesUseCase(stubbedRaces: stubbedRaces)

        let viewModel = RaceListViewModel(useCase: mockUseCase)
        await viewModel.refreshManually()

        #expect(viewModel.races.contains(where: { race in
            race.id == "manual"
        }))
    }

    @Test("Toggle updates selected categories and refreshes")
    func testToggleCategoryTogglesAndRefreshes() async throws {
        let stubbedRaces: [Race] = [
            .stub(id: "horse", category: .horse),
            .stub(id: "harness", category: .harness),
            .stub(id: "greyhound", category: .greyhound)
        ]
        let mockUseCase = MockGetNextRacesUseCase(stubbedRaces: stubbedRaces)

        let viewModel = RaceListViewModel(useCase: mockUseCase)
        try await viewModel.toggleCategory(.horse)

        #expect(!viewModel.selectedCategories.contains(.horse))
        #expect(viewModel.selectedCategories.contains(.greyhound))
        #expect(viewModel.selectedCategories.contains(.harness))
    }

    @Test("Failed refresh caught successfully and sets error message")
    func testErrorMessageSetOnFailure() async throws {
        let mockUseCase = MockGetNextRacesUseCase(stubbedRaces: [], shouldThrow: true)

        let viewModel = RaceListViewModel(useCase: mockUseCase)

        await viewModel.refreshManually()

        #expect(viewModel.errorMessage != nil)
    }
}
