import Foundation
import XCTest

class SetTests: XCTestCase {

    func test_set_withDefaultValues() {
        let serviceType: ServiceType = .local
        let advantageEnabled = true
        let totalGames: UInt8 = 6

        let set = makeSet(serviceType: serviceType, totalGames: totalGames, advantageEnabled: advantageEnabled)

        XCTAssertEqual(set.serviceType, .local)
        XCTAssertEqual(set.totalGames, totalGames)
        XCTAssertEqual(set.localGames, 0)
        XCTAssertEqual(set.visitorGames, 0)
        XCTAssertFalse(set.isTieBreak)
        XCTAssertFalse(set.didEnd)
        XCTAssertNil(set.delegate)
    }

    func test_set_withMinValues() {
        let serviceType: ServiceType = .local
        let advantageEnabled = true
        let totalGames: UInt8 = Set.minDifferencePerSet

        let set = makeSet(serviceType: serviceType, totalGames: totalGames, advantageEnabled: advantageEnabled)

        XCTAssertEqual(set.serviceType, .local)
        XCTAssertEqual(set.totalGames, totalGames)
        XCTAssertEqual(set.localGames, 0)
        XCTAssertEqual(set.visitorGames, 0)
        XCTAssertFalse(set.isTieBreak)
        XCTAssertFalse(set.didEnd)
        XCTAssertNil(set.delegate)
    }

    func test_set_withTotalGamesLowerThanMinDifference() {
        let serviceType: ServiceType = .local
        let advantageEnabled = true
        let totalGames: UInt8 = Set.minDifferencePerSet - 1

        let set = makeSet(serviceType: serviceType, totalGames: totalGames, advantageEnabled: advantageEnabled)

        XCTAssertEqual(set.totalGames, Set.minDifferencePerSet)
    }

    func test_set_withWeakDelegate() {
        let set = makeSet()
        var setDelegate: SetDelegate? = SetDelegateSpy()
        set.delegate = setDelegate

        setDelegate = nil

        XCTAssertNil(set.delegate)
    }

    // MARK: - Change of service type

    func test_winSets_toChangeServiceType() {
        let initialServiceType = ServiceType.local
        let set = makeSet(serviceType: initialServiceType)

        (1...set.totalGames * 2).forEach { _ in
            let currentServiceType = set.serviceType
            addGameFor(set: set, win: true)
            XCTAssertEqual(set.serviceType, getNextServiceType(for: currentServiceType))
        }
        XCTAssertEqual(set.serviceType, initialServiceType)

        var currentServiceType = set.serviceType
        set.winPoint()
        XCTAssertEqual(set.serviceType, getNextServiceType(for: currentServiceType))
        currentServiceType = set.serviceType
        set.winPoint()
        XCTAssertEqual(set.serviceType, currentServiceType)
        set.winPoint()
        XCTAssertEqual(set.serviceType, getNextServiceType(for: currentServiceType))
    }

    // MARK: - Single game

    func test_winPoints_toExtension_thenWinSingleGame() {
        let set = makeSet()

        goToExtension(set: set, win: true)

        XCTAssertEqual(set.localGames, set.totalGames - 1)
        XCTAssertEqual(set.visitorGames, set.totalGames - 1)

        addGameFor(set: set, win: true)

        XCTAssertEqual(set.localGames, set.totalGames)
        XCTAssertEqual(set.visitorGames, set.totalGames - 1)
        XCTAssertFalse(set.isTieBreak)
        XCTAssertFalse(set.didEnd)
        XCTAssertEqual(set.localTieBreakPoints, 0)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
    }

    // MARK: - Tie break

    func test_winPoints_toTieBreak() {
        let set = makeSet()

        goToTieBreak(set: set, win: true)

        XCTAssertTrue(set.isTieBreak)
        XCTAssertFalse(set.didEnd)
        XCTAssertEqual(set.localGames, set.totalGames)
        XCTAssertEqual(set.visitorGames, set.totalGames)
        XCTAssertEqual(set.localTieBreakPoints, 0)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
    }

    func test_losePoints_toTieBreak() {
        let set = makeSet()

        goToTieBreak(set: set, win: false)

        XCTAssertTrue(set.isTieBreak)
        XCTAssertFalse(set.didEnd)
        XCTAssertEqual(set.localGames, set.totalGames)
        XCTAssertEqual(set.visitorGames, set.totalGames)
        XCTAssertEqual(set.localTieBreakPoints, 0)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
    }

    func test_winPoints_toExtension_thenWinPoints_toTieBreak() {
        let set = makeSet()

        goToExtension(set: set, win: true)

        XCTAssertEqual(set.localGames, set.totalGames - 1)
        XCTAssertEqual(set.visitorGames, set.totalGames - 1)

        (1...2).forEach { _ in
            addGameFor(set: set, win: true)
        }

        XCTAssertEqual(set.localGames, set.totalGames)
        XCTAssertEqual(set.visitorGames, set.totalGames)
        XCTAssertTrue(set.isTieBreak)
        XCTAssertFalse(set.didEnd)
        XCTAssertEqual(set.localTieBreakPoints, 0)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
    }

    func test_losePoints_toExtension_thenLosePoints_toTieBreak() {
        let set = makeSet()

        goToExtension(set: set, win: false)

        XCTAssertEqual(set.localGames, set.totalGames - 1)
        XCTAssertEqual(set.visitorGames, set.totalGames - 1)

        (1...2).forEach { _ in
            addGameFor(set: set, win: true)
        }

        XCTAssertEqual(set.localGames, set.totalGames)
        XCTAssertEqual(set.visitorGames, set.totalGames)
        XCTAssertTrue(set.isTieBreak)
        XCTAssertFalse(set.didEnd)
        XCTAssertEqual(set.localTieBreakPoints, 0)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
    }

    func test_winPoints_toTieBreak_thenWinSingleTieBreakPoint() {
        let set = makeSet(serviceType: .local)

        goToTieBreak(set: set, win: true)

        set.winPoint()

        XCTAssertTrue(set.isTieBreak)
        XCTAssertFalse(set.didEnd)
        XCTAssertEqual(set.localGames, set.totalGames)
        XCTAssertEqual(set.visitorGames, set.totalGames)
        XCTAssertEqual(set.localTieBreakPoints, 1)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
    }

    func test_losePoints_toTieBreak_thenLoseSingleTieBreakPoint() {
        let set = makeSet(serviceType: .visitor)

        goToTieBreak(set: set, win: false)

        set.losePoint()

        XCTAssertTrue(set.isTieBreak)
        XCTAssertFalse(set.didEnd)
        XCTAssertEqual(set.localGames, set.totalGames)
        XCTAssertEqual(set.visitorGames, set.totalGames)
        XCTAssertEqual(set.localTieBreakPoints, 1)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
    }

    // MARK: - Winning set

    func test_winPoints_toWinSet_notifyDelegate() {
        let set = makeSet(serviceType: .local)
        let setDelegate = SetDelegateSpy()
        set.delegate = setDelegate

        win(set: set, to: .local)

        XCTAssertFalse(set.isTieBreak)
        XCTAssertTrue(set.didEnd)
        XCTAssertEqual(set.localGames, set.totalGames)
        XCTAssertEqual(set.visitorGames, 0)
        XCTAssertEqual(set.localTieBreakPoints, 0)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
        XCTAssertTrue(setDelegate.setDidEndCalled)
    }

    func test_winPoints_toWinSet_withMinDifference() {
        let set = makeSet(serviceType: .visitor)

        (1...(set.totalGames - Set.minDifferencePerSet) * 2).forEach { _ in
            addGameFor(set: set, win: true)
        }

        (1...Set.minDifferencePerSet).forEach { _ in
            addGameFor(set: set, to: .visitor)
        }

        XCTAssertFalse(set.isTieBreak)
        XCTAssertTrue(set.didEnd)
        XCTAssertEqual(set.localGames, set.totalGames - Set.minDifferencePerSet)
        XCTAssertEqual(set.visitorGames, set.totalGames)
        XCTAssertEqual(set.localTieBreakPoints, 0)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
    }

    func test_winPoints_toWinSet_withMinDifference_withExtension() {
        let set = makeSet(serviceType: .local)

        (1...(set.totalGames - 1) * 2).forEach { _ in
            addGameFor(set: set, win: true)
        }

        (1...Set.minDifferencePerSet).forEach { _ in
            addGameFor(set: set, to: .local)
        }

        XCTAssertFalse(set.isTieBreak)
        XCTAssertTrue(set.didEnd)
        XCTAssertEqual(set.localGames, set.totalGames + 1)
        XCTAssertEqual(set.visitorGames, set.totalGames - 1)
        XCTAssertEqual(set.localTieBreakPoints, 0)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
    }

    func test_winPoints_toTieBreak_thenWinPoints_toWinSet() {
        let totalPointsForTieBreak: UInt8 = 7
        let set = makeSet(totalPointsForTieBreak: totalPointsForTieBreak)

        goToTieBreak(set: set, win: true)
        add(points: totalPointsForTieBreak, for: set, to: .local)

        XCTAssertTrue(set.isTieBreak)
        XCTAssertTrue(set.didEnd)
        XCTAssertEqual(set.localGames, set.totalGames + 1)
        XCTAssertEqual(set.visitorGames, set.totalGames)
        XCTAssertEqual(set.localTieBreakPoints, totalPointsForTieBreak)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
    }

    func test_losePoints_toTieBreak_thenLosePoints_toLoseSet() {
        let totalPointsForTieBreak: UInt8 = 7
        let set = makeSet(totalPointsForTieBreak: totalPointsForTieBreak)

        goToTieBreak(set: set, win: false)
        add(points: totalPointsForTieBreak, for: set, to: .visitor)

        XCTAssertTrue(set.isTieBreak)
        XCTAssertTrue(set.didEnd)
        XCTAssertEqual(set.localGames, set.totalGames)
        XCTAssertEqual(set.visitorGames, set.totalGames + 1)
        XCTAssertEqual(set.localTieBreakPoints, 0)
        XCTAssertEqual(set.visitorTieBreakPoints, totalPointsForTieBreak)
    }

    // MARK: - Utils

    private func makeSet(serviceType: ServiceType = .local,
                         totalGames: UInt8 = 6,
                         totalPointsForTieBreak: UInt8 = 7,
                         advantageEnabled: Bool = true) -> Set {

        return Set(serviceType: serviceType,
                      totalGames: totalGames,
                      totalPointsForTieBreak: totalPointsForTieBreak,
                      advantageEnabled: advantageEnabled)
    }

    private func getNextServiceType(for serviceType: ServiceType) -> ServiceType {
        switch serviceType {
        case .local: return .visitor
        case .visitor: return .local
        }
    }

    private func addGameFor(set: Set, win: Bool) {
        add(points: 4, for: set, win: win)
    }

    private func add(points: UInt8, for set: Set, win: Bool) {
        (1...points).forEach { _ in
            if win {
                set.winPoint()
            } else {
                set.losePoint()
            }
        }
    }

    private func addGameFor(set: Set, to serviceType: ServiceType) {
        add(points: 4, for: set, to: serviceType)
    }

    private func add(points: UInt8, for set: Set, to serviceType: ServiceType) {
        (1...points).forEach { _ in
            if set.serviceType == serviceType {
                set.winPoint()
            } else {
                set.losePoint()
            }
        }
    }

    private func goToExtension(set: Set, win: Bool) {
        (1...(set.totalGames - 1) * 2).forEach { _ in
            addGameFor(set: set, win: win)
        }
    }

    private func goToTieBreak(set: Set, win: Bool) {
        (1...set.totalGames * 2).forEach { _ in
            addGameFor(set: set, win: win)
        }
    }

    private func win(set: Set, to serviceType: ServiceType) {
        (1...set.totalGames).forEach { _ in
            addGameFor(set: set, to: serviceType)
        }
    }

    private class SetDelegateSpy: SetDelegate {

        private(set) var setDidEndCalled: Bool = false

        func setDidEnd() {
            setDidEndCalled = true
        }
    }
}
