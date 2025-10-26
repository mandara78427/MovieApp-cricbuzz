//
//  VideoPlayerView.swift
//  Cricbuzz Movie App
//
//  Created by Mandara S on 26/10/25.
//

import SwiftUI
import WebKit

struct YouTubePlayerView: UIViewRepresentable {
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoID)") else { return }
        webView.scrollView.isScrollEnabled = false
        webView.load(URLRequest(url: url))
    }
}

