
import Foundation
import XCTest

class SetTests: XCTestCase {

    func test_set_withDefaultValues() throws {
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
    }

    // MARK: - Change of service type

    func test_winSets_toChangeServiceType() {
        let initialServiceType = ServiceType.local
        let set = makeSet(serviceType: initialServiceType)

        (1...set.totalGames * 2).forEach { _ in
            let currentServiceType = set.serviceType
            (1...4).forEach { _ in
                set.winPoint()
            }
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

    func test_winGameForVisitor_toChangeServiceTypeToLocal() {
        let set = makeSet(serviceType: .visitor)

        (1...4).forEach { _ in
            set.winPoint()
        }

        XCTAssertEqual(set.serviceType, .local)
    }

    // MARK: - Single game

    func test_winPoints_toWinSingleGame() throws {
        let set = makeSet(serviceType: .local)

        (1...4).forEach { _ in
            set.winPoint()
        }

        XCTAssertEqual(set.localGames, 1)
        XCTAssertEqual(set.visitorGames, 0)
        XCTAssertEqual(set.serviceType, .visitor)
        XCTAssertFalse(set.isTieBreak)
        XCTAssertFalse(set.didEnd)
    }

    func test_losePoints_toLoseSingleGame() throws {
        let set = makeSet(serviceType: .visitor)

        (1...4).forEach { _ in
            set.losePoint()
        }

        XCTAssertEqual(set.localGames, 1)
        XCTAssertEqual(set.visitorGames, 0)
        XCTAssertEqual(set.serviceType, .local)
        XCTAssertFalse(set.isTieBreak)
        XCTAssertFalse(set.didEnd)
    }

    func test_winPoints_toExtension_thenWinSingleGame() {
        let set = makeSet()

        (1...(set.totalGames - 1) * 2).forEach { _ in
            (1...4).forEach { _ in
                set.winPoint()
            }
        }

        XCTAssertEqual(set.localGames, set.totalGames - 1)
        XCTAssertEqual(set.visitorGames, set.totalGames - 1)

        (1...4).forEach { _ in
            set.winPoint()
        }

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

        (1...set.totalGames * 2).forEach { _ in
            (1...4).forEach { _ in
                set.winPoint()
            }
        }

        XCTAssertTrue(set.isTieBreak)
        XCTAssertFalse(set.didEnd)
        XCTAssertEqual(set.localGames, set.totalGames)
        XCTAssertEqual(set.visitorGames, set.totalGames)
        XCTAssertEqual(set.localTieBreakPoints, 0)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
    }

    func test_losePoints_toTieBreak() {
        let set = makeSet()

        (1...set.totalGames * 2).forEach { _ in
            (1...4).forEach { _ in
                set.losePoint()
            }
        }

        XCTAssertTrue(set.isTieBreak)
        XCTAssertFalse(set.didEnd)
        XCTAssertEqual(set.localGames, set.totalGames)
        XCTAssertEqual(set.visitorGames, set.totalGames)
        XCTAssertEqual(set.localTieBreakPoints, 0)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
    }

    func test_winPoints_toExtension_thenWinPoints_toTieBreak() {
        let set = makeSet()

        (1...(set.totalGames - 1) * 2).forEach { _ in
            (1...4).forEach { _ in
                set.winPoint()
            }
        }

        XCTAssertEqual(set.localGames, set.totalGames - 1)
        XCTAssertEqual(set.visitorGames, set.totalGames - 1)

        (1...2).forEach { _ in
            (1...4).forEach { _ in
                set.winPoint()
            }
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

        (1...(set.totalGames - 1) * 2).forEach { _ in
            (1...4).forEach { _ in
                set.losePoint()
            }
        }

        XCTAssertEqual(set.localGames, set.totalGames - 1)
        XCTAssertEqual(set.visitorGames, set.totalGames - 1)

        (1...2).forEach { _ in
            (1...4).forEach { _ in
                set.losePoint()
            }
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

        (1...set.totalGames * 2).forEach { _ in
            (1...4).forEach { _ in
                set.winPoint()
            }
        }

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

        (1...set.totalGames * 2).forEach { _ in
            (1...4).forEach { _ in
                set.losePoint()
            }
        }

        set.losePoint()

        XCTAssertTrue(set.isTieBreak)
        XCTAssertFalse(set.didEnd)
        XCTAssertEqual(set.localGames, set.totalGames)
        XCTAssertEqual(set.visitorGames, set.totalGames)
        XCTAssertEqual(set.localTieBreakPoints, 1)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
    }

    // MARK: - Winning set

    func test_winPoints_toWinSet() {
        let set = makeSet(serviceType: .local)

        (1...set.totalGames).forEach { _ in
            let currentServiceType = set.serviceType
            (1...4).forEach { _ in
                if currentServiceType == .local {
                    set.winPoint()
                } else {
                    set.losePoint()
                }
            }
        }

        XCTAssertFalse(set.isTieBreak)
        XCTAssertTrue(set.didEnd)
        XCTAssertEqual(set.localGames, set.totalGames)
        XCTAssertEqual(set.visitorGames, 0)
        XCTAssertEqual(set.localTieBreakPoints, 0)
        XCTAssertEqual(set.visitorTieBreakPoints, 0)
    }

    func test_winPoints_toWinSet_withMinDifference() {
        let set = makeSet(serviceType: .visitor)

        (1...(set.totalGames - Set.minDifferencePerSet) * 2).forEach { _ in
            (1...4).forEach { _ in
                set.winPoint()
            }
        }

        (1...Set.minDifferencePerSet).forEach { _ in
            (1...4).forEach { _ in
                if set.serviceType == .visitor {
                    set.winPoint()
                } else {
                    set.losePoint()
                }
            }
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
            (1...4).forEach { _ in
                set.winPoint()
            }
        }

        (1...Set.minDifferencePerSet).forEach { _ in
            (1...4).forEach { _ in
                if set.serviceType == .local {
                    set.winPoint()
                } else {
                    set.losePoint()
                }
            }
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

        (1...set.totalGames * 2).forEach { _ in
            (1...4).forEach { _ in
                set.winPoint()
            }
        }

        (1...totalPointsForTieBreak).forEach { _ in
            if set.serviceType == .local {
                set.winPoint()
            } else {
                set.losePoint()
            }
        }

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

        (1...set.totalGames * 2).forEach { _ in
            (1...4).forEach { _ in
                set.losePoint()
            }
        }

        (1...totalPointsForTieBreak).forEach { _ in
            if set.serviceType == .visitor {
                set.winPoint()
            } else {
                set.losePoint()
            }
        }

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
}
