
import Foundation

struct Set {

    static let minDifferencePerSet: UInt8 = 2

    private(set) var serviceType: ServiceType
    private(set) var totalGames: UInt8
    private var history: [ServiceType : [Game]]
    private var currentGame: Game
    private var tieBreak: TieBreak

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
        precondition(totalGames >= Set.minDifferencePerSet, "Total games cannot be lower than \(Set.minDifferencePerSet)")
        self.serviceType = serviceType
        self.totalGames = totalGames
        self.history = [.local: [], .visitor: []]
        self.currentGame = Game(advantageEnabled: advantageEnabled)
        self.tieBreak = TieBreak(totalPoints: totalPointsForTieBreak)
    }

    mutating func winPoint() {
        if isTieBreak {
            winPointToTieBreak()
            checkForTieBreakServiceChange()
        } else {
            currentGame.addPointToServer()
            checkIfGameEnded()
        }
    }

    mutating func losePoint() {
        if isTieBreak {
            losePointToTieBreak()
            checkForTieBreakServiceChange()
        } else {
            currentGame.addPointToReceiver()
            checkIfGameEnded()
        }
    }

    private mutating func winPointToTieBreak() {
        if serviceType == .local {
            tieBreak.addPointToLocal()
        } else {
            tieBreak.addPointToVisitor()
        }
    }

    private mutating func losePointToTieBreak() {
        if serviceType == .local {
            tieBreak.addPointToVisitor()
        } else {
            tieBreak.addPointToLocal()
        }
    }

    private mutating func checkIfGameEnded() {
        if currentGame.didEnd {
            addCurrentGameToHistory()
            startNewGame()
            changeService()
        }
    }

    private mutating func checkForTieBreakServiceChange() {
        if tieBreak.didEnd {
            addCurrentGameToHistory()
        } else if shouldChangeServiceForTieBreak(){
            changeService()
        }
    }

    private mutating func changeService() {
        serviceType = getNextServiceType(for: serviceType)
    }

    private func shouldChangeServiceForTieBreak() -> Bool {
        let pointsPlayed = tieBreak.local + tieBreak.visitor
        return !tieBreak.didEnd && pointsPlayed % 2 == 1
    }

    private mutating func startNewGame() {
        if  !isTieBreak {
            currentGame = Game(advantageEnabled: currentGame.advantageEnabled)
        }
    }

    private mutating func addCurrentGameToHistory() {
        if isTieBreak {
            let winnerServiceType: ServiceType = tieBreak.local > tieBreak.visitor ? .local : .visitor
            history[winnerServiceType]?.append(currentGame)
        } else if currentGame.server == .sixty {
            history[serviceType]?.append(currentGame)
        } else {
            history[getNextServiceType(for: serviceType)]?.append(currentGame)
        }
    }

    private func getNextServiceType(for serviceType: ServiceType) -> ServiceType {
        switch serviceType {
        case .local: return .visitor
        case .visitor: return .local
        }
    }
}
