//
//  MovieListViewModel.swift
//  Cricbuzz Movie App
//
//  Created by Mandara S on 26/10/25.
//

import Foundation

@MainActor
final class MovieListViewModel: ObservableObject {
    @Published var movies: [MovieModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let movieService: MovieServiceProtocol

    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }

    func fetchMovies() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetchedMovies = try await movieService.fetchPopularMovies()
            movies = fetchedMovies
        } catch {
            errorMessage = "Failed to load popular movies: \(error.localizedDescription)"
        }
        isLoading = false
    }

    func searchMovies(query: String) async {
          guard query.isEmpty == false else {
              await fetchMovies() // reload popular if query is empty
              return
          }
          isLoading = true
          errorMessage = nil
          do {
              let searchedMovies = try await movieService.searchMovies(query: query)
              movies = searchedMovies
          } catch {
              errorMessage = "Search failed: \(error.localizedDescription)"
          }
          isLoading = false
      }
}
