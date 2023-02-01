
import Foundation
import XCTest

class ScoreTests: XCTestCase {

    // MARK: - Point sequence

    func test_pointSequence_noAdvantage() {
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

    func test_pointSequence_withAdvantage() {
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

    // MARK: - Score

    func test_startScore_withDefaultValues() {
        let score = makeSUT()

        XCTAssertTrue(score.serviceForPlayer1)
        XCTAssertFalse(score.isDeuce)
        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertEqual(score.sets, [[0, 0]])
    }

    // MARK: - Single point

    func test_winSinglePoint() {
        var score = makeSUT()

        score.winPoint()

        XCTAssertEqual(score.pointsForPlayer1, .fifteen)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertEqual(score.sets, [[0, 0]])
    }

    func test_loseSinglePoint() {
        var score = makeSUT()

        score.losePoint()

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .fifteen)
        XCTAssertEqual(score.sets, [[0, 0]])
    }

    // MARK: - Deuce

    func test_winAndLosePoints_toDeuce() {
        var score = makeSUT()

        let numberOfPoints = Score.Point.allCases.count - 2
        (1...numberOfPoints).forEach { _ in
            score.winPoint()
            score.losePoint()
        }

        XCTAssertTrue(score.isDeuce)
        XCTAssertTrue(score.serviceForPlayer1)
        XCTAssertEqual(score.pointsForPlayer1, .forty)
        XCTAssertEqual(score.pointsForPlayer2, .forty)
        XCTAssertEqual(score.sets, [[0, 0]])
    }

    // MARK: - Single game

    func test_winSingleGame_noAdvantage() {
        let options = ScoreTests.defaultOptions(advantage: false)
        var score = makeSUT(with: options)

        let numberOfPoints = Score.Point.allCases.count - 1
        (1...numberOfPoints).forEach { _ in
            let nextPoint = score.pointsForPlayer1.nextPoint(isAdvantage: false)
            score.winPoint()
            XCTAssertEqual(score.pointsForPlayer1, nextPoint)
            XCTAssertEqual(score.pointsForPlayer2, .love)
        }

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertFalse(score.serviceForPlayer1)
        XCTAssertEqual(score.sets, [[1, 0]])
    }

    func test_winSingleGame_withAdvantage() {
        var score = makeSUT()

        let numberOfPoints = Score.Point.allCases.count
        (1...numberOfPoints).forEach { _ in
            let nextPoint = score.pointsForPlayer1.nextPoint(isAdvantage: true)
            score.winPoint()
            XCTAssertEqual(score.pointsForPlayer1, nextPoint)
            XCTAssertEqual(score.pointsForPlayer2, .love)
        }

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertFalse(score.serviceForPlayer1)
        XCTAssertEqual(score.sets, [[1, 0]])
    }

    func test_loseSingleGame_noAdvantage() {
        let options = ScoreTests.defaultOptions(advantage: false)
        var score = makeSUT(with: options)

        let numberOfPoints = Score.Point.allCases.count - 1
        (1...numberOfPoints).forEach { _ in
            let nextPoint = score.pointsForPlayer2.nextPoint(isAdvantage: false)
            score.losePoint()
            XCTAssertEqual(score.pointsForPlayer1, .love)
            XCTAssertEqual(score.pointsForPlayer2, nextPoint)
        }

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertFalse(score.serviceForPlayer1)
        XCTAssertEqual(score.sets, [[0, 1]])
    }

    func test_loseSingleGame_withAdvantage() {
        var score = makeSUT()

        let numberOfPoints = Score.Point.allCases.count
        (1...numberOfPoints).forEach { _ in
            let nextPoint = score.pointsForPlayer2.nextPoint(isAdvantage: true)
            score.losePoint()
            XCTAssertEqual(score.pointsForPlayer1, .love)
            XCTAssertEqual(score.pointsForPlayer2, nextPoint)
        }

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertFalse(score.serviceForPlayer1)
        XCTAssertEqual(score.sets, [[0, 1]])
    }

    // MARK: - Tie break

    

    // MARK: - Single set

    func test_winSingleSet_noAdvantage() {
        let options = ScoreTests.defaultOptions(advantage: false)
        var score = makeSUT(with: options)

        (1...score.options.gamesPerSet).forEach {
            let numberOfPoints = Score.Point.allCases.count - 1
            (1...numberOfPoints).forEach { _ in
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

    func test_winSingleSet_withAdvantage() {
        var score = makeSUT()

        (1...score.options.gamesPerSet).forEach {
            let numberOfPoints = Score.Point.allCases.count
            (1...numberOfPoints).forEach { _ in
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

    func test_winSingleSet_withMinValues_noAdvantage() {
        let options = ScoreTests.defaultOptions(gamesPerSet: 1, minDifferencePerSet: 1, advantage: false)
        var score = makeSUT(with: options)

        (1...options.gamesPerSet).forEach {
            let numberOfPoints = Score.Point.allCases.count - 1
            (1...numberOfPoints).forEach { _ in
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
        if options.gamesPerSet % 2 == 0 {
            XCTAssertTrue(score.serviceForPlayer1)
        } else {
            XCTAssertFalse(score.serviceForPlayer1)
        }
        XCTAssertEqual(score.sets, [[score.options.gamesPerSet, 0], [0, 0]])
    }

    func test_winSingleSet_withMinValues_withAdvantage() {
        let options = ScoreTests.defaultOptions(gamesPerSet: 1, minDifferencePerSet: 1)
        var score = makeSUT(with: options)

        (1...options.gamesPerSet).forEach {
            let numberOfPoints = Score.Point.allCases.count
            (1...numberOfPoints).forEach { _ in
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
        if options.gamesPerSet % 2 == 0 {
            XCTAssertTrue(score.serviceForPlayer1)
        } else {
            XCTAssertFalse(score.serviceForPlayer1)
        }
        XCTAssertEqual(score.sets, [[score.options.gamesPerSet, 0], [0, 0]])
    }

    func test_loseSingleSet_noAdvantage() {
        let options = ScoreTests.defaultOptions(advantage: false)
        var score = makeSUT(with: options)

        (1...score.options.gamesPerSet).forEach {
            let numberOfPoints = Score.Point.allCases.count - 1
            (1...numberOfPoints).forEach { _ in
                if score.serviceForPlayer1 {
                    score.losePoint()
                } else {
                    score.winPoint()
                }
            }
            XCTAssertEqual(score.serviceForPlayer1,  $0 % 2 == 0)
        }

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertTrue(score.serviceForPlayer1)
        XCTAssertEqual(score.sets, [[0, score.options.gamesPerSet], [0, 0]])
    }

    func test_loseSingleSet_withAdvantage() {
        var score = makeSUT()

        (1...score.options.gamesPerSet).forEach {
            let numberOfPoints = Score.Point.allCases.count
            (1...numberOfPoints).forEach { _ in
                if score.serviceForPlayer1 {
                    score.losePoint()
                } else {
                    score.winPoint()
                }
            }
            XCTAssertEqual(score.serviceForPlayer1,  $0 % 2 == 0)
        }

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        XCTAssertTrue(score.serviceForPlayer1)
        XCTAssertEqual(score.sets, [[0, score.options.gamesPerSet], [0, 0]])
    }

    func test_loseSingleSet_withMinValues_noAdvantage() {
        let options = ScoreTests.defaultOptions(gamesPerSet: 1, minDifferencePerSet: 1, advantage: false)
        var score = makeSUT(with: options)

        (1...options.gamesPerSet).forEach {
            let numberOfPoints = Score.Point.allCases.count - 1
            (1...numberOfPoints).forEach { _ in
                if score.serviceForPlayer1 {
                    score.losePoint()
                } else {
                    score.winPoint()
                }
            }
            XCTAssertEqual(score.serviceForPlayer1,  $0 % 2 == 0)
        }

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        if options.gamesPerSet % 2 == 0 {
            XCTAssertTrue(score.serviceForPlayer1)
        } else {
            XCTAssertFalse(score.serviceForPlayer1)
        }
        XCTAssertEqual(score.sets, [[0, score.options.gamesPerSet], [0, 0]])
    }

    func test_loseSingleSet_withMinValues_withAdvantage() {
        let options = ScoreTests.defaultOptions(gamesPerSet: 1, minDifferencePerSet: 1)
        var score = makeSUT(with: options)

        (1...options.gamesPerSet).forEach {
            let numberOfPoints = Score.Point.allCases.count
            (1...numberOfPoints).forEach { _ in
                if score.serviceForPlayer1 {
                    score.losePoint()
                } else {
                    score.winPoint()
                }
            }
            XCTAssertEqual(score.serviceForPlayer1,  $0 % 2 == 0)
        }

        XCTAssertEqual(score.pointsForPlayer1, .love)
        XCTAssertEqual(score.pointsForPlayer2, .love)
        if options.gamesPerSet % 2 == 0 {
            XCTAssertTrue(score.serviceForPlayer1)
        } else {
            XCTAssertFalse(score.serviceForPlayer1)
        }
        XCTAssertEqual(score.sets, [[0, score.options.gamesPerSet], [0, 0]])
    }

    // MARK: - Match

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
