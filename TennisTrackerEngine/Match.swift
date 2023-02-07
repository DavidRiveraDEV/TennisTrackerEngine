
import Foundation

protocol MatchDelegate: AnyObject {
    func matchDidEnd()
}

class Match: SetDelegate {

    let options: Options
    let localPlayer: Player
    let visitorPlayer: Player

    private var sets: [Set]
    private var currentSet: Set!

    weak var delegate: MatchDelegate?

    var serviceType: ServiceType {
        return currentSet.serviceType
    }

    var setSummaries: [Set.Summary] {
        return getSetSummaries()
    }

    var didEnd: Bool {
        return sets.count >= options.matchType.setsToWin
    }

    init(with options: Options, localPlayer: Player, visitorPlayer: Player) {
        self.options = options
        self.localPlayer = localPlayer
        self.visitorPlayer = visitorPlayer
        self.sets = []
        startNewSet(with: options.serviceType)
    }

    func winPoint() {
        currentSet.winPoint()
    }

    func losePoint() {
        currentSet.losePoint()
    }

    private func startNewSet(with serviceType: ServiceType) {
        if !didEnd {
            currentSet = getNewSet(with: options.serviceType)
            currentSet.delegate = self
        }
    }

    private func getNewSet(with serviceType: ServiceType) -> Set {
        return Set(serviceType: serviceType,
                      totalGames: options.gamesPerSet,
                      totalPointsForTieBreak: options.pointsPerTieBreak,
                      advantageEnabled: options.advantage)
    }

    private func addCurrentSetToHistory() {
        currentSet.delegate = nil
        sets.append(currentSet)
    }

    private func getSetSummaries() -> [Set.Summary] {
        var summaries: [Set.Summary] = []
        var allSets: [Set] = sets
        if !didEnd {
            allSets.append(currentSet)
        }
        for set in allSets {
            let summary = Set.Summary(localGames: set.localGames,
                                      visitorGames: set.visitorGames,
                                      isTieBreak: set.isTieBreak,
                                      localTieBreakPoints: set.localTieBreakPoints,
                                      visitorTieBreakPoints: set.visitorTieBreakPoints)
            summaries.append(summary)
        }
        return summaries
    }

    private func checkIfMachtEnded() {
        if didEnd {
            delegate?.matchDidEnd()
        }
    }

    // MARK: - SetDelegate

    func setDidEnd() {
        addCurrentSetToHistory()
        startNewSet(with: currentSet.serviceType.next)
        checkIfMachtEnded()
    }
}
