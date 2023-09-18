//
//  ViewController.swift
//  SearchFilmsApp
//
//  Created by Иван Бондаренко on 18.09.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let searchBarInsets: CGFloat = 16
        static let tableViewInsets: CGFloat = 16
        static let cellID = "CellID"
        static let heightRow: CGFloat = 150
        static let searchMovies = "Search movies"
    }
    
    // MARK: - Private properties
    
    private lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.placeholder = Constants.searchMovies
        return searchBar
    }()
    
    private lazy var tableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0,
                                                left: Constants.tableViewInsets,
                                                bottom: 0,
                                                right: Constants.tableViewInsets)
        tableView.register(ViewControllerCell.self, forCellReuseIdentifier: Constants.cellID)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private var timer: Timer?
    
    // MARK: - Public properties
    
    let networkDataFetcher = NetworkDataFetcher()
    var movies = [Movies]()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.addSubview(tableView)
        view.backgroundColor = .white
        view.addSubview(searchBar)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.searchBarInsets),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.searchBarInsets),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.tableViewInsets),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.tableViewInsets),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Extension

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Public Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.heightRow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID) as? ViewControllerCell
        let movie = movies[indexPath.row]
        cell?.movieURL = movie
        cell?.labelHeader.text = movie.nameRu
        cell?.labelText.text = movie.description
        return cell ?? UITableViewCell()
    }
}

extension ViewController: UISearchBarDelegate {
    
    // MARK: - Public Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                guard let fetchMovie = searchResults?.films else {return}
                self?.movies = fetchMovie
            }
        })
    }
}

