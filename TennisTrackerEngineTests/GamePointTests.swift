import Foundation
import XCTest
@testable import TennisTrackerEngine

class GamePointTests: XCTestCase {

    func test_pointSequence_noAdvantage() {
        var point: Game.Point = .love

        point.next(isAdvantage: false)
        XCTAssertEqual(point, .fifteen)

        point.next(isAdvantage: false)
        XCTAssertEqual(point, .thirty)

        point.next(isAdvantage: false)
        XCTAssertEqual(point, .forty)

        point.next(isAdvantage: false)
        XCTAssertEqual(point, .sixty)

        point.next(isAdvantage: false)
        XCTAssertEqual(point, .sixty)
    }

    func test_pointSequence_withAdvantage() {
        var point: Game.Point = .love

        point.next(isAdvantage: true)
        XCTAssertEqual(point, .fifteen)

        point.next(isAdvantage: true)
        XCTAssertEqual(point, .thirty)

        point.next(isAdvantage: true)
        XCTAssertEqual(point, .forty)

        point.next(isAdvantage: true)
        XCTAssertEqual(point, .advantage)

        point.next(isAdvantage: true)
        XCTAssertEqual(point, .sixty)

        point.next(isAdvantage: true)
        XCTAssertEqual(point, .sixty)
    }
}
