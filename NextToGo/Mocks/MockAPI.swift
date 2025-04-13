//
//  MockAPI.swift
//  NextToGo
//
//  Created by Danesh Rajasolan on 2025-04-13.
//

import Foundation

// MARK: - MockAPI

final class MockAPI: API {

    // MARK: Lifecycle

    init(
        shouldThrow: Bool = false,
        errorToThrow: Error = APIError.generic(NSError(domain: "Test", code: 0)),
        raceResponse: NextRacesResponse = MockAPI.raceResponseSuccess) {
        self.shouldThrow = shouldThrow
        self.errorToThrow = errorToThrow
        raceResponseMock = raceResponse
    }

    // MARK: Internal

    typealias Endpoint = RacingEndpoint

    static var raceResponseSuccess: NextRacesResponse {
        let now = Date()
        let timestamp = now.addingTimeInterval(300).timeIntervalSince1970

        return NextRacesResponse(
            data: NextRacesData(
                nextToGoIDS: [raceID],
                raceSummaries: [
                    raceID: RaceSummary(
                        raceID: raceID,
                        raceName: "Mock Stakes",
                        raceNumber: 3,
                        meetingID: UUID().uuidString,
                        meetingName: "Mockville",
                        categoryID: RaceCategory.horse.rawValue,
                        advertisedStart: AdvertisedStart(seconds: timestamp),
                        raceForm: raceFormMock,
                        venueName: "Mock Park",
                        venueState: "VIC",
                        venueCountry: "AUS")
                ]))
    }

    static var raceFormMock: RaceForm {
        RaceForm(
            distance: 1200,
            distanceType: RaceDetail(id: "dist-id", name: "Metres", shortName: "m"),
            trackCondition: RaceDetail(id: "track-id", name: "Good", shortName: "Good"),
            weather: RaceDetail(id: "weather-id", name: "Fine", shortName: "Fine"),
            raceComment: "Nice weather, fast track")
    }

    static var raceID: String {
        "race1"
    }

    let shouldThrow: Bool
    let errorToThrow: Error
    let raceResponseMock: NextRacesResponse

    func request<T>(_: RacingEndpoint) async throws -> T where T: Decodable {
        if shouldThrow { throw errorToThrow }

        guard let result = raceResponseMock as? T else {
            fatalError("Mock response not set correctly")
        }
        return result
    }
}

extension RaceSummary {
    func copyWith(
        raceID: String? = nil,
        raceName: String? = nil,
        raceNumber: Int? = nil,
        meetingID: String? = nil,
        meetingName: String? = nil,
        categoryID: String? = nil,
        advertisedStart: AdvertisedStart? = nil,
        raceForm: RaceForm? = nil,
        venueName: String? = nil,
        venueState: String? = nil,
        venueCountry: String? = nil)
        -> RaceSummary {
        RaceSummary(
            raceID: raceID ?? self.raceID,
            raceName: raceName ?? self.raceName,
            raceNumber: raceNumber ?? self.raceNumber,
            meetingID: meetingID ?? self.meetingID,
            meetingName: meetingName ?? self.meetingName,
            categoryID: categoryID ?? self.categoryID,
            advertisedStart: advertisedStart ?? self.advertisedStart,
            raceForm: raceForm ?? self.raceForm,
            venueName: venueName ?? self.venueName,
            venueState: venueState ?? self.venueState,
            venueCountry: venueCountry ?? self.venueCountry)
    }
}

extension NextRacesResponse {
    func copyWith(data: NextRacesData? = nil) -> NextRacesResponse {
        NextRacesResponse(data: data ?? self.data)
    }
}

extension NextRacesData {
    func copyWith(
        nextToGoIDS: [String]? = nil,
        raceSummaries: [String: RaceSummary]? = nil)
        -> NextRacesData {
        NextRacesData(nextToGoIDS: nextToGoIDS ?? self.nextToGoIDS, raceSummaries: raceSummaries ?? self.raceSummaries)
    }
}
