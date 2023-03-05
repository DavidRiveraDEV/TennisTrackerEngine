import Foundation

public protocol MatchDelegate: AnyObject {
    func matchDidEnd()
}

public final class Match: SetDelegate {

    public let options: Options
    public let localPlayer: Player
    public let visitorPlayer: Player

    private var sets: [Set]
    private var currentSet: Set!

    public weak var delegate: MatchDelegate?

    public var serviceType: ServiceType {
        return currentSet.serviceType
    }

    public var setSummaries: [SetSummary] {
        return getSetSummaries()
    }

    public var didEnd: Bool {
        return sets.count >= options.matchType.setsToWin
    }

    public init(with options: Options, localPlayer: Player, visitorPlayer: Player) {
        self.options = options
        self.localPlayer = localPlayer
        self.visitorPlayer = visitorPlayer
        self.sets = []
        startNewSet(with: options.serviceType)
    }

    public func winPoint() {
        currentSet.winPoint()
    }

    public func losePoint() {
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

    private func getSetSummaries() -> [SetSummary] {
        var summaries: [SetSummary] = []
        var allSets: [Set] = sets
        if !didEnd {
            allSets.append(currentSet)
        }
        for set in allSets {
            let summary = SetSummary(localGames: set.localGames,
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
