
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

    private(set) var serviceForPlayer1: Bool = true
    private(set) var pointsForPlayer1: Point = .love
    private(set) var pointsForPlayer2: Point = .love
    private(set) var sets: [[UInt8]] = [[0, 0]]
    
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
    }
}
