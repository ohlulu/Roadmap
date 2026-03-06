//
//  RoadmapFeatureViewModel.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class RoadmapFeatureViewModel {
    let feature: RoadmapFeature
    let configuration: RoadmapConfiguration
    let canVote: Bool

    var voteCount = 0

    init(feature: RoadmapFeature, configuration: RoadmapConfiguration) {
        self.feature = feature
        self.configuration = configuration

        self.canVote = configuration.allowVotes
    }

    func getCurrentVotes(firstLoad: Bool = false) async {
        if let votes = feature.votes, firstLoad {
            voteCount = votes
        } else {
            voteCount = await configuration.voter.fetch(for: feature)
        }
    }

    func vote() async {
        if let newCount = await configuration.voter.vote(for: feature) {
            voteCount = newCount
            feature.hasVoted = true
        }
    }

    func unvote() async {
        if let newCount = await configuration.voter.unvote(for: feature) {
            voteCount = newCount
            feature.hasVoted = false
        }
    }
}
