
import Foundation
import XCTest

class GameTests: XCTestCase {

    func test_game_withDefaultValues() {
        let advantageEnabled = true

        let game = makeGame(advantageEnabled: advantageEnabled)

        XCTAssertTrue(game.advantageEnabled)
        XCTAssertEqual(game.server, .love)
        XCTAssertEqual(game.receiver, .love)
        XCTAssertFalse(game.isDeuce)
        XCTAssertFalse(game.didEnd)
    }

    // MARK: - Winning single point

    func test_addSinglePoint_toServer() {
        var game = makeGame()

        game.addPointToServer()

        XCTAssertEqual(game.server, .fifteen)
        XCTAssertEqual(game.receiver, .love)
    }

    func test_addSinglePoint_toReceiver() {
        var game = makeGame()

        game.addPointToReceiver()

        XCTAssertEqual(game.server, .love)
        XCTAssertEqual(game.receiver, .fifteen)
    }

    // MARK: - Deuce

    func test_AddPointsToServerAndReceiver_toDeuce() {
        var game = makeGame()

        while(game.server != .forty && game.receiver != .forty) {
            game.addPointToServer()
            game.addPointToReceiver()
        }

        XCTAssertTrue(game.isDeuce)
        XCTAssertFalse(game.didEnd)
        XCTAssertEqual(game.server, .forty)
        XCTAssertEqual(game.receiver, .forty)
    }

    func test_AddPointsToServerAndReceiver_toDeuce_thenAddPointToSever_toTakeAdvantage() {
        var game = makeGame()

        while(game.server != .forty && game.receiver != .forty) {
            game.addPointToServer()
            game.addPointToReceiver()
        }

        game.addPointToServer()

        XCTAssertFalse(game.isDeuce)
        XCTAssertFalse(game.didEnd)
        XCTAssertEqual(game.server, .advantage)
        XCTAssertEqual(game.receiver, .forty)
    }

    func test_AddPointsToServerAndReceiver_toDeuce_thenAddPointToReceiver_toTakeAdvantage() {
        var game = makeGame()

        while(game.server != .forty && game.receiver != .forty) {
            game.addPointToServer()
            game.addPointToReceiver()
        }

        game.addPointToReceiver()

        XCTAssertFalse(game.isDeuce)
        XCTAssertFalse(game.didEnd)
        XCTAssertEqual(game.server, .forty)
        XCTAssertEqual(game.receiver, .advantage)
    }

    func test_AddPointsToServerAndReceiver_toDeuce_thenAddPointToSever_toTakeAdvantage_thenAddPointToReceiver_toDeuce() {
        var game = makeGame()

        while(game.server != .forty && game.receiver != .forty) {
            game.addPointToServer()
            game.addPointToReceiver()
        }
        game.addPointToServer()
        game.addPointToReceiver()

        XCTAssertTrue(game.isDeuce)
        XCTAssertFalse(game.didEnd)
        XCTAssertEqual(game.server, .forty)
        XCTAssertEqual(game.receiver, .forty)
    }

    func test_AddPointsToServerAndReceiver_toDeuce_thenAddPointToReceiver_toTakeAdvantage_thenAddPointToServer_toDeuce() {
        var game = makeGame()

        while(game.server != .forty && game.receiver != .forty) {
            game.addPointToServer()
            game.addPointToReceiver()
        }

        game.addPointToReceiver()
        game.addPointToServer()

        XCTAssertTrue(game.isDeuce)
        XCTAssertFalse(game.didEnd)
        XCTAssertEqual(game.server, .forty)
        XCTAssertEqual(game.receiver, .forty)
    }

    // MARK: - Winning single game

    func test_addPointsToServer_toWin_withAdvantage() {
        var game = makeGame()

        while(game.server != .sixty) {
            game.addPointToServer()
        }

        XCTAssertEqual(game.server, .sixty)
        XCTAssertEqual(game.receiver, .love)
        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
    }

    func test_addPointsToServer_toWin_noAdvantage() {
        var game = makeGame(advantageEnabled: false)

        while(game.server != .sixty) {
            game.addPointToServer()
        }

        XCTAssertEqual(game.server, .sixty)
        XCTAssertEqual(game.receiver, .love)
        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
    }

    func test_addPointsToReceiver_toWin_withAdvantage() {
        var game = makeGame()

        while(game.receiver != .sixty) {
            game.addPointToReceiver()
        }

        XCTAssertEqual(game.server, .love)
        XCTAssertEqual(game.receiver, .sixty)
        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
    }

    func test_addPointsToReceiver_toWin_noAdvantage() {
        var game = makeGame()

        while(game.receiver != .sixty) {
            game.addPointToReceiver()
        }

        XCTAssertEqual(game.server, .love)
        XCTAssertEqual(game.receiver, .sixty)
        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
    }

    func test_AddPointsToServerAndReceiver_toDeuce_thenAddPointToSever_toWin_withAdvantage() {
        var game = makeGame()

        while(game.server != .forty && game.receiver != .forty) {
            game.addPointToServer()
            game.addPointToReceiver()
        }

        game.addPointToServer()
        game.addPointToServer()

        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
        XCTAssertEqual(game.server, .sixty)
        XCTAssertEqual(game.receiver, .forty)
    }

    func test_AddPointsToServerAndReceiver_toDeuce_thenAddPointToSever_toWin_noAdvantage() {
        var game = makeGame(advantageEnabled: false)

        while(game.server != .forty && game.receiver != .forty) {
            game.addPointToServer()
            game.addPointToReceiver()
        }

        game.addPointToServer()

        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
        XCTAssertEqual(game.server, .sixty)
        XCTAssertEqual(game.receiver, .forty)
    }

    func test_AddPointsToServerAndReceiver_toDeuce_thenAddPointToReceiver_toWin_withAdvantage() {
        var game = makeGame()

        while(game.server != .forty && game.receiver != .forty) {
            game.addPointToServer()
            game.addPointToReceiver()
        }

        game.addPointToReceiver()
        game.addPointToReceiver()

        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
        XCTAssertEqual(game.server, .forty)
        XCTAssertEqual(game.receiver, .sixty)
    }

    func test_AddPointsToServerAndReceiver_toDeuce_thenAddPointToReceiver_toWin_noAdvantage() {
        var game = makeGame(advantageEnabled: false)

        while(game.server != .forty && game.receiver != .forty) {
            game.addPointToServer()
            game.addPointToReceiver()
        }

        game.addPointToReceiver()

        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
        XCTAssertEqual(game.server, .forty)
        XCTAssertEqual(game.receiver, .sixty)
    }
    
    // MARK: - Utils

    private func makeGame(advantageEnabled: Bool = true) -> Game {
        let game = Game(advantageEnabled: advantageEnabled)
        return game
    }
}
