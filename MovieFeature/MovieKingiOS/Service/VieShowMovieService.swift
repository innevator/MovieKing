//
//  VieShowMovieService.swift
//  MovieKing
//
//  Created by 洪宗鴻 on 2023/12/14.
//

import Foundation
import MovieFeature

class VieShowMovieService: MovieService {
    func loadMovies(completion: @escaping (Result<[MovieFeature.Movie], Error>) -> Void) {
        let service = ViewShowService()
        service.getCinemaList { result in
            switch result {
            case .success(let cinemas):
                break
            case .failure(_):
                break
            }
        }
    }
}

private class ViewShowService {
    func getCinemaList(completion: @escaping (Result<[VieShowCinema], Error>) -> ()) {
        guard let url = URL(string: "https://www.vscinemas.com.tw/VsWeb/api/GetLstDicCinema") else { return }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data,
                  let objects = try? JSONDecoder().decode([VieShowObject].self, from: data)
            else {
                /// TODO: completion failed callback
                return
            }
            let cinemas = objects.map { VieShowCinema(object: $0) }
            self.getMovieList(cinemas: cinemas) { result in
                switch result {
                case .success(let cinemas):
                    self.getDateList(cinemas: cinemas) { result in
                        switch result {
                        case .success(let cinemas):
                            self.getTimeList(cinemas: cinemas) { result in
                                switch result {
                                case .success(let cinemas):
                                    completion(.success(cinemas))
                                case .failure(_):
                                    break
                                }
                            }
                        case .failure(_):
                            break
                        }
                    }
                case .failure(_):
                    break
                }
            }
        }.resume()
    }
    
//    func getAreaList(completion: (Result<[VieShowCinema], Error>) -> ()) {
//        guard let url = URL(string: "https://www.vscinemas.com.tw/VsWeb/api/GetLstDicArea") else { return }
//        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
//            guard let data = data,
//                  let dics = try? JSONSerialization.jsonObject(with: data) as? [Dictionary<String, String>]
//            else {
//                /// TODO: completion failed callback
//                return
//            }
//            
//            for dic in dics {
//                print(dic)
//            }
//            
//        }.resume()
//    }
    
    private func getMovieList(cinemas: [VieShowCinema], completion: @escaping (Result<[VieShowCinema], Error>) -> ()) {
        let group = DispatchGroup()
        for cinema in cinemas {
            guard let url = URL(string: "https://www.vscinemas.com.tw/vsweb/api/GetLstDicMovie?cinema=\(cinema.object.strValue)") else { continue }
            group.enter()
            URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
                guard let data = data,
                      let objects = try? JSONDecoder().decode([VieShowObject].self, from: data)
                else {
                    /// TODO: completion failed callback
                    group.leave()
                    return
                }
                let movies = objects.map({ VieShowMovie(object: $0) })
                cinema.movies = movies
                group.leave()
            }.resume()
            
        }
        
        group.notify(queue: .global()) {
            completion(.success(cinemas))
        }
    }
    
    private func getDateList(cinemas: [VieShowCinema], completion: @escaping (Result<[VieShowCinema], Error>) -> ()) {
        let group = DispatchGroup()
        for cinema in cinemas {
            for movie in cinema.movies {
                guard let url = URL(string: "https://www.vscinemas.com.tw/vsweb/api/GetLstDicDate?cinema=\(cinema.object.strValue)&movie=\(movie.object.strValue)") else { continue }
                group.enter()
                URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
                    guard let data = data,
                          let objects = try? JSONDecoder().decode([VieShowObject].self, from: data)
                    else {
                        /// TODO: completion failed callback
                        group.leave()
                        return
                    }
                    let dates = objects.map({ VieShowDate(object: $0) })
                    movie.dates = dates
                    group.leave()
                }.resume()
            }
        }
        
        group.notify(queue: .global()) {
            completion(.success(cinemas))
        }
    }
    
    private func getTimeList(cinemas: [VieShowCinema], completion: @escaping (Result<[VieShowCinema], Error>) -> ()) {
        let group = DispatchGroup()
        for cinema in cinemas {
            for movie in cinema.movies {
                for date in movie.dates {
                    guard let url = URL(string: "https://www.vscinemas.com.tw/vsweb/api/GetLstDicSession?cinema=\(cinema.object.strValue)&movie=\(movie.object.strValue)&date=\(date.object.strValue)") else { continue }
                    group.enter()
                    URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
                        guard let data = data,
                              let objects = try? JSONDecoder().decode([VieShowObject].self, from: data)
                        else {
                            /// TODO: completion failed callback
                            group.leave()
                            return
                        }
                        date.times = objects
                        group.leave()
                    }.resume()
                }
            }
        }
        
        group.notify(queue: .global()) {
            completion(.success(cinemas))
        }
    }
}

private class VieShowCinema {
    var movies: [VieShowMovie] = []
    let object: VieShowObject
    
    init(object: VieShowObject) {
        self.object = object
    }
}

private class VieShowMovie {
    var dates: [VieShowDate] = []
    let object: VieShowObject
    
    init(object: VieShowObject) {
        self.object = object
    }
}

private class VieShowDate {
    var times: [VieShowObject] = []
    let object: VieShowObject
    
    init(object: VieShowObject) {
        self.object = object
    }
}


private struct VieShowObject: Codable {
    let strText: String
    let strValue: String
}
