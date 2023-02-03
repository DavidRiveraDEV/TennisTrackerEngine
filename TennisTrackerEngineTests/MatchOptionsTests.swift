//
//  MatchOptionsTests.swift
//  TennisTrackerEngineTests
//
//  Created by David Rivera on 2/02/23.
//

import Foundation
import XCTest

class MatchOptionsTests: XCTestCase {

    func test_matchOptions_withValidValues() {
        let gamesPerSet: UInt8 = 6
        let advantage: Bool = false
        let options = Match.Options(gamesPerSet: gamesPerSet, advantage: advantage)

        XCTAssertEqual(options.gamesPerSet, gamesPerSet)
        XCTAssertEqual(options.advantage, advantage)
    }

    func test_matchOptions_withMinGamesPerSetValues() {
        let gamesPerSet: UInt8 = 2
        let advantage: Bool = true
        let options = Match.Options(gamesPerSet: gamesPerSet, advantage: advantage)

        XCTAssertEqual(options.gamesPerSet, gamesPerSet)
        XCTAssertEqual(options.advantage, advantage)
    }
}
