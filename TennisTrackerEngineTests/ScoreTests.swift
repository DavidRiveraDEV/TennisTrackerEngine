
import Foundation
import XCTest

class ScoreTests: XCTestCase {

    func test_scorePoint_nextValue() {
        var point: Score.Point = .love

        point = point.nextPoint(isAdvantage: false)
        XCTAssertEqual(point, .fifteen)

        point = point.nextPoint(isAdvantage: false)
        XCTAssertEqual(point, .thirty)

        point = point.nextPoint(isAdvantage: false)
        XCTAssertEqual(point, .forty)

        point = point.nextPoint(isAdvantage: false)
        XCTAssertEqual(point, .love)
    }

    func test_scorePoint_nextValue_withAdvantage() {
        var point: Score.Point = .love

        point = point.nextPoint(isAdvantage: true)
        XCTAssertEqual(point, .fifteen)

        point = point.nextPoint(isAdvantage: true)
        XCTAssertEqual(point, .thirty)

        point = point.nextPoint(isAdvantage: true)
        XCTAssertEqual(point, .forty)

        point = point.nextPoint(isAdvantage: true)
        XCTAssertEqual(point, .advantage)

        point = point.nextPoint(isAdvantage: true)
        XCTAssertEqual(point, .love)
    }

    func test_score_withValidDefaultValues() {
        let score = makeSUT()

        XCTAssertTrue(score.serviceForPlayer1)
        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertEqual(score.sets, [[0, 0]])
    }

    func test_score_winingSinglePoint() {
        var score = makeSUT()

        let nextPoint = score.pointsForPlayer1.nextPoint(isAdvantage: false)
        score.winPoint()

        XCTAssertEqual(score.pointsForPlayer1, nextPoint)
        XCTAssertEqual(score.sets, [[0, 0]])
    }

    func test_score_winingPoints() {
        let options = ScoreTests.defaultOptions(advantage: false)
        var score = makeSUT(with: options)

        (1...4).forEach { _ in
            let nextPoint = score.pointsForPlayer1.nextPoint(isAdvantage: false)
            score.winPoint()
            XCTAssertEqual(score.pointsForPlayer1, nextPoint)
        }
    }

    func test_score_winingPoints_withAdvantage() {
        var score = makeSUT()

        (1...5).forEach { _ in
            let nextPoint = score.pointsForPlayer1.nextPoint(isAdvantage: true)
            score.winPoint()
            XCTAssertEqual(score.pointsForPlayer1, nextPoint)
        }
    }

    func test_score_loseSinglePoint() {
        var score = makeSUT()

        let nextPoint = score.pointsForPlayer2.nextPoint(isAdvantage: false)
        score.losePoint()

        XCTAssertEqual(score.pointsForPlayer2, nextPoint)
        XCTAssertEqual(score.sets, [[0, 0]])
    }

    func test_score_losingPoints() {
        let options = ScoreTests.defaultOptions(advantage: false)
        var score = makeSUT(with: options)

        (1...4).forEach { _ in
            let nextPoint = score.pointsForPlayer2.nextPoint(isAdvantage: false)
            score.losePoint()
            XCTAssertEqual(score.pointsForPlayer2, nextPoint)
        }
    }

    func test_score_losingPoints_withAdvantage() {
        var score = makeSUT()

        (1...5).forEach { _ in
            let nextPoint = score.pointsForPlayer2.nextPoint(isAdvantage: true)
            score.losePoint()
            XCTAssertEqual(score.pointsForPlayer2, nextPoint)
        }
    }

    func test_score_winingPointsAndIncreaseGame() {
        let options = ScoreTests.defaultOptions(advantage: false)
        var score = makeSUT(with: options)

        (1...4).forEach { _ in
            score.winPoint()
        }

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertFalse(score.serviceForPlayer1)
        XCTAssertEqual(score.sets, [[1, 0]])
    }

    func test_score_winingPointsAndIncreaseGame_withAdvantage() {
        var score = makeSUT()

        (1...5).forEach { _ in
            score.winPoint()
        }

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertFalse(score.serviceForPlayer1)
        XCTAssertEqual(score.sets, [[1, 0]])
    }

    func test_score_losingPointsAndIncreaseGame() {
        let options = ScoreTests.defaultOptions(advantage: false)
        var score = makeSUT(with: options)

        (1...4).forEach { _ in
            score.losePoint()
        }

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertFalse(score.serviceForPlayer1)
        XCTAssertEqual(score.sets, [[0, 1]])
    }

    func test_score_losingPointsAndIncreaseGame_withAdvantage() {
        var score = makeSUT()

        (1...5).forEach { _ in
            score.losePoint()
        }

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertEqual(score.sets, [[0, 1]])
    }

    func test_score_winingAndLosingPoints_toDeuce() {
        var score = makeSUT()

        (1...3).forEach { _ in
            score.winPoint()
            score.losePoint()
        }

        XCTAssertTrue(score.isDeuce)
        XCTAssertEqual(score.pointsForPlayer1, .forty)
        XCTAssertEqual(score.pointsForPlayer2, .forty)
        XCTAssertTrue(score.serviceForPlayer1)
        XCTAssertEqual(score.sets, [[0, 0]])
    }

//    func test_score_winingPoints_withAdvantage() {
//        var score = makeSUT()
//
//        (1...3).forEach { _ in
//            score.winPoint()
//            score.losePoint()
//        }
//        score.winPoint()
//
//        XCTAssertFalse(score.isDeuce)
//        XCTAssertEqual(score.pointsForPlayer1, .advantage)
//        XCTAssertEqual(score.pointsForPlayer2, .forty)
//        XCTAssertEqual(score.sets, [[0, 0]])
//    }

    func test_score_winingPointsAndAppendSet() {
        let options = ScoreTests.defaultOptions(advantage: false)
        var score = makeSUT(with: options)

        (1...score.options.gamesPerSet).forEach {
            (1...4).forEach { _ in
                if score.serviceForPlayer1 {
                    score.winPoint()
                } else {
                    score.losePoint()
                }
            }
            XCTAssertEqual(score.serviceForPlayer1,  $0 % 2 == 0)
        }

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertTrue(score.serviceForPlayer1)
        XCTAssertEqual(score.sets, [[score.options.gamesPerSet, 0], [0, 0]])
    }

    func test_score_winingPointsAndAppendSet_withAdvantage() {
        var score = makeSUT()

        (1...score.options.gamesPerSet).forEach {
            (1...5).forEach { _ in
                if score.serviceForPlayer1 {
                    score.winPoint()
                } else {
                    score.losePoint()
                }
            }
            XCTAssertEqual(score.serviceForPlayer1,  $0 % 2 == 0)
        }

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertTrue(score.serviceForPlayer1)
        XCTAssertEqual(score.sets, [[score.options.gamesPerSet, 0], [0, 0]])
    }

    func test_score_winingPointsAndAppendSet_withMinValues() {
        let options = ScoreTests.defaultOptions(gamesPerSet: 1, minDifferencePerSet: 1, advantage: false)
        var score = makeSUT(with: options)

        (1...options.gamesPerSet).forEach {
            (1...4).forEach { _ in
                if score.serviceForPlayer1 {
                    score.winPoint()
                } else {
                    score.losePoint()
                }
            }
            XCTAssertEqual(score.serviceForPlayer1,  $0 % 2 == 0)
        }

        XCTAssertEqual(score.sets, [[options.gamesPerSet, 0], [0, 0]])
    }

    func test_score_winingPointsAndAppendSet_withMinValuesAndAdvantage() {
        let options = ScoreTests.defaultOptions(gamesPerSet: 1, minDifferencePerSet: 1)
        var score = makeSUT(with: options)

        (1...options.gamesPerSet).forEach {
            (1...5).forEach { _ in
                if score.serviceForPlayer1 {
                    score.winPoint()
                } else {
                    score.losePoint()
                }
            }
            XCTAssertEqual(score.serviceForPlayer1,  $0 % 2 == 0)
        }

        XCTAssertEqual(score.sets, [[options.gamesPerSet, 0], [0, 0]])
    }

    func test_score_losingPointsAndAppendSet() {
        let options = ScoreTests.defaultOptions(advantage: false)
        var score = makeSUT(with: options)

        (1...score.options.gamesPerSet).forEach {
            (1...4).forEach { _ in
                if score.serviceForPlayer1 {
                    score.losePoint()
                } else {
                    score.winPoint()
                }
            }
            XCTAssertEqual(score.serviceForPlayer1,  $0 % 2 == 0)
        }

        XCTAssertEqual(score.sets, [[0, score.options.gamesPerSet], [0, 0]])
    }

    func test_score_losingPointsAndAppendSet_withAdvantage() {
        var score = makeSUT()

        (1...score.options.gamesPerSet).forEach {
            (1...5).forEach { _ in
                if score.serviceForPlayer1 {
                    score.losePoint()
                } else {
                    score.winPoint()
                }
            }
            XCTAssertEqual(score.serviceForPlayer1,  $0 % 2 == 0)
        }

        XCTAssertEqual(score.sets, [[0, score.options.gamesPerSet], [0, 0]])
    }

    func test_score_losingPointsAndAppendSet_withMinValues() {
        let options = ScoreTests.defaultOptions(gamesPerSet: 1, minDifferencePerSet: 1, advantage: false)
        var score = makeSUT(with: options)

        (1...options.gamesPerSet).forEach {
            (1...4).forEach { _ in
                if score.serviceForPlayer1 {
                    score.losePoint()
                } else {
                    score.winPoint()
                }
            }
            XCTAssertEqual(score.serviceForPlayer1,  $0 % 2 == 0)
        }

        XCTAssertEqual(score.sets, [[0, options.gamesPerSet], [0, 0]])
    }

    func test_score_losingPointsAndAppendSet_withMinValuesAndAdvantage() {
        let options = ScoreTests.defaultOptions(gamesPerSet: 1, minDifferencePerSet: 1)
        var score = makeSUT(with: options)

        (1...options.gamesPerSet).forEach {
            (1...5).forEach { _ in
                if score.serviceForPlayer1 {
                    score.losePoint()
                } else {
                    score.winPoint()
                }
            }
            XCTAssertEqual(score.serviceForPlayer1,  $0 % 2 == 0)
        }

        XCTAssertEqual(score.sets, [[0, options.gamesPerSet], [0, 0]])
    }

    // MARK: - Utils

    private func makeSUT(with options: Score.Options = defaultOptions()) -> Score {
        return Score(with: options)
    }

    private static func defaultOptions(gamesPerSet: UInt8 = 6,
                                       minDifferencePerSet: UInt8 = 2,
                                       advantage: Bool = true) -> Score.Options {
        let options = Score.Options(gamesPerSet: gamesPerSet,
                                    minDifferencePerSet: minDifferencePerSet,
                                    advantage: advantage)
        return options
    }
}
