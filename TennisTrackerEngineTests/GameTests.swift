import Foundation
import XCTest
@testable import TennisTrackerEngine

class GameTests: XCTestCase {

    func test_game_withDefaultValues() {
        let advantageEnabled = true

        let game = makeGame(advantageEnabled: advantageEnabled)

        XCTAssertTrue(game.advantageEnabled)
        XCTAssertEqual(game.server, .love)
        XCTAssertEqual(game.receiver, .love)
        XCTAssertFalse(game.isDeuce)
        XCTAssertFalse(game.didEnd)
        XCTAssertNil(game.delegate)
    }

    func test_game_withWeakDelegate() {
        let game = makeGame()
        var gameDelegate: GameDelegate? = GameDelegateSpy()
        game.delegate = gameDelegate

        gameDelegate = nil

        XCTAssertNil(game.delegate)
    }

    // MARK: - Winning single point

    func test_addSinglePoint_toServer() {
        let game = makeGame()

        game.addPointToServer()

        XCTAssertEqual(game.server, .fifteen)
        XCTAssertEqual(game.receiver, .love)
    }

    func test_addSinglePoint_toReceiver() {
        let game = makeGame()

        game.addPointToReceiver()

        XCTAssertEqual(game.server, .love)
        XCTAssertEqual(game.receiver, .fifteen)
    }

    // MARK: - Deuce

    func test_AddPoints_toDeuce() {
        let game = makeGame()

        toDeuce(game: game)

        XCTAssertTrue(game.isDeuce)
        XCTAssertFalse(game.didEnd)
        XCTAssertEqual(game.server, .forty)
        XCTAssertEqual(game.receiver, .forty)
    }

    func test_AddPoints_toDeuce_thenAddPointToSever_toTakeAdvantage() {
        let game = makeGame()

        toDeuce(game: game)

        game.addPointToServer()

        XCTAssertFalse(game.isDeuce)
        XCTAssertFalse(game.didEnd)
        XCTAssertEqual(game.server, .advantage)
        XCTAssertEqual(game.receiver, .forty)
    }

    func test_AddPoints_toDeuce_thenAddPointToReceiver_toTakeAdvantage() {
        let game = makeGame()

        toDeuce(game: game)

        game.addPointToReceiver()

        XCTAssertFalse(game.isDeuce)
        XCTAssertFalse(game.didEnd)
        XCTAssertEqual(game.server, .forty)
        XCTAssertEqual(game.receiver, .advantage)
    }

    func test_AddPoints_toDeuce_thenAddPointToSever_toTakeAdvantage_thenAddPointToReceiver_toDeuce() {
        let game = makeGame()

        toDeuce(game: game)
        game.addPointToServer()
        game.addPointToReceiver()

        XCTAssertTrue(game.isDeuce)
        XCTAssertFalse(game.didEnd)
        XCTAssertEqual(game.server, .forty)
        XCTAssertEqual(game.receiver, .forty)
    }

    func test_AddPoints_toDeuce_thenAddPointToReceiver_toTakeAdvantage_thenAddPointToServer_toDeuce() {
        let game = makeGame()

        toDeuce(game: game)
        game.addPointToReceiver()
        game.addPointToServer()

        XCTAssertTrue(game.isDeuce)
        XCTAssertFalse(game.didEnd)
        XCTAssertEqual(game.server, .forty)
        XCTAssertEqual(game.receiver, .forty)
    }

    // MARK: - Winning game

    func test_addPointsToServer_toWin_notifyDelegate() {
        let game = makeGame()
        let gameDelegate = GameDelegateSpy()
        game.delegate = gameDelegate

        win(game: game, toServer: true)

        XCTAssertEqual(game.server, .sixty)
        XCTAssertEqual(game.receiver, .love)
        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
        XCTAssertTrue(gameDelegate.gameDidEndCalled)
    }

    func test_addPointsToServer_toWin_withAdvantage() {
        let game = makeGame()

        win(game: game, toServer: true)

        XCTAssertEqual(game.server, .sixty)
        XCTAssertEqual(game.receiver, .love)
        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
    }

    func test_addPointsToServer_toWin_noAdvantage() {
        let game = makeGame(advantageEnabled: false)

        win(game: game, toServer: true)

        XCTAssertEqual(game.server, .sixty)
        XCTAssertEqual(game.receiver, .love)
        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
    }

    func test_addPointsToServer_toWin_thenAddPoint() {
        let game = makeGame(advantageEnabled: false)

        win(game: game, toServer: true)
        game.addPointToServer()

        XCTAssertEqual(game.server, .sixty)
        XCTAssertEqual(game.receiver, .love)
        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
    }

    func test_addPointsToReceiver_toWin_withAdvantage() {
        let game = makeGame()

        win(game: game, toServer: false)

        XCTAssertEqual(game.server, .love)
        XCTAssertEqual(game.receiver, .sixty)
        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
    }

    func test_addPointsToReceiver_toWin_noAdvantage() {
        let game = makeGame()

        win(game: game, toServer: false)

        XCTAssertEqual(game.server, .love)
        XCTAssertEqual(game.receiver, .sixty)
        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
    }

    func test_addPointsToReceiver_toWin_thenAddPoint() {
        let game = makeGame(advantageEnabled: false)

        win(game: game, toServer: false)
        game.addPointToReceiver()

        XCTAssertEqual(game.server, .love)
        XCTAssertEqual(game.receiver, .sixty)
        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
    }

    func test_AddPoints_toDeuce_thenAddPointToSever_toWin_withAdvantage() {
        let game = makeGame()

        toDeuce(game: game)

        game.addPointToServer()
        game.addPointToServer()

        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
        XCTAssertEqual(game.server, .sixty)
        XCTAssertEqual(game.receiver, .forty)
    }

    func test_AddPoints_toDeuce_thenAddPointToSever_toWin_noAdvantage() {
        let game = makeGame(advantageEnabled: false)

        toDeuce(game: game)

        game.addPointToServer()

        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
        XCTAssertEqual(game.server, .sixty)
        XCTAssertEqual(game.receiver, .forty)
    }

    func test_AddPoints_toDeuce_thenAddPointToReceiver_toWin_withAdvantage() {
        let game = makeGame()

        toDeuce(game: game)

        game.addPointToReceiver()
        game.addPointToReceiver()

        XCTAssertFalse(game.isDeuce)
        XCTAssertTrue(game.didEnd)
        XCTAssertEqual(game.server, .forty)
        XCTAssertEqual(game.receiver, .sixty)
    }

    func test_AddPoints_toDeuce_thenAddPointToReceiver_toWin_noAdvantage() {
        let game = makeGame(advantageEnabled: false)

        toDeuce(game: game)

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

    private func toDeuce(game: Game) {
        (1...3).forEach { _ in
            game.addPointToServer()
            game.addPointToReceiver()
        }
    }

    private func win(game: Game, toServer: Bool) {
        (1...4).forEach { _ in
            if toServer {
                game.addPointToServer()
            } else {
                game.addPointToReceiver()
            }
        }
    }

    private class GameDelegateSpy: GameDelegate {

        private(set) var gameDidEndCalled: Bool = false

        func gameDidEnd() {
            gameDidEndCalled = true
        }
    }
}
