//
//  MovieService.swift
//  Cricbuzz Movie App
//
//  Created by Mandara S on 26/10/25.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchPopularMovies() async throws -> [MovieModel]
    func searchMovies(query: String) async throws -> [MovieModel]
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetailResponse
}

final class MovieService: MovieServiceProtocol {
    func fetchPopularMovies() async throws -> [MovieModel] {
        guard let url = URL(string: "\(API.baseURL)/movie/popular?api_key=\(API.apiKey)") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decoded.results
    }

    func searchMovies(query: String) async throws -> [MovieModel] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = URL(string: "\(API.baseURL)/search/movie?api_key=\(API.apiKey)&query=\(encodedQuery)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MovieResponse.self, from: data)
        return response.results
    }

    func fetchMovieDetails(movieId: Int) async throws -> MovieDetailResponse {
        let url = URL(string: "\(API.baseURL)/movie/\(movieId)?api_key=\(API.apiKey)&append_to_response=videos,credits")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(MovieDetailResponse.self, from: data)
    }
}
