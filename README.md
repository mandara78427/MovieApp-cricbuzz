# MovieApp (SwiftUI MVVM) - TMDb

A SwiftUI iOS app that displays popular movies from [The Movie Database (TMDb)](https://www.themoviedb.org/), supports search, shows detailed information, plays trailers, and allows users to favorite movies.

Built using **MVVM architecture**, `async/await` networking, and `UserDefaults` for favorites persistence.

---

## Features

- **Home / Movies List**
  - Display popular movies: poster, title, rating
  - Infinite scroll (paging)
  - Search bar 
  - Tap a movie to view details  

- **Movie Detail**
  - Trailer playback (YouTube embedded)
  - Movie title, overview, genres, runtime, rating
  - Favorite/unfavorite button  

- **Favorites**
  - View all favorited movies
  - Tap to open detail view
  - Favorites persist across app launches  

- **Architecture**
  - MVVM: Models, ViewModels, Views
  - Networking via `TMDBService` with `async/await`
  - Favorites via `FavoritesManager` backed by `UserDefaults`
  - Declarative SwiftUI views

---

## Requirements

- Xcode 15+
- iOS 17+
- Swift 5.9+
- Internet connection (TMDb API)

---

## Setup

1. **TMDb API Key**  
      - Sign up at [TMDb](https://www.themoviedb.org/) and get an API key.
      - Add your API key in the project:
      - Open `API.swift` and replace the placeholder:
     ```swift
     static let apiKey = "<YOUR_TMDB_API_KEY>"
     ```

2. **Build & Run**
   - Open project in Xcode
   - Select target device / simulator
   - Press `Cmd + R` to build and run

3. **Dependencies**
   - Uses only native SwiftUI / Foundation APIs; no external packages.

---
