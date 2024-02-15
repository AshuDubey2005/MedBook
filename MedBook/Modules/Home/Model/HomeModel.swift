//
//  HomeModel.swift
//  MedBook
//
//  Created by deq on 15/02/24.
//

import Foundation


struct SearchedBooksResponse: Codable {
    var offset: Int?
    var docs: [BookDetails]?
}

// MARK: - Doc
struct BookDetails: Codable {
    
    let authorName: [String]?
    let coverI: Int?
    let title: String?
    let ratingsAverage: Double?
    let ratingsCount: Int?
    var isBookMarked: Bool = false
    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case coverI = "cover_i"
        case title
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
    }
}

