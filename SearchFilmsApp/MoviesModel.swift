//
//  MoviesModel.swift
//  SearchFilmsApp
//
//  Created by Иван Бондаренко on 18.09.2023.
//

import Foundation

// MARK: - Models

struct MovieResults: Decodable {
    var keyword: String
    var pagesCount: Int
    var searchFilmsCountResult: Int
    var films: [Movies]
}

struct Movies: Decodable {
    var filmId: Int
    var nameRu: String?
    var nameEn: String?
    var type: String
    var year: String
    var description: String?
    var filmLength: String?
    var countries: [Countr]
    var genres: [Genr]
    var rating: String
    var ratingVoteCount: Int
    var posterUrl: String
    var posterUrlPreview: String
}

struct Countr: Decodable {
    var country: String
}

struct Genr: Decodable {
    var genre: String
}
