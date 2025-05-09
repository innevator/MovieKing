//
//  MovieKingiOSApp.swift
//  MovieKingiOS
//
//  Created by 洪宗鴻 on 2025/5/9.
//

import SwiftUI

@main
struct MovieKingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(service: ShowTimeMovieService())
        }
    }
}
