//
//  MovieDetailViewModel.swift
//  Cricbuzz Movie App
//
//  Created by Mandara S on 26/10/25.
//

import SwiftUI
import Foundation

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var movie: MovieDetailResponse?
    @Published var trailerKey: String?

    private let service: MovieServiceProtocol

    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }

    func fetchMovieDetail(id: Int) async {
        do {
            let detail = try await service.fetchMovieDetails(movieId: id)
            self.movie = detail
            self.trailerKey = detail.videos?.results.first(where: { $0.site == "YouTube" && $0.type == "Trailer" })?.key
        } catch {
            print("Error fetching movie detail:", error)
        }
    }
}




