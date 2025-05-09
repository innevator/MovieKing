//
//  ContentView.swift
//  MovieKingiOS
//
//  Created by 洪宗鴻 on 2025/5/9.
//

import SwiftUI
import MovieFeature

struct ContentView: View {
    @State var movies: [Movie] = []
    let service: MovieService
    
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
                service.loadMovies { result in
                    switch result {
                    case .success(let movies):
                        self.movies += movies
                    case .failure(_):
                        break
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(service: DummyMovieService())
}

private struct DummyMovieService: MovieService {
    func loadMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        completion(.success([]))
    }
}

