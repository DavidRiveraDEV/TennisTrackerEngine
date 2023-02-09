
import Foundation
import XCTest

class MatchTests: XCTestCase {

    func test_match_withValidValues() {
        let options = MatchTests.makeOptions()
        let localPlayer = Player(name: "P1")
        let visitorPlayer = Player(name: "P2")
        let match = makeMatch(options: options, localPlayer: localPlayer, visitorPlayer: visitorPlayer)

        XCTAssertEqual(match.options.matchType, options.matchType)
        XCTAssertEqual(match.options.gamesPerSet, options.gamesPerSet)
        XCTAssertEqual(match.options.pointsPerTieBreak, options.pointsPerTieBreak)
        XCTAssertEqual(match.options.advantage, options.advantage)
        XCTAssertEqual(match.options.serviceType, options.serviceType)
        XCTAssertEqual(match.localPlayer.name, localPlayer.name)
        XCTAssertEqual(match.visitorPlayer.name, visitorPlayer.name)
        XCTAssertEqual(match.serviceType, options.serviceType)
        XCTAssertEqual(match.setSummaries.count, 1)
        XCTAssertFalse(match.didEnd)
    }

    func test_match_withWeakDelegate() {
        let match = makeMatch()
        var matchDelegate: MatchDelegate? = MatchDelegateSpy()
        match.delegate = matchDelegate

        matchDelegate = nil

        XCTAssertNil(match.delegate)
    }

    // MARK: - Mock

    func test_matchMock_winSetForLocal() {
        let match = makeMatch()
        let serviceType: ServiceType = .local

        winSet(for: match, to: serviceType)

        XCTAssertEqual(match.setSummaries.count, 2)
        XCTAssertEqual(match.setSummaries[0].localGames, 6)
        XCTAssertEqual(match.setSummaries[0].visitorGames, 0)
        XCTAssertFalse(match.didEnd)
    }

    func test_matchMock_winSetForVisitor() {
        let match = makeMatch()
        let serviceType: ServiceType = .visitor

        winSet(for: match, to: serviceType)

        XCTAssertEqual(match.setSummaries.count, 2)
        XCTAssertEqual(match.setSummaries[0].localGames, 0)
        XCTAssertEqual(match.setSummaries[0].visitorGames, 6)
        XCTAssertFalse(match.didEnd)
    }

    // MARK: - Winning match

    func test_winMatch_notifyDelegate() {
        let match = makeMatch()
        let matchDelegate = MatchDelegateSpy()
        match.delegate = matchDelegate

        winSet(for: match, to: .local)
        winSet(for: match, to: .local)

        XCTAssertTrue(matchDelegate.matchDidEndCalled)
    }

    func test_winMatch_withMatchTypeOne() {
        let options = MatchTests.makeOptions(matchType: .one)
        let match = makeMatch(options: options)
        let serviceType: ServiceType = .local

        winSet(for: match, to: serviceType)

        XCTAssertEqual(match.setSummaries.count, 1)
        XCTAssertTrue(match.didEnd)
    }

    func test_winMatch_withMatchTypeThree() {
        let options = MatchTests.makeOptions(matchType: .three)
        let match = makeMatch(options: options)
        let serviceType: ServiceType = .local

        winSet(for: match, to: serviceType)
        winSet(for: match, to: serviceType)

        XCTAssertEqual(match.setSummaries.count, 2)
        XCTAssertTrue(match.didEnd)
    }

    func test_winMatch_withMatchTypeFive() {
        let options = MatchTests.makeOptions(matchType: .five)
        let match = makeMatch(options: options)
        let serviceType: ServiceType = .local

        winSet(for: match, to: serviceType)
        winSet(for: match, to: serviceType)
        winSet(for: match, to: serviceType)

        XCTAssertEqual(match.setSummaries.count, 3)
        XCTAssertTrue(match.didEnd)
    }

    // MARK: - Utils

    private func makeMatch(options: Match.Options = MatchTests.makeOptions(),
                           localPlayer: Player = Player(name: "P1"),
                           visitorPlayer: Player = Player(name: "P2")) -> Match {

        return Match(with: options,
                     localPlayer: localPlayer,
                     visitorPlayer: visitorPlayer)
    }

    private func winSet(for match: Match, to serviceType: ServiceType) {
        (1...match.options.gamesPerSet).forEach { _ in
            (1...4).forEach { _ in
                if match.serviceType == serviceType  {
                    match.winPoint()
                } else {
                    match.losePoint()
                }
            }
        }
    }

    private static func makeOptions(matchType: Match.`Type` = .three,
                                    gamesPerSet: UInt8 = 6,
                                    pointsPerTieBreak: UInt8 = 7,
                                    advantage: Bool = true,
                                    serviceType: ServiceType = .local) -> Match.Options {

        return Match.Options(matchType: matchType,
                             gamesPerSet: gamesPerSet,
                             pointsPerTieBreak: pointsPerTieBreak,
                             advantage: advantage,
                             serviceType: serviceType)
    }

    private class MatchDelegateSpy: MatchDelegate {

        private(set) var matchDidEndCalled: Bool = false

        func matchDidEnd() {
            matchDidEndCalled = true
        }
    }
}
