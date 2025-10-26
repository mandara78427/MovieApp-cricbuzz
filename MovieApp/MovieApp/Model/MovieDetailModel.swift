//
//  MovieDetailModel.swift
//  Cricbuzz Movie App
//
//  Created by Mandara S on 26/10/25.
//

import Foundation

struct MovieDetailResponse: Codable {
    let id: Int
    let title: String
    let overview: String
    let runtime: Int?
    let voteAverage: Double
    let genres: [Genre]
    let videos: VideoResponse?
    let credits: CreditsResponse?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres
        case voteAverage = "vote_average"
        case videos, credits
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable {
    let key: String
    let name: String
    let site: String
    let type: String
}

struct CreditsResponse: Codable {
    let cast: [CastMember]
}

struct CastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
}

