//
//  MovieListController.swift
//  popmovies
//
//  Created by Tiago Silva on 24/06/19.
//  Copyright © 2019 Tiago Silva. All rights reserved.
//

import UIKit
import Hero

// MARK: MovieListController: BaseViewController

class MovieListController: BaseViewController {
    // MARK: Constants
    
    let MovieCellIdentifier                     = "MovieCellIdentifier"
    let MovieCellName                           = R.nib.movieCell.name
    
    let numberOfCollunms = 2
    
    // MARK: Outlets
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    // MARK: Properties
    
    var movies: [Movie]?
    var presenter: MovieListPresenterInterface?
    
    var parameters: [String : String] = [:]
    var url: String?
    
    lazy var cellSize: CGSize = CGSize(width: self.moviesCollectionView.bounds.width / CGFloat(self.numberOfCollunms), height: (self.moviesCollectionView.bounds.width / CGFloat(self.numberOfCollunms)) + CGFloat(115))
    
}

// MARK: Lifecycle Methods

extension MovieListController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenter?.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter?.viewDidLoad()
        
        if movies == nil {
            presenter?.fetchMovies(from: url, with: parameters)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.presenter?.viewDidDisappear(animated)
        self.presenter = nil
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension MovieListController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCellIdentifier, for: indexPath) as? MovieCell, let movies = self.movies else {
            return UICollectionViewCell()
        }
        let movie = movies[indexPath.row]
        
        cell.bindMovieCellDefault(movie: movie)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movies = self.movies else {
            return
        }
        let movie = movies[indexPath.row]
        
        presenter?.didSelectMovie(movie)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        presenter?.fetchMovies(from: url, with: parameters)
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout

extension MovieListController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellSize
    }
}

// MARK: MovieListViewInterface

extension MovieListController: MovieListViewInterface {
    
    func showMovies(with movies: [Movie]) {
        if self.movies != nil {
            self.movies! += movies
        } else {
            self.movies = movies
        }
        
        moviesCollectionView.reloadData()
    }
    
}

// MARK: MovieListViewInterface - Setup Methods

extension MovieListController {
    
    func setupUI() {
        moviesCollectionView.configureNibs(nibName: MovieCellName, identifier: MovieCellIdentifier)
    }
}
