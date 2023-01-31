
import Foundation
import XCTest

class ScoreTests: XCTestCase {

    func test_scorePoint_nextValue() {
        var point: Score.Point = .love

        point = point.nextPoint
        XCTAssertEqual(point, .fifteen)

        point = point.nextPoint
        XCTAssertEqual(point, .thirty)

        point = point.nextPoint
        XCTAssertEqual(point, .forty)

        point = point.nextPoint
        XCTAssertEqual(point, .love)
    }

    func test_score_withValidDefaultValues() {
        let score = Score()

        XCTAssertEqual(score.serviceForPlayer1, true)
        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertEqual(score.sets, [[0, 0]])
    }

    func test_score_winingPoints() {
        var score = Score()

        (1...4).forEach { _ in
            let nextPoint = score.pointsForPlayer1.nextPoint
            score.winPoint()
            XCTAssertEqual(score.pointsForPlayer1, nextPoint)
        }
    }

    func test_score_losingPoints() {
        var score = Score()

        (1...4).forEach { _ in
            let nextPoint = score.pointsForPlayer2.nextPoint
            score.losePoint()
            XCTAssertEqual(score.pointsForPlayer2, nextPoint)
        }
    }

    func test_score_winingPointsAndIncreaseGame() {
        var score = Score()

        (1...4).forEach { _ in
            score.winPoint()
        }

        XCTAssertEqual(score.sets, [[1, 0]])
    }

    func test_score_losingPointsAndIncreaseGame() {
        var score = Score()

        (1...4).forEach { _ in
            score.losePoint()
        }

        XCTAssertEqual(score.sets, [[0, 1]])
    }

    func test_score_winingPointsAndIncreaseSet() {
        var score = Score()

        (1...7).forEach {
            (1...4).forEach { _ in
                score.winPoint()
            }
            XCTAssertEqual(score.sets, [[UInt8($0), 0]])
        }
    }

    func test_score_losingPointsAndIncreaseSet() {
        var score = Score()

        (1...7).forEach {
            (1...4).forEach { _ in
                score.losePoint()
            }
            XCTAssertEqual(score.sets, [[0, UInt8($0)]])
        }
    }
}
