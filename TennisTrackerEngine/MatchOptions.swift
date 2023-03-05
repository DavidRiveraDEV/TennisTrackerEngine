import Foundation

extension Match {

    public struct Options {

        public let matchType: Match.`Type`
        public let gamesPerSet: UInt8
        public let pointsPerTieBreak: UInt8
        public let advantage: Bool
        public let serviceType: ServiceType

        public init(matchType: Match.`Type`,
                    gamesPerSet: UInt8,
                    pointsPerTieBreak: UInt8,
                    advantage: Bool,
                    serviceType: ServiceType) {

            self.matchType = matchType
            self.gamesPerSet = gamesPerSet
            self.pointsPerTieBreak = pointsPerTieBreak
            self.advantage = advantage
            self.serviceType = serviceType
        }
    }
}
