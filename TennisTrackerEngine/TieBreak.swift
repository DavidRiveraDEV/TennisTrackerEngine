import Foundation

final class TieBreak {

    static let minDifference: UInt8 = 2

    let totalPoints: UInt8

    private(set) var local: UInt8
    private(set) var visitor: UInt8

    var didEnd: Bool {
        return didLocalWin() || didVisitorWin()
    }

    init(totalPoints: UInt8) {
        if totalPoints < TieBreak.minDifference {
            debugPrint("totalPoints (\(totalPoints)) cannot be lower than \(TieBreak.minDifference). " +
                       "totalPoints will be set to \(TieBreak.minDifference)")
            self.totalPoints = TieBreak.minDifference
        } else {
            self.totalPoints = totalPoints
        }
        self.local = 0
        self.visitor = 0
    }

    func addPointToLocal() {
        if !didEnd {
            local += 1
        }
    }

    func addPointToVisitor() {
        if !didEnd {
            visitor += 1
        }
    }

    private func didLocalWin() -> Bool {
        return local >= totalPoints && local - TieBreak.minDifference >= visitor
    }

    private func didVisitorWin() -> Bool {
        return visitor >= totalPoints && visitor - TieBreak.minDifference >= local
    }
}
