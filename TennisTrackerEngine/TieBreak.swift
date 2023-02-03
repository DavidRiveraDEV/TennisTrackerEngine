
import Foundation

struct TieBreak {

    static private let minDifference: UInt8 = 2

    let totalPoints: UInt8

    private(set) var server: UInt8
    private(set) var receiver: UInt8

    var didEnd: Bool {
        return didServerWin() || didReceiverWin()
    }

    init(totalPoints: UInt8) {
        precondition(totalPoints >= TieBreak.minDifference, "totalPoints (\(totalPoints)) cannot be lower than \(TieBreak.minDifference).")
        self.totalPoints = totalPoints
        self.server = 0
        self.receiver = 0
    }

    mutating func addPointToServer() {
        server += 1
    }

    mutating func addPointToReceiver() {
        receiver += 1
    }

    private func didServerWin() -> Bool {
        return server >= totalPoints && server - TieBreak.minDifference >= receiver
    }

    private func didReceiverWin() -> Bool {
        return receiver >= totalPoints && receiver - TieBreak.minDifference >= server
    }
}
