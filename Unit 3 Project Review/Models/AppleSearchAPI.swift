//
//  AppleSearchAPI.swift
//  Unit 3 Project Review
//
//  Created by Bienbenido Angeles on 12/17/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import Foundation

struct AppleSearchAPI:Codable {
    let resultCount: Int
    let results : [Podcast]
}

struct Podcast: Codable {
    let collectionId: Int?
    let trackId: Int
    let artistName: String?
    let collectionName: String
    let artworkUrl30: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let releaseDate: String?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let artworkUrl600: String
    let genres: [String]?
    let favoritedBy: String?
}
