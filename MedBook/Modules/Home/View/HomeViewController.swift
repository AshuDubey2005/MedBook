//
//  HomeViewController.swift
//  MedBook
//
//  Created by deq on 15/02/24.
//

import UIKit

class HomeViewController: BaseViewController<HomeViewModel> {
    
    // MARK: - OutLets
    @IBOutlet weak var viewLoader: UIActivityIndicatorView!
    @IBOutlet weak var segmentFilters: UISegmentedControl!
    @IBOutlet weak var viewFilters: UIStackView!
    @IBOutlet weak var tableViewBooks: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var timer: Timer?
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
    }
    
    override func addListener() {
        super.addListener()
        
        viewModel.isBookFetchingCompleted.bind { [weak self] _ in
            guard let self = self else { return }
            self.viewFilters.isHidden = self.viewModel.searchedBooks.count <= 0
            self.tableViewBooks.reloadData()
        }
        viewModel.showLoader.bind { [weak self] isShowingLoader in
            DispatchQueue.main.async {
                isShowingLoader ? self?.viewLoader.startAnimating() : self?.viewLoader.stopAnimating()
            }
           
        }
    }
    
    func setupView() {
        self.viewFilters.isHidden = self.viewModel.searchedBooks.count <= 0
        searchBar.roundCorners(12)
        setupTableViewAndDelegates()
        
    }
    
    func setupTableViewAndDelegates() {
        tableViewBooks.dataSource = self
        tableViewBooks.delegate = self
        tableViewBooks.register(UINib(nibName: "BookResultTableViewCell", bundle: nil), forCellReuseIdentifier: "BookResultTableViewCell")
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func actionNavigateToBookMarksPage(_ sender: Any) {
        self.push(BookmarksViewController.getInstance(BookmarksViewModel()))
    }
    
    @IBAction func actionLogOut(_ sender: Any) {
        self.logoutAndSetRoot()
    }
    
    @IBAction func actionSegment(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        var books = viewModel.searchedBooks
        switch selectedIndex {
        case 0:
            viewModel.selectedConditon = .title
            books.sort { $0.title ?? "" < $1.title ?? ""  }
        case 1:
            viewModel.selectedConditon = .average
            books.sort { $0.ratingsAverage ?? 0.0 > $1.ratingsAverage ?? 0.0 }
        case 2:
            viewModel.selectedConditon = .hits
            books.sort { $0.ratingsCount ?? 0 > $1.ratingsCount ?? 0 }
        default:
            break
        }
        DispatchQueue.main.async {
            self.viewModel.searchedBooks = books
            self.tableViewBooks.reloadData()
        }
    }
    
}
// MARK: - TableView Datasource and Delegate Methods
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.searchedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BookResultTableViewCell") as? BookResultTableViewCell {
            cell.setData(data: viewModel.searchedBooks[indexPath.row])
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let books = viewModel.searchedBooks
        if indexPath.row == books.count - 1 {
            viewModel.searchBooks(title: viewModel.searchTitle, offset: viewModel.offSet + viewModel.limit)
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var book = self.viewModel.searchedBooks[indexPath.row]
        let bookMarkAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            book.isBookMarked.toggle()
            book.isBookMarked ? BooksCoreDataOperations.saveBookToDatabase(bookData: book) : BooksCoreDataOperations.deleteBook(title: book.title ?? "")
            self.viewModel.searchedBooks[indexPath.row] = book
            completion(true)
        }
        
        bookMarkAction.image = book.isBookMarked ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        
        let config = UISwipeActionsConfiguration(actions: [bookMarkAction])
        return config
    }
    
    
}

// MARK: - Search Delegates
extension HomeViewController: UISearchBarDelegate, UITextFieldDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        if searchText.count >= 3 {
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                
                self?.viewModel.searchBooks(title: searchText)
                self?.viewModel.searchTitle = searchText
            }
        }
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.viewModel.searchedBooks.removeAll()
        self.viewModel.searchTitle = ""
        viewFilters.isHidden = true
        tableViewBooks.reloadData()
        return true
    }
}

// MARK: - Extensions
extension HomeViewController {
    static func getInstance(_ instance: HomeViewModel) -> HomeViewController {
        let controller: HomeViewController = UIViewController.load()
        controller.viewModel = instance
        return controller
    }
}
