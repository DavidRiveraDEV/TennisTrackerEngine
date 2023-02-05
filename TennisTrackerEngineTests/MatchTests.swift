
import Foundation
import XCTest

class MatchTests: XCTestCase {

    func test_match_withValidValues() {
        let options = MatchTests.makeOptions()
        let localPlayer = Player(name: "P1")
        let visitorPlayer = Player(name: "P2")
        let match = makeMatch(options: options, localPlayer: localPlayer, visitorPlayer: visitorPlayer)

        XCTAssertEqual(match.options.setType, options.setType)
        XCTAssertEqual(match.options.gamesPerSet, options.gamesPerSet)
        XCTAssertEqual(match.options.pointsPerTieBreak, options.pointsPerTieBreak)
        XCTAssertEqual(match.options.advantage, options.advantage)
        XCTAssertEqual(match.options.serviceType, options.serviceType)
        XCTAssertEqual(match.localPlayer.name, localPlayer.name)
        XCTAssertEqual(match.visitorPlayer.name, visitorPlayer.name)
        XCTAssertEqual(match.sets.count, 1)
    }

    // MARK: - Utils

    private func makeMatch(options: Match.Options = MatchTests.makeOptions(),
                           localPlayer: Player = Player(name: "P1"),
                           visitorPlayer: Player = Player(name: "P2")) -> Match {

        return Match(with: options,
                     localPlayer: localPlayer,
                     visitorPlayer: visitorPlayer)
    }

    private static func makeOptions(setType: Match.SetType = .three,
                                    gamesPerSet: UInt8 = 6,
                                    pointsPerTieBreak: UInt8 = 7,
                                    advantage: Bool = true,
                                    serviceType: ServiceType = .local) -> Match.Options {

        return Match.Options(setType: setType,
                             gamesPerSet: gamesPerSet,
                             pointsPerTieBreak: pointsPerTieBreak,
                             advantage: advantage,
                             serviceType: serviceType)
    }

}
