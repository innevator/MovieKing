//
//  ContentView.swift
//  MovieKing
//
//  Created by 洪宗鴻 on 2023/12/8.
//

import SwiftUI
import MovieFeature

struct ContentView: View {
    @State var movies: [Movie] = []
    
    var body: some View {
        VStack {
            List {
                ForEach(movies) { movie in
                    HStack {
                        if let imageURL = movie.imageURL, let url = URL(string: imageURL) {
                            CacheAsyncImage(url: url) { phase in
                                if case let .success(image) = phase {
                                    image.resizable().frame(width: 100, height: 100)
                                }
                                else {
                                    ProgressView()
                                }
                            }
                            .frame(width: 100, height: 100)
                        }
                        Text(movie.name)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                let service = ShowTimeMovieService()
                service.loadMovies { result in
                    switch result {
                    case .success(let movies):
                        self.movies = movies
                    case .failure(_):
                        break
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct CacheAsyncImage<Content>: View where Content: View{
    
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ){
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View{
        if let cached = ImageCache[url]{
            content(.success(cached))
        }else{
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success (let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}

fileprivate class ImageCache {
    static private var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}
