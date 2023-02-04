
import Foundation

class TieBreak {

    static private let minDifference: UInt8 = 2

    let totalPoints: UInt8

    private(set) var local: UInt8
    private(set) var visitor: UInt8

    var didEnd: Bool {
        return didLocalWin() || didVisitorWin()
    }

    init(totalPoints: UInt8) {
        precondition(totalPoints >= TieBreak.minDifference, "totalPoints (\(totalPoints)) cannot be lower than \(TieBreak.minDifference).")
        self.totalPoints = totalPoints
        self.local = 0
        self.visitor = 0
    }

    func addPointToLocal() {
        local += 1
    }

    func addPointToVisitor() {
        visitor += 1
    }

    private func didLocalWin() -> Bool {
        return local >= totalPoints && local - TieBreak.minDifference >= visitor
    }

    private func didVisitorWin() -> Bool {
        return visitor >= totalPoints && visitor - TieBreak.minDifference >= local
    }
}
