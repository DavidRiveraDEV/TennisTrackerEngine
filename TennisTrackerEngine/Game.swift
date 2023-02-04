
import Foundation

struct Game {

    let advantageEnabled: Bool

    private(set) var server: Point
    private(set) var receiver: Point

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

    mutating func addPointToServer() {
        if receiver == .advantage {
            receiver = .forty
        } else if receiver == .forty {
            server = server.nextPoint(isAdvantage: advantageEnabled)
        } else {
            server = server.nextPoint(isAdvantage: false)
        }
    }

    mutating func addPointToReceiver() {
        if server == .advantage {
            server = .forty
        } else if server == .forty {
            receiver = receiver.nextPoint(isAdvantage: advantageEnabled)
        }  else {
            receiver = receiver.nextPoint(isAdvantage: false)
        }
    }

    private func didServerWin() -> Bool {
        return server == .sixty
    }

    private func didReceiverWin() -> Bool {
        return receiver == .sixty
    }
}
