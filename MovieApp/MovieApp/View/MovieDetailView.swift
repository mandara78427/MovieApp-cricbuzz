//
//  MovieDetailView.swift
//  Cricbuzz Movie App
//
//  Created by Mandara S on 26/10/25.
//

import SwiftUI
import WebKit

struct MovieDetailView: View {
    let movieId: Int
    @StateObject private var viewModel = MovieDetailViewModel()
    @ObservedObject var favorites: FavoritesManager
    @State private var isTrailerLoading = true

    private let spacing: CGFloat = 16.0
    private let videoFrameHeight: CGFloat = 220.0
    private let videoFrameCornerRadius: CGFloat = 12.0
    private let videoBottomPadding: CGFloat = 8.0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: spacing) {
                trailerView
                if let movie = viewModel.movie {
                    headerView(for: movie)
                    infoView(for: movie)
                    overviewView(for: movie)
                    if let cast = movie.credits?.cast.prefix(5) {
                        castView(cast: Array(cast))
                    }
                }
            }
        }
        .navigationTitle(viewModel.movie?.title ?? "Movie Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchMovieDetail(id: movieId)
        }
    }

    // MARK: - Views

    private var trailerView: some View {
        Group {
            if let trailerKey = viewModel.trailerKey {
                ZStack {
                    YouTubePlayerView(videoID: trailerKey)
                        .frame(height: videoFrameHeight)
                        .cornerRadius(videoFrameCornerRadius)
                        .padding(.bottom, videoBottomPadding)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isTrailerLoading = false
                            }
                        }
                    if isTrailerLoading {
                        ZStack {
                            Color.black.opacity(0.4)
                                .cornerRadius(videoFrameCornerRadius)
                            ProgressView("Loading Trailer...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .foregroundColor(.white)
                        }
                        .frame(height: videoFrameHeight)
                        .padding(.bottom, videoBottomPadding)
                    }
                }
            } else {
                Text("Trailer not available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, minHeight: videoFrameHeight)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(videoFrameCornerRadius)
                    .padding(.bottom, videoBottomPadding)
            }
        }
    }


    private func headerView(for movie: MovieDetailResponse) -> some View {
        HStack(alignment: .top) {
            Text(movie.title)
                .font(.title)
                .bold()
                .lineLimit(2)

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                ratingStars(for: movie.voteAverage) 
                Text(String(format: "%.1f/10", movie.voteAverage))
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
    }

    private func ratingStars(for rating: Double) -> some View {
        HStack(spacing: 2) {
            // scale 0-10 → 0-5 stars
            let stars = rating / 2
            ForEach(0..<5) { index in
                if Double(index) < stars {
                    if stars - Double(index) >= 1 {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    } else {
                        Image(systemName: "star.leadinghalf.filled")
                            .foregroundColor(.yellow)
                    }
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                }
            }
        }
    }

    private func infoView(for movie: MovieDetailResponse) -> some View {
        HStack {
            if let runtime = movie.runtime {
                Text("\(runtime) min")
            }
            Text(movie.genres.map { $0.name }.joined(separator: ", "))
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
        .padding(.horizontal)
    }

    @ViewBuilder
    private func overviewView(for movie: MovieDetailResponse) -> some View {
        let topPadding = 4.0
        Text(movie.overview)
            .font(.body)
            .padding(.horizontal)
            .padding(.top, topPadding)
    }

    @ViewBuilder
    private func castView(cast: [CastMember]) -> some View {
        let vstackSpacing = 4.0
        let hstackSpacing = 12.0
        let topPadding = 8.0
        let frameWidth = 120.0
        VStack(alignment: .leading, spacing: vstackSpacing) {
            Text("Cast")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, topPadding)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: hstackSpacing) {
                    ForEach(cast) { member in
                        VStack(alignment: .leading) {
                            Text(member.name)
                                .font(.subheadline)
                                .bold()
                            Text(member.character)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(width: frameWidth, alignment: .leading)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
