
import Foundation

class Match {

    let options: Options
    let localPlayer: Player
    let visitorPlayer: Player

    private(set) var sets: [Set]

    init(with options: Options, localPlayer: Player, visitorPlayer: Player) {
        self.options = options
        self.localPlayer = localPlayer
        self.visitorPlayer = visitorPlayer
        self.sets = []
        startNewSet()
    }

    private func startNewSet() {
        let set = Set(serviceType: options.serviceType,
                      totalGames: options.gamesPerSet,
                      totalPointsForTieBreak: options.pointsPerTieBreak,
                      advantageEnabled: options.advantage)
        sets.append(set)
    }
    
}
