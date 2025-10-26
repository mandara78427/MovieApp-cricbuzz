//
//  MovieModel.swift
//  Cricbuzz Movie App
//
//  Created by Mandara S on 26/10/25.
//

import Foundation

struct MovieResponse: Codable {
    let results: [MovieModel]
}

struct MovieModel: Identifiable, Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double
    let runtime: Int? // optional, not provided in popular API this will not show on UI

    enum CodingKeys: String, CodingKey {
        case id, title, runtime
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
