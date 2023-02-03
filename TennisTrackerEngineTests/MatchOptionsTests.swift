
import Foundation
import XCTest

class MatchOptionsTests: XCTestCase {

    func test_matchOptions_withValidValues() {
        let gamesPerSet: UInt8 = 6
        let pointsPerTieBreak: UInt8 = 7
        let advantage: Bool = false
        let options = Match.Options(gamesPerSet: gamesPerSet, pointsPerTieBreak: pointsPerTieBreak, advantage: advantage)

        XCTAssertEqual(options.gamesPerSet, gamesPerSet)
        XCTAssertEqual(options.pointsPerTieBreak, pointsPerTieBreak)
        XCTAssertEqual(options.advantage, advantage)
    }
}
