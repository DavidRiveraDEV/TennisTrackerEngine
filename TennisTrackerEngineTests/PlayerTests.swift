
import Foundation
import XCTest

class PlayerTests: XCTestCase {

    func test_player_withValidDefaultValues() {
        let playerName = "Name"

        let player = Player(name: playerName)

        XCTAssertEqual(player.name, playerName)
    }
}
