//
//  HomeViewModel.swift
//  MedBook
//
//  Created by deq on 15/02/24.
//

import Foundation
import UIKit
import CoreData

class HomeViewModel: BaseViewModel {
    var limit: Int = 10
    var searchTitle: String = ""
    var offSet: Int = 0
    var searchedBooks:[BookDetails] = []
    var isBookFetchingCompleted: Bindable<Bool> = Bindable(false)
    var showLoader: Bindable<Bool> = Bindable(false)
    var selectedConditon: SortingCondition = .title
    
    override init() {
        super.init()
        
    }
}

// MARK: API
extension HomeViewModel {
    
    func searchBooks(title: String, offset: Int =  0) {
        showLoader.value = true
        if title != searchTitle {
            searchedBooks.removeAll()
        }
        HomeRepository.searchBooks.searchBooksAPI( title: title, offset: offset, limit: limit,{[weak self] response in
            if let books = response?.docs {
                
                DispatchQueue.main.async { [weak self] in
                    self?.appendDataToArray(data: books)
                    self?.offSet = offset
                    self?.isBookFetchingCompleted.value = true
                }
                self?.showLoader.value = false
            }
            
        }, { error in
            print(error ?? "")
            self.showLoader.value = false
        })
    }
    
    func appendDataToArray(data: [BookDetails]) {
        var books = data
        if selectedConditon == .title {
            books.sort { $0.title ?? "" < $1.title ?? "" }
            searchedBooks.append(contentsOf: books)
        } else if selectedConditon == .average {
            books.sort { $0.ratingsAverage ?? 0.0 > $1.ratingsAverage ?? 0.0 }
            searchedBooks.append(contentsOf: books)
        } else {
            books.sort { $0.ratingsCount ?? 0 > $1.ratingsCount ?? 0 }
            searchedBooks.append(contentsOf: books)
        }
    }
    
}

// MARK: - Sorting Conditions
enum SortingCondition {
    case title
    case average
    case hits
}
