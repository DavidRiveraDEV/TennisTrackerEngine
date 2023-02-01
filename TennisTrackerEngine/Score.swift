
import Foundation

struct Score {

    enum Point: UInt8, CaseIterable {

        typealias RawValue = UInt8

        case love = 0
        case fifteen = 15
        case thirty = 30
        case forty = 40
        case advantage

        func nextPoint(isAdvantage: Bool) -> Point {
            switch self {
            case .love: return .fifteen
            case .fifteen: return .thirty
            case .thirty: return .forty
            case .forty: return isAdvantage ? .advantage : .love
            case .advantage: return .love
            }
        }
    }

    struct Options {
        let gamesPerSet: UInt8
        let minDifferencePerSet: UInt8
        let advantage: Bool
    }

    let options: Options
    private(set) var serviceForPlayer1: Bool = true
    private(set) var pointsForPlayer1: Point = .love
    private(set) var pointsForPlayer2: Point = .love
    private(set) var sets: [[UInt8]] = [[0, 0]]

    var isDeuce: Bool {
        return pointsForPlayer1 == .forty && pointsForPlayer2 == .forty
    }

    init(with options: Options) {
        self.options = options
    }
    
    mutating func winPoint() {
        if serviceForPlayer1 {
            pointsForPlayer1 = pointsForPlayer1.nextPoint(isAdvantage: options.advantage)
        } else {
            pointsForPlayer2 = pointsForPlayer2.nextPoint(isAdvantage: options.advantage)
        }
        addGameIfNeeded(forPlayer1: serviceForPlayer1)
    }

    mutating func losePoint() {
        if serviceForPlayer1 {
            pointsForPlayer2 = pointsForPlayer2.nextPoint(isAdvantage: options.advantage)
        } else {
            pointsForPlayer1 = pointsForPlayer1.nextPoint(isAdvantage: options.advantage)
        }
        addGameIfNeeded(forPlayer1: !serviceForPlayer1)
    }

    private mutating func addGameIfNeeded(forPlayer1: Bool) {
        if forPlayer1 && pointsForPlayer1 == .love {
            addGame(forPlayer1: true)
        } else if !forPlayer1 && pointsForPlayer2 == .love {
            addGame(forPlayer1: false)
        }
    }

    private mutating func addGame(forPlayer1: Bool) {
        let games = sets[sets.count - 1]
        let gamesForPlayer1: UInt8 = games[0] + (forPlayer1 ? 1 : 0)
        let gamesForPlayer2: UInt8 = games[1] + (forPlayer1 ? 0 : 1)
        sets[sets.count - 1] = [gamesForPlayer1, gamesForPlayer2]
        addSetIfNeeded(gamesForPlayer1, gamesForPlayer2)
        serviceForPlayer1 = !serviceForPlayer1
    }

    private mutating func addSetIfNeeded(_ gamesForPlayer1: UInt8, _ gamesForPlayer2: UInt8) {
        if shouldAddSet(gamesForPlayer1, gamesForPlayer2) {
            sets.append([0, 0])
        }
    }

    private func shouldAddSet(_ gamesForPlayer1: UInt8, _ gamesForPlayer2: UInt8) -> Bool {
        let pointsToLose: Int8 = Int8(options.gamesPerSet) - Int8(options.minDifferencePerSet)
        guard pointsToLose >= 0 else {
            fatalError("gamesPerSet - minDifferencePerSet must be higher than 0. Currently: \(pointsToLose)")
        }
        return didPlayer1WinTheSet(gamesForPlayer1, gamesForPlayer2) || didPlayer2WinTheSet(gamesForPlayer1, gamesForPlayer2)
    }

    private func didPlayer1WinTheSet(_ gamesForPlayer1: UInt8, _ gamesForPlayer2: UInt8) -> Bool {
        return gamesForPlayer1 == options.gamesPerSet && gamesForPlayer2 <= options.gamesPerSet - options.minDifferencePerSet
    }

    private func didPlayer2WinTheSet(_ gamesForPlayer1: UInt8, _ gamesForPlayer2: UInt8) -> Bool {
        return gamesForPlayer2 == options.gamesPerSet && gamesForPlayer1 <= options.gamesPerSet - options.minDifferencePerSet
    }
}
