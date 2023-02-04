
import Foundation
import XCTest

class TieBreakTests: XCTestCase {

    func test_tieBreak_withDefaultValues() {
        let totalPoints: UInt8 = 7

        let tieBreak = TieBreak(totalPoints: totalPoints)

        XCTAssertEqual(tieBreak.totalPoints, totalPoints)
        XCTAssertEqual(tieBreak.local, 0)
        XCTAssertEqual(tieBreak.visitor, 0)
        XCTAssertFalse(tieBreak.didEnd)
    }

    // MARK: - Winning single point

    func test_addSinglePoint_toLocal() {
        let tieBreak = makeTieBreak()

        tieBreak.addPointToLocal()

        XCTAssertEqual(tieBreak.local, 1)
        XCTAssertEqual(tieBreak.visitor, 0)
        XCTAssertFalse(tieBreak.didEnd)
    }

    func test_addSinglePoint_toVisitor() {
        let tieBreak = makeTieBreak()

        tieBreak.addPointToVisitor()

        XCTAssertEqual(tieBreak.local, 0)
        XCTAssertEqual(tieBreak.visitor, 1)
        XCTAssertFalse(tieBreak.didEnd)
    }

    // MARK: - Going to extension

    func test_AddPointsToLocalAndVisitor_toExtension_thenAddPointToLocal_notWinning() {
        let tieBreak = makeTieBreak()

        while(tieBreak.local < tieBreak.totalPoints - 1 && tieBreak.visitor < tieBreak.totalPoints - 1) {
            tieBreak.addPointToLocal()
            tieBreak.addPointToVisitor()
        }

        tieBreak.addPointToLocal()

        XCTAssertEqual(tieBreak.local, tieBreak.totalPoints)
        XCTAssertEqual(tieBreak.visitor, tieBreak.totalPoints - 1)
        XCTAssertFalse(tieBreak.didEnd)
    }

    func test_AddPointsToLocalAndVisitor_toExtension_thenAddPointToVisitor_notWinning() {
        let tieBreak = makeTieBreak()

        while(tieBreak.local < tieBreak.totalPoints - 1 && tieBreak.visitor < tieBreak.totalPoints - 1) {
            tieBreak.addPointToLocal()
            tieBreak.addPointToVisitor()
        }

        tieBreak.addPointToVisitor()

        XCTAssertEqual(tieBreak.local, tieBreak.totalPoints - 1)
        XCTAssertEqual(tieBreak.visitor, tieBreak.totalPoints)
        XCTAssertFalse(tieBreak.didEnd)
    }

    // MARK: - Winning

    func test_AddPointsToLocalAndVisitor_toExtension_thenAddPointsToLocal_toWin() {
        let tieBreak = makeTieBreak()

        while(tieBreak.local < tieBreak.totalPoints - 1 && tieBreak.visitor < tieBreak.totalPoints - 1) {
            tieBreak.addPointToLocal()
            tieBreak.addPointToVisitor()
        }

        tieBreak.addPointToLocal()
        tieBreak.addPointToLocal()

        XCTAssertEqual(tieBreak.local, tieBreak.totalPoints + 1)
        XCTAssertEqual(tieBreak.visitor, tieBreak.totalPoints - 1)
        XCTAssertTrue(tieBreak.didEnd)
    }

    func test_AddPointsToLocalAndVisitor_toExtension_thenAddPointsToVisitor_toWin() {
        let tieBreak = makeTieBreak()

        while(tieBreak.local < tieBreak.totalPoints - 1 && tieBreak.visitor < tieBreak.totalPoints - 1) {
            tieBreak.addPointToLocal()
            tieBreak.addPointToVisitor()
        }

        tieBreak.addPointToVisitor()
        tieBreak.addPointToVisitor()

        XCTAssertEqual(tieBreak.local, tieBreak.totalPoints - 1)
        XCTAssertEqual(tieBreak.visitor, tieBreak.totalPoints + 1)
        XCTAssertTrue(tieBreak.didEnd)
    }

    // MARK: - Utils

    private func makeTieBreak(totalPoints: UInt8 = 7) -> TieBreak {
        let tieBreak = TieBreak(totalPoints: totalPoints)
        return tieBreak
    }
}
