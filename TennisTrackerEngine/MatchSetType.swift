
import Foundation

extension Match {

    enum `Type`: UInt8 {
        case one = 1
        case three = 3
        case five = 5

        var setsToWin: UInt8 {
            switch self {
            case .one: return 1
            case .three: return 2
            case .five: return 3
            }
        }
    }
}
