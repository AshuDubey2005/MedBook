//
//  BooksCoreDataOperations.swift
//  MedBook
//
//  Created by deq on 15/02/24.
//

import Foundation
import UIKit
import CoreData


class BooksCoreDataOperations {

    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context: NSManagedObjectContext = {
        return appDelegate.persistentContainer.viewContext
    }()

    public static func saveBookToDatabase(bookData: BookDetails) {
        let entity = NSEntityDescription.entity(forEntityName: "SavedBooks", in: context)!
        let personManagedObject = NSManagedObject(entity: entity, insertInto: context) as! SavedBooks
        personManagedObject.authorName = bookData.authorName?.first ?? ""
        personManagedObject.ratingsCount = Int64(bookData.ratingsCount ?? 0)
        personManagedObject.ratingsAverage = bookData.ratingsAverage ?? 0.0
        personManagedObject.isBookMarked = bookData.isBookMarked
        personManagedObject.title = bookData.title
        personManagedObject.coverI = Int64(bookData.coverI ?? 0)
        personManagedObject.userEmail = UserDefaults.userEmail

        do {
            try context.save()
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }

//    public static func fetchBooksFromDatabase() -> [BookDetails]? {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedBooks")
//
//        do {
//            if let fetchedResults = try context.fetch(fetchRequest) as? [SavedBooks] {
//                let books = fetchedResults.map { book in
//                    return BookDetails(authorName: [book.authorName ?? ""], coverI: Int(book.coverI), title: book.title, ratingsAverage: book.ratingsAverage, ratingsCount: Int(book.ratingsCount))
//                }
//                return books
//            } else {
//                return nil
//            }
//
//        } catch {
//            print("Error fetching data: \(error.localizedDescription)")
//            return []
//        }
//    }
    
    public static func fetchBooksForEmailFromDatabase(email: String) -> [BookDetails]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedBooks")
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", email)

        do {
            if let fetchedResults = try context.fetch(fetchRequest) as? [SavedBooks] {
                let books = fetchedResults.map { book in
                    return BookDetails(
                        authorName: [book.authorName ?? ""],
                        coverI: Int(book.coverI),
                        title: book.title,
                        ratingsAverage: book.ratingsAverage,
                        ratingsCount: Int(book.ratingsCount)
                    )
                }
                return books
            } else {
                return nil
            }
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return []
        }
    }

    public static func deleteBook(title: String, email: String = UserDefaults.userEmail) {
        let fetchRequest: NSFetchRequest<SavedBooks> = SavedBooks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND userEmail == %@", title, email)

        do {
            let books = try context.fetch(fetchRequest)

            if let bookToDelete = books.first {
                context.delete(bookToDelete)

                do {
                    try context.save()
                    if Constants.isLoggerOn {
                        print("Book deleted successfully")
                    }
                    
                } catch {
                    print("Error saving context after deleting book: \(error)")
                }
            } else {
                print("Book with title '\(title)' not found.")
            }
        } catch {
            print("Error fetching book to delete: \(error)")
        }
    }
}
