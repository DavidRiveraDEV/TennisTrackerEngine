
import Foundation

extension Game {

    enum Point: CaseIterable {

        typealias RawValue = UInt8

        case love
        case fifteen
        case thirty
        case forty
        case advantage
        case sixty

        func nextPoint(isAdvantage: Bool) -> Point {
            switch self {
            case .love: return .fifteen
            case .fifteen: return .thirty
            case .thirty: return .forty
            case .forty: return isAdvantage ? .advantage : .sixty
            case .advantage: return .sixty
            case .sixty: fatalError("sixty is the highest point")
            }
        }
    }
}
