import Foundation

enum ServiceType {
    case local
    case visitor

    var next: ServiceType {
        switch self {
        case .local: return .visitor
        case .visitor: return .local
        }
    }
}
