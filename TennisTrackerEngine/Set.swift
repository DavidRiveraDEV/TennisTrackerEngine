import Foundation

protocol SetDelegate: AnyObject {
    func setDidEnd()
}

class Set: GameDelegate {

    static let minDifferencePerSet: UInt8 = 2

    private(set) var serviceType: ServiceType
    let totalGames: UInt8
    private var history: [ServiceType: [Game]]
    private var currentGame: Game
    private var tieBreak: TieBreak

    weak var delegate: SetDelegate?

    var localGames: UInt8 {
        return UInt8(history[.local]!.count)
    }

    var visitorGames: UInt8 {
        return UInt8(history[.visitor]!.count)
    }

    var isTieBreak: Bool {
        localGames >= totalGames && visitorGames >= totalGames
    }

    var localTieBreakPoints: UInt8 {
        return tieBreak.local
    }

    var visitorTieBreakPoints: UInt8 {
        return tieBreak.visitor
    }

    var didEnd: Bool {
        if isTieBreak {
            return tieBreak.didEnd
        } else if localGames >= totalGames || visitorGames >= totalGames {
            let difference = max(localGames, visitorGames) - min(localGames, visitorGames)
            return difference >= Set.minDifferencePerSet
        }
        return false
    }

    init(serviceType: ServiceType, totalGames: UInt8, totalPointsForTieBreak: UInt8, advantageEnabled: Bool) {
        self.serviceType = serviceType
        if totalGames < Set.minDifferencePerSet {
            debugPrint("totalGames cannot be lower than \(Set.minDifferencePerSet). " +
                       "totalGames will be set to \(Set.minDifferencePerSet)")
            self.totalGames = Set.minDifferencePerSet
        } else {
            self.totalGames = totalGames
        }
        self.history = [.local: [], .visitor: []]
        self.currentGame = Game(advantageEnabled: advantageEnabled)
        self.tieBreak = TieBreak(totalPoints: totalPointsForTieBreak)
        self.currentGame.delegate = self
    }

    func winPoint() {
        if isTieBreak {
            winPointToTieBreak()
            checkForTieBreakServiceChange()
        } else {
            currentGame.addPointToServer()
        }
    }

    func losePoint() {
        if isTieBreak {
            losePointToTieBreak()
            checkForTieBreakServiceChange()
        } else {
            currentGame.addPointToReceiver()
        }
    }

    private func winPointToTieBreak() {
        if serviceType == .local {
            tieBreak.addPointToLocal()
        } else {
            tieBreak.addPointToVisitor()
        }
    }

    private func losePointToTieBreak() {
        if serviceType == .local {
            tieBreak.addPointToVisitor()
        } else {
            tieBreak.addPointToLocal()
        }
    }

    private func checkForTieBreakServiceChange() {
        if tieBreak.didEnd {
            addCurrentGameToHistory()
        } else if shouldChangeServiceForTieBreak() {
            changeService()
        }
    }

    private func changeService() {
        serviceType = serviceType.next
    }

    private func shouldChangeServiceForTieBreak() -> Bool {
        let pointsPlayed = tieBreak.local + tieBreak.visitor
        return !tieBreak.didEnd && pointsPlayed % 2 == 1
    }

    private func startNewGame() {
        if  !isTieBreak {
            currentGame = Game(advantageEnabled: currentGame.advantageEnabled)
            currentGame.delegate = self
        }
    }

    private func addCurrentGameToHistory() {
        currentGame.delegate = nil
        if isTieBreak {
            let winnerServiceType: ServiceType = tieBreak.local > tieBreak.visitor ? .local : .visitor
            history[winnerServiceType]?.append(currentGame)
        } else if currentGame.server == .sixty {
            history[serviceType]?.append(currentGame)
        } else {
            history[serviceType.next]?.append(currentGame)
        }
    }

    private func checkIfSetEnded() {
        if didEnd {
            delegate?.setDidEnd()
        }
    }

    // MARK: - GameDelegate

    func gameDidEnd() {
        addCurrentGameToHistory()
        startNewGame()
        changeService()
        checkIfSetEnded()
    }
}
