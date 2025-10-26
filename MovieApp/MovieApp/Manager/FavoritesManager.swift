//
//  FavoritesManager.swift
//  Cricbuzz Movie App
//
//  Created by Mandara S on 26/10/25.
//

import Foundation
import Combine

@MainActor
final class FavoritesManager: ObservableObject {
    @Published private(set) var favoriteMovieIDs: Set<Int> = []
    private let defaultsKey = "favoriteMovieIDs"

    init() {
        loadFavorites()
    }

    func toggleFavorite(movieId: Int) {
        if favoriteMovieIDs.contains(movieId) {
            favoriteMovieIDs.remove(movieId)
        } else {
            favoriteMovieIDs.insert(movieId)
        }
        saveFavorites()
    }

    func isFavorite(movieId: Int) -> Bool {
        favoriteMovieIDs.contains(movieId)
    }

    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteMovieIDs), forKey: defaultsKey)
    }

    private func loadFavorites() {
        if let saved = UserDefaults.standard.array(forKey: defaultsKey) as? [Int] {
            favoriteMovieIDs = Set(saved)
        }
    }
}
