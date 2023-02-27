import Foundation

protocol GameDelegate: AnyObject {
    func gameDidEnd()
}

class Game {

    let advantageEnabled: Bool

    private(set) var server: Point
    private(set) var receiver: Point

    weak var delegate: GameDelegate?

    init(advantageEnabled: Bool) {
        self.advantageEnabled = advantageEnabled
        self.server = .love
        self.receiver = .love
    }

    var isDeuce: Bool {
        return server == .forty && receiver == .forty
    }

    var didEnd: Bool {
        return didServerWin() || didReceiverWin()
    }

    func addPointToServer() {
        if receiver == .advantage {
            receiver = .forty
        } else if receiver == .forty {
            server.next(isAdvantage: advantageEnabled)
        } else {
            server.next(isAdvantage: false)
        }
        checkIfGameEnded()
    }

    func addPointToReceiver() {
        if server == .advantage {
            server = .forty
        } else if server == .forty {
            receiver.next(isAdvantage: advantageEnabled)
        } else {
             receiver.next(isAdvantage: false)
        }
        checkIfGameEnded()
    }

    private func checkIfGameEnded() {
        if didEnd {
            delegate?.gameDidEnd()
        }
    }

    private func didServerWin() -> Bool {
        return server == .sixty
    }

    private func didReceiverWin() -> Bool {
        return receiver == .sixty
    }
}
