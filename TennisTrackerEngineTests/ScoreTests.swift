
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
        let score = makeSUT()

        XCTAssertEqual(score.serviceForPlayer1, true)
        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertEqual(score.sets, [[0, 0]])
    }

    func test_score_winingSinglePoint() {
        var score = makeSUT()

        let nextPoint = score.pointsForPlayer1.nextPoint
        score.winPoint()
        XCTAssertEqual(score.pointsForPlayer1, nextPoint)
        XCTAssertEqual(score.sets, [[0, 0]])
    }

    func test_score_winingPoints() {
        var score = makeSUT()

        (1...4).forEach { _ in
            let nextPoint = score.pointsForPlayer1.nextPoint
            score.winPoint()
            XCTAssertEqual(score.pointsForPlayer1, nextPoint)
        }
    }

    func test_score_loseSinglePoint() {
        var score = makeSUT()

        let nextPoint = score.pointsForPlayer2.nextPoint
        score.losePoint()
        XCTAssertEqual(score.pointsForPlayer2, nextPoint)
        XCTAssertEqual(score.sets, [[0, 0]])
    }

    func test_score_losingPoints() {
        var score = makeSUT()

        (1...4).forEach { _ in
            let nextPoint = score.pointsForPlayer2.nextPoint
            score.losePoint()
            XCTAssertEqual(score.pointsForPlayer2, nextPoint)
        }
    }

    func test_score_winingPointsAndIncreaseGame() {
        var score = makeSUT()

        (1...4).forEach { _ in
            score.winPoint()
        }

        XCTAssertEqual(score.sets, [[1, 0]])
    }

    func test_score_losingPointsAndIncreaseGame() {
        var score = makeSUT()

        (1...4).forEach { _ in
            score.losePoint()
        }

        XCTAssertEqual(score.sets, [[0, 1]])
    }

    func test_score_winingPointsAndAppendSet() {
        var score = makeSUT()

        (1...score.options.gamesPerSet).forEach { _ in
            (1...4).forEach { _ in
                score.winPoint()
            }
        }

        XCTAssertEqual(score.sets, [[score.options.gamesPerSet, 0], [0, 0]])
    }

    func test_score_winingPointsAndAppendSet_withMinValues() {
        let gamesPerSet: UInt8 = 1
        let minDifferencePerSet: UInt8 = 1
        let options = Score.Options(gamesPerSet: gamesPerSet,
                                    minDifferencePerSet: minDifferencePerSet)
        var score = makeSUT(with: options)

        (1...gamesPerSet).forEach { _ in
            (1...4).forEach { _ in
                score.winPoint()
            }
        }

        XCTAssertEqual(score.sets, [[gamesPerSet, 0], [0, 0]])
    }

    func test_score_losingPointsAndAppendSet() {
        var score = makeSUT()

        (1...score.options.gamesPerSet).forEach { _ in
            (1...4).forEach { _ in
                score.losePoint()
            }
        }

        XCTAssertEqual(score.sets, [[0, score.options.gamesPerSet], [0, 0]])
    }

    func test_score_losingPointsAndAppendSet_withMinValues() {
        let gamesPerSet: UInt8 = 1
        let minDifferencePerSet: UInt8 = 1
        let options = Score.Options(gamesPerSet: gamesPerSet,
                                    minDifferencePerSet: minDifferencePerSet)
        var score = makeSUT(with: options)

        (1...gamesPerSet).forEach { _ in
            (1...4).forEach { _ in
                score.losePoint()
            }
        }

        XCTAssertEqual(score.sets, [[0, gamesPerSet], [0, 0]])
    }

    // MARK: - Utils

    private func makeSUT(with options: Score.Options = defaultOptions) -> Score {
        return Score(with: options)
    }

    private static var defaultOptions: Score.Options {
        let gamesPerSet: UInt8 = 6
        let minDifferencePerSet: UInt8 = 2
        let options = Score.Options(gamesPerSet: gamesPerSet,
                                    minDifferencePerSet: minDifferencePerSet)
        return options
    }
}
