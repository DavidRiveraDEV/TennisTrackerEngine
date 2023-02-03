//
//  MatchOptions.swift
//  TennisTrackerEngine
//
//  Created by David Rivera on 2/02/23.
//

import Foundation

extension Match {

    struct Options {

        static let minDifferencePerSet: UInt8 = 2

        let gamesPerSet: UInt8
        let advantage: Bool

        init(gamesPerSet: UInt8, advantage: Bool) {
            precondition(gamesPerSet >= Match.Options.minDifferencePerSet, "Games cannot be lower than \(Match.Options.minDifferencePerSet)")
            self.gamesPerSet = gamesPerSet
            self.advantage = advantage
        }
    }
}
