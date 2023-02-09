import Foundation
import XCTest

class GamePointTests: XCTestCase {

    func test_pointSequence_noAdvantage() {
        var point: Game.Point = .love

        point = point.nextPoint(isAdvantage: false)
        XCTAssertEqual(point, .fifteen)

        point = point.nextPoint(isAdvantage: false)
        XCTAssertEqual(point, .thirty)

        point = point.nextPoint(isAdvantage: false)
        XCTAssertEqual(point, .forty)

        point = point.nextPoint(isAdvantage: false)
        XCTAssertEqual(point, .sixty)
    }

    func test_pointSequence_withAdvantage() {
        var point: Game.Point = .love

        point = point.nextPoint(isAdvantage: true)
        XCTAssertEqual(point, .fifteen)

        point = point.nextPoint(isAdvantage: true)
        XCTAssertEqual(point, .thirty)

        point = point.nextPoint(isAdvantage: true)
        XCTAssertEqual(point, .forty)

        point = point.nextPoint(isAdvantage: true)
        XCTAssertEqual(point, .advantage)

        point = point.nextPoint(isAdvantage: true)
        XCTAssertEqual(point, .sixty)
    }
}
