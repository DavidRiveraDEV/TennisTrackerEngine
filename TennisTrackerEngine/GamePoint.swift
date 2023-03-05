import Foundation

extension Game {

    enum Point {

        case love
        case fifteen
        case thirty
        case forty
        case advantage
        case sixty

        mutating func next(isAdvantage: Bool) {
            switch self {
            case .love: self = .fifteen
            case .fifteen: self = .thirty
            case .thirty: self = .forty
            case .forty: self = isAdvantage ? .advantage : .sixty
            case .advantage, .sixty: self = .sixty
            }
        }
    }
}
