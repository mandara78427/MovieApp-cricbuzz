//
//  MoviesRowView.swift
//  Cricbuzz Movie App
//
//  Created by Mandara S on 26/10/25.
//

import Foundation
import SwiftUI

struct MovieRow: View {
    let movie: MovieModel
    @ObservedObject var favorites: FavoritesManager
    
    private let spacing: CGFloat = 16.0
    private let verticalPadding: CGFloat = 8.0
    
    private var posterURL: URL? {
        guard let path = movie.posterPath, !path.isEmpty else { return nil }
        return URL(string: "\(API.imageBaseURL)\(path)")
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            posterView
            VStack(alignment: .leading, spacing: 8) {
                headerView
                ratingView
                Spacer()
                HStack {
                    Spacer()
                    favoriteView
                }
            }
            .padding(.vertical, verticalPadding)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Poster View
    @ViewBuilder
    private var posterView: some View {
        let posterWidth = 100.0
        let posterHeight = 150.0
        let posterCornerRadius = 12.0
        
        if let url = posterURL {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
                    .overlay(ProgressView())
            }
            .frame(width: posterWidth, height: posterHeight)
            .cornerRadius(posterCornerRadius)
            .shadow(radius: 2)
        } else {
            Color.gray.opacity(0.3)
                .frame(width: posterWidth, height: posterHeight)
                .cornerRadius(posterCornerRadius)
                .overlay(
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.white.opacity(0.7))
                )
                .shadow(radius: 2)
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        Text(movie.title)
            .font(.headline)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
    }
    
    // MARK: - Rating View
    private var ratingView: some View {
        HStack(spacing: 4) {
            HStack(spacing: 2) {
                let stars = movie.voteAverage / 2
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
            
            Text(String(format: "%.1f/10", movie.voteAverage))
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.leading, 4)
        }
    }

    // MARK: - Favorite View
    private var favoriteView: some View {
        Button {
            favorites.toggleFavorite(movieId: movie.id)
        } label: {
            Image(systemName: favorites.isFavorite(movieId: movie.id) ? "heart.fill" : "heart")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(favorites.isFavorite(movieId: movie.id) ? .red : .gray.opacity(0.6))
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}
