
import Foundation

struct Score {

    enum Point: UInt8, CaseIterable {

        typealias RawValue = UInt8

        case love = 0
        case fifteen = 15
        case thirty = 30
        case forty = 40

        var nextPoint: Point {
            switch self {
            case .love: return .fifteen
            case .fifteen: return .thirty
            case .thirty: return .forty
            case .forty: return .love
            }
        }
    }

    struct Options {
        let gamesPerSet: UInt8
        let minDifferencePerSet: UInt8
    }

    let options: Options
    private(set) var serviceForPlayer1: Bool = true
    private(set) var pointsForPlayer1: Point = .love
    private(set) var pointsForPlayer2: Point = .love
    private(set) var sets: [[UInt8]] = [[0, 0]]

    init(with options: Options) {
        self.options = options
    }
    
    mutating func winPoint() {
        let nextPoint: Point
        if serviceForPlayer1 {
            nextPoint = pointsForPlayer1.nextPoint
            pointsForPlayer1 = nextPoint
        } else {
            nextPoint = pointsForPlayer2.nextPoint
            pointsForPlayer1 = nextPoint
        }
        if nextPoint == .love {
            addGame(forPlayer1: true)
        }
    }

    mutating func losePoint() {
        let nextPoint: Point
        if serviceForPlayer1 {
            nextPoint = pointsForPlayer2.nextPoint
            pointsForPlayer2 = nextPoint
        } else {
            nextPoint = pointsForPlayer1.nextPoint
            pointsForPlayer1 = nextPoint
        }
        if nextPoint == .love {
            addGame(forPlayer1: false)
        }
    }

    private mutating func addGame(forPlayer1: Bool) {
        guard let games = sets.last else {
            sets = [[0, 0]]
            return
        }
        let gamesForPlayer1: UInt8 = games[0] + (forPlayer1 ? 1 : 0)
        let gamesForPlayer2: UInt8 = games[1] + (forPlayer1 ? 0 : 1)
        sets[sets.count - 1] = [gamesForPlayer1, gamesForPlayer2]
        if shouldAddSet(gamesForPlayer1, gamesForPlayer2) {
            sets.append([0, 0])
        }
    }

    private func shouldAddSet(_ gamesForPlayer1: UInt8, _ gamesForPlayer2: UInt8) -> Bool {
        let pointsToLose: Int8 = Int8(options.gamesPerSet) - Int8(options.minDifferencePerSet)
        guard pointsToLose >= 0 else {
            fatalError("gamesPerSet - minDifferencePerSet must be higher than 0. Currently: \(pointsToLose)")
        }
        return didPlayer1Win(gamesForPlayer1, gamesForPlayer2) || didPlayer2Win(gamesForPlayer1, gamesForPlayer2)
    }

    private func didPlayer1Win(_ gamesForPlayer1: UInt8, _ gamesForPlayer2: UInt8) -> Bool {
        return gamesForPlayer1 == options.gamesPerSet && gamesForPlayer2 <= options.gamesPerSet - options.minDifferencePerSet
    }

    private func didPlayer2Win(_ gamesForPlayer1: UInt8, _ gamesForPlayer2: UInt8) -> Bool {
        return gamesForPlayer2 == options.gamesPerSet && gamesForPlayer1 <= options.gamesPerSet - options.minDifferencePerSet
    }
}
