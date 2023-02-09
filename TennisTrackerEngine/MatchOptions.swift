import Foundation

extension Match {

    struct Options {

        let matchType: Match.`Type`
        let gamesPerSet: UInt8
        let pointsPerTieBreak: UInt8
        let advantage: Bool
        let serviceType: ServiceType
    }
}
