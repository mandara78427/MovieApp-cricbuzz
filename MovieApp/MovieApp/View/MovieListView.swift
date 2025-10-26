//
//  MovieListView.swift
//  Cricbuzz Movie App
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @StateObject private var favorites = FavoritesManager()
    @State private var searchText = ""

    private let spacing: CGFloat = 16.0

    var body: some View {
        NavigationStack {
            Group {
                if let error = viewModel.errorMessage {
                    VStack(spacing: spacing) {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Retry") {
                            Task { await viewModel.fetchMovies() }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Fetch Movie list
                    List(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetailView(movieId: movie.id,
                                                                    favorites: favorites)) {
                            MovieRow(movie: movie, favorites: favorites)
                        }
                    }
                    .listStyle(.plain)
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Popular Movies")
            .searchable(text: $searchText, prompt: "Search movies")
            .onChange(of: searchText) { query in
                Task { await viewModel.searchMovies(query: query) }
            }
            .task { await viewModel.fetchMovies() }
        }
    }
}
