//
//  ShowTimeMovieService.swift
//  MovieKing
//
//  Created by 洪宗鴻 on 2023/12/10.
//

import Foundation
import MovieFeature

struct ShowTimeMovieService: MovieService {
    
    func loadMovies(completion: @escaping (Result<[MovieFeature.Movie], Error>) -> Void) {
        guard let url = URL(string: "https://capi.showtimes.com.tw/1/app/bootstrap")
        else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data,
                  let dic = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String, Any>,
                  let payload = dic["payload"] as? Dictionary<String, Any>,
                  let programs = payload["programs"] as? [Dictionary<String, Any>]
            else {
                /// TODO: completion failed callback
                return
            }
            
            var movies: [Movie] = []
            for program in programs {
                guard let ddata = try? JSONSerialization.data(withJSONObject: program),
                      let showMovie = try? JSONDecoder().decode(ShowMovie.self, from: ddata)
                else {
                    /// TODO: failed handler
                    continue
                }
                
                let movie = Movie(name: showMovie.name, 
                                  imageURL: showMovie.coverImagePortrait?.thumb,
                                  source: .ShowTime)
                movies.append(movie)
            }
            
            DispatchQueue.main.async {
                completion(.success(movies))                
            }
            
        }.resume()
    }
}

private struct ShowMovie: Codable {
    
    struct ShowMovieCoverImage: Codable {
        
        struct ShowMovieImageMeta: Codable {
            let height: Int
            let width: Int
        }
        
        let data: String
        let format: String
        let id: Int
        let meta: ShowMovieImageMeta
        let thumb: String
        let url: String
    }
    
    struct ShowMovieMeta: Codable {
        
        struct ShowMoviePromotionTag: Codable {
            let from: String
            let text: String
            let to: String
        }

        struct ShowMoviePublisher: Codable {
            let name: String
            let tixi: String
        }

        struct ShowMovieSources: Codable {
            let tixi: String
            let yahoo: Int?
        }
        
        let authors: [String]
        let availableCorporationIds: [Int]?
        let directors: [String]
        let isLockedFromBenefit: Bool
        let lockOffDay: Int
        let promotionTag: ShowMoviePromotionTag?
        let publisher: ShowMoviePublisher?
        let sources: ShowMovieSources?
    }
    
    struct ShowMovieOwner: Codable {
        let id: Int
        let name: String
    }

    struct ShowMoviePreviewVideo: Codable {
        let data: String
        let format: String
        let id: Int
        let thumb: String
        let url: String
    }
    
    let availableAt: String
    let coverImageLandscape: String?
    let coverImagePortrait: ShowMovieCoverImage?
    let description: String
    let duration: Int
    let genres: [String]
    let id: Int
    let meta: ShowMovieMeta
    let name: String
    let nameAlternative: String
    let owner: ShowMovieOwner
    let previewVideo: ShowMoviePreviewVideo?
    let rating: String?
    let recommendationOrder: String?
    let sortOrder: Int
    let status: String
    let type: String
}
