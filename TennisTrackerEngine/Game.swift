//
//  Game.swift
//  TennisTrackerEngine
//
//  Created by David Rivera on 2/02/23.
//

import Foundation

struct Game {

    let advantageEnabled: Bool

    private(set) var server: Point
    private(set) var receiver: Point

    init(advantageEnabled: Bool) {
        self.advantageEnabled = advantageEnabled
        self.server = .love
        self.receiver = .love
    }

    var isDeuce: Bool {
        return server == .forty && receiver == .forty
    }

    var didEnd: Bool {
        return didServerWin() || didReceiverWin()
    }

    mutating func addPointToServer() {
        if receiver == .advantage {
            receiver = .forty
        } else {
            server = server.nextPoint(isAdvantage: advantageEnabled)
        }
    }

    mutating func addPointToReceiver() {
        if server == .advantage {
            server = .forty
        } else {
            receiver = receiver.nextPoint(isAdvantage: advantageEnabled)
        }
    }

    private func didServerWin() -> Bool {
        return server == .sixty
    }

    private func didReceiverWin() -> Bool {
        return receiver == .sixty
    }
}
