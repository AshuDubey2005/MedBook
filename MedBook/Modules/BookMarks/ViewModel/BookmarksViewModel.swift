//
//  BookmarksViewModel.swift
//  MedBook
//
//  Created by deq on 16/02/24.
//

import Foundation

class BookmarksViewModel: BaseViewModel {
    var isBookFetchingCompleted: Bindable<Bool> = Bindable(false)
    var bookMarkedBooks:[BookDetails] = [] {
        didSet {
            isBookFetchingCompleted.value = true
        }
    }
    
    override init() {
        super.init()
        bookMarkedBooks = BooksCoreDataOperations.fetchBooksForEmailFromDatabase(email: UserDefaults.userEmail) ?? []
    }
}
