import Foundation
import XCTest

class MatchOptionsTests: XCTestCase {

    func test_matchOptions_withValidValues() {
        let matchType: Match.`Type` = .three
        let gamesPerSet: UInt8 = 6
        let pointsPerTieBreak: UInt8 = 7
        let advantage: Bool = false
        let serviceType: ServiceType = .local
        let options = Match.Options(matchType: matchType,
                                    gamesPerSet: gamesPerSet,
                                    pointsPerTieBreak: pointsPerTieBreak,
                                    advantage: advantage,
                                    serviceType: serviceType)

        XCTAssertEqual(options.matchType, matchType)
        XCTAssertEqual(options.gamesPerSet, gamesPerSet)
        XCTAssertEqual(options.pointsPerTieBreak, pointsPerTieBreak)
        XCTAssertEqual(options.advantage, advantage)
        XCTAssertEqual(options.serviceType, serviceType)
    }
}
