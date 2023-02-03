
import Foundation
import XCTest

class TieBreakTests: XCTestCase {

    func test_tieBreak_withDefaultValues() {
        let totalPoints: UInt8 = 7

        let tieBreak = TieBreak(totalPoints: totalPoints)

        XCTAssertEqual(tieBreak.totalPoints, totalPoints)
        XCTAssertEqual(tieBreak.server, 0)
        XCTAssertEqual(tieBreak.receiver, 0)
        XCTAssertFalse(tieBreak.didEnd)
    }

    // MARK: - Winning single point

    func test_addSinglePoint_toServer() {
        var tieBreak = makeTieBreak()

        tieBreak.addPointToServer()

        XCTAssertEqual(tieBreak.server, 1)
        XCTAssertEqual(tieBreak.receiver, 0)
        XCTAssertFalse(tieBreak.didEnd)
    }

    func test_addSinglePoint_toReceiver() {
        var tieBreak = makeTieBreak()

        tieBreak.addPointToReceiver()

        XCTAssertEqual(tieBreak.server, 0)
        XCTAssertEqual(tieBreak.receiver, 1)
        XCTAssertFalse(tieBreak.didEnd)
    }

    // MARK: - Going to extension

    func test_AddPointsToServerAndReceiver_toExtension_thenAddPointToServer_notWinning() {
        var tieBreak = makeTieBreak()

        while(tieBreak.server < tieBreak.totalPoints - 1 && tieBreak.receiver < tieBreak.totalPoints - 1) {
            tieBreak.addPointToServer()
            tieBreak.addPointToReceiver()
        }

        tieBreak.addPointToServer()

        XCTAssertEqual(tieBreak.server, tieBreak.totalPoints)
        XCTAssertEqual(tieBreak.receiver, tieBreak.totalPoints - 1)
        XCTAssertFalse(tieBreak.didEnd)
    }

    func test_AddPointsToServerAndReceiver_toExtension_thenAddPointToReceiver_notWinning() {
        var tieBreak = makeTieBreak()

        while(tieBreak.server < tieBreak.totalPoints - 1 && tieBreak.receiver < tieBreak.totalPoints - 1) {
            tieBreak.addPointToServer()
            tieBreak.addPointToReceiver()
        }

        tieBreak.addPointToReceiver()

        XCTAssertEqual(tieBreak.server, tieBreak.totalPoints - 1)
        XCTAssertEqual(tieBreak.receiver, tieBreak.totalPoints)
        XCTAssertFalse(tieBreak.didEnd)
    }

    // MARK: - Winning

    func test_AddPointsToServerAndReceiver_toExtension_thenAddPointsToServer_toWin() {
        var tieBreak = makeTieBreak()

        while(tieBreak.server < tieBreak.totalPoints - 1 && tieBreak.receiver < tieBreak.totalPoints - 1) {
            tieBreak.addPointToServer()
            tieBreak.addPointToReceiver()
        }

        tieBreak.addPointToServer()
        tieBreak.addPointToServer()

        XCTAssertEqual(tieBreak.server, tieBreak.totalPoints + 1)
        XCTAssertEqual(tieBreak.receiver, tieBreak.totalPoints - 1)
        XCTAssertTrue(tieBreak.didEnd)
    }

    func test_AddPointsToServerAndReceiver_toExtension_thenAddPointsToReceiver_toWin() {
        var tieBreak = makeTieBreak()

        while(tieBreak.server < tieBreak.totalPoints - 1 && tieBreak.receiver < tieBreak.totalPoints - 1) {
            tieBreak.addPointToServer()
            tieBreak.addPointToReceiver()
        }

        tieBreak.addPointToReceiver()
        tieBreak.addPointToReceiver()

        XCTAssertEqual(tieBreak.server, tieBreak.totalPoints - 1)
        XCTAssertEqual(tieBreak.receiver, tieBreak.totalPoints + 1)
        XCTAssertTrue(tieBreak.didEnd)
    }

    // MARK: - Utils

    private func makeTieBreak(totalPoints: UInt8 = 7) -> TieBreak {
        let tieBreak = TieBreak(totalPoints: totalPoints)
        return tieBreak
    }
}
