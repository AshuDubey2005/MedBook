//
//  BookmarksViewController.swift
//  MedBook
//
//  Created by deq on 16/02/24.
//

import UIKit

class BookmarksViewController: BaseViewController<BookmarksViewModel> {
    
// MARK: - Outlets
    @IBOutlet weak var tableViewBookmarks: UITableView!
    
// MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewAndDelegates()
        
    }
    
    func setupViewAndDelegates() {
        tableViewBookmarks.delegate = self
        tableViewBookmarks.dataSource = self
        tableViewBookmarks.register(UINib(nibName: "BookResultTableViewCell", bundle: nil), forCellReuseIdentifier: "BookResultTableViewCell")
        navigationController?.navigationBar.isHidden = false
    }
    
    override func addListener() {
        super.addListener()
        
        viewModel.isBookFetchingCompleted.bind { [weak self] _ in
            self?.tableViewBookmarks.reloadData()
        }
    }

}


// MARK: - TableView Datasource and Delegate Methods
extension BookmarksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookMarkedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BookResultTableViewCell") as? BookResultTableViewCell {
            cell.setData(data: viewModel.bookMarkedBooks[indexPath.row])
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
  
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let book = self.viewModel.bookMarkedBooks[indexPath.row]
        let bookMarkAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            self.viewModel.bookMarkedBooks.remove(at: indexPath.row)
            BooksCoreDataOperations.deleteBook(title: book.title ?? "")
            completion(true)
        }
        
        bookMarkAction.image =  UIImage(systemName: "bookmark.fill")
        
        let config = UISwipeActionsConfiguration(actions: [bookMarkAction])
        return config
    }
    
    
}

// MARK: - Extensions
extension BookmarksViewController {
    static func getInstance(_ instance: BookmarksViewModel) -> BookmarksViewController {
        let controller: BookmarksViewController = UIViewController.load()
        controller.viewModel = instance
        return controller
    }
}
