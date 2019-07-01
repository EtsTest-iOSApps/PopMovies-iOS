//
//  MovieDetailsController.swift
//  popmovies
//
//  Created by Tiago Silva on 18/04/2019.
//  Copyright © 2019 Tiago Silva. All rights reserved.
//

import Foundation
import UIKit
import Hero

// MARK: MovieDetailsController: BaseViewController

class MovieDetailsController: BaseViewController {
    // MARK: Constants
    
    let MovieDetailsHeaderCellIdentifier            = R.reuseIdentifier.movieDetailsHeaderCellIdentifier.identifier
    let MovieDetailsOverviewIdentifier              = R.reuseIdentifier.movieDetailsOverviewIdentifier.identifier
    let MovieDetailsCreditsCellIdentifier           = R.reuseIdentifier.movieDetailsCreditsCellIdentifier.identifier
    let MovieDetailsMidiaCellIdentifier             = R.reuseIdentifier.movieDetailsMidiaCellIdentifier.identifier
    let MovieDetailsRelatedCellIdentifier           = R.reuseIdentifier.movieDetailsRelatedCellIdentifier.identifier
    
    let numberOfRows                                = 5
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    
    // MARK: Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return style
    }
    
    var style: UIStatusBarStyle = .lightContent
    var isTabMidiaConfigured = false
    
    var presenter: MovieDetailsPresenterInterface?
    
    var movie: Movie? = nil
    var movieRankings: MovieOMDB? = nil
}

// MARK: Lifecycle Methods

extension MovieDetailsController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter?.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter?.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        presenter?.viewDidDisappear(animated)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y / 155
        
        if offset > 1 {
            offset = 1
            
            updateStatusBarStyle(offset: offset, barStyle: .default)
        } else {
            updateStatusBarStyle(offset: offset, barStyle: .black)
        }
    }
    
    private func updateStatusBarStyle(offset: CGFloat, barStyle: UIBarStyle) {
        let color = UIColor(white: 1.0 - offset, alpha: 1.0)
        let imageColor = UIColor(white: offset, alpha: 1.0)
        
        closeButton.backgroundColor = color
        closeButton.imageView?.setImageColorBy(uiColor: imageColor)
        
        shareButton.backgroundColor = color
        shareButton.imageView?.setImageColorBy(uiColor: imageColor)
        
        if (offset > 0.3) {
            self.style = .default
        } else {
            self.style = .lightContent
        }
        
        setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension MovieDetailsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return setupHeaderCell(tableView, indexPath)
        case 1:
            return setupOverviewCell(tableView, indexPath)
        case 2:
            return setupCreditsCell(tableView, indexPath)
        case 3:
            return setupMidiaCell(tableView, indexPath)
        case 4:
            return setupRelatedCell(tableView, indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func setupHeaderCell(_ tableView: UITableView,_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsHeaderCellIdentifier, for: indexPath) as? MovieDetailsHeaderCell else {
            return UITableViewCell()
        }
        
        if (self.movie != nil) { cell.movie = self.movie }
        if (self.movieRankings != nil) { cell.movieRanking = self.movieRankings }
        if (cell.movieDetailsHeaderDelegate == nil) { cell.movieDetailsHeaderDelegate = self }
        
        return cell
    }
    
    private func setupOverviewCell(_ tableView: UITableView,_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsOverviewIdentifier, for: indexPath) as? MovieDetailsOverviewCell else {
            return UITableViewCell()
        }
        
        if (self.movie != nil) { cell.movie = self.movie }
        if (self.movieRankings != nil) { cell.movieRanking = self.movieRankings }
        if (cell.movieDetailsOverviewDelegate == nil) {
            cell.movieDetailsOverviewDelegate = self
        }
        
        return cell
    }
    
    private func setupCreditsCell(_ tableView: UITableView,_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsCreditsCellIdentifier, for: indexPath) as? MovieDetailsCreditsCell else {
            return UITableViewCell()
        }
        
        if (self.movie != nil) { cell.movie = self.movie }
        if (cell.movieDetailsCreditsDelegate == nil) {
            cell.movieDetailsCreditsDelegate = self
        }
        
        return cell
    }
    
    private func setupMidiaCell(_ tableView: UITableView,_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsMidiaCellIdentifier, for: indexPath) as? MovieDetailsMidiaCell else {
            return UITableViewCell()
        }
        
        if (self.movie != nil) { cell.movie = self.movie }
        if (cell.movieDetailsMidiaDelegate == nil) { cell.movieDetailsMidiaDelegate = self }
        
        return cell
    }
    
    private func setupRelatedCell(_ tableView: UITableView,_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsRelatedCellIdentifier, for: indexPath) as? MovieDetailsRelatedCell else {
            return UITableViewCell()
        }
        
        if (self.movie != nil) { cell.movie = self.movie }
        if (self.movieRankings != nil) { cell.movieRanking = self.movieRankings }
        if (cell.movieDetailsRelatedDelegate == nil) {
            cell.movieDetailsRelatedDelegate = self
        }
        
        return cell
    }
    
}

// MARK: MovieDetailsViewInterface

extension MovieDetailsController: MovieDetailsViewInterface {
    
    func showMovieRankings(with movieRankings: MovieOMDB) {
        self.movieRankings = movieRankings
        
        let headerIndex = IndexPath(item: 0, section: 0)
        let middleIndex = IndexPath(item: 1, section: 0)
        
        self.tableView.reloadRows(at: [headerIndex, middleIndex], with: .none)
    }
    
    
    func showMovie(with movie: Movie) {
        self.movie = movie
        
        self.tableView.reloadData()
    }
    
}

// MARK: MovieDetailsViewInterface - Setup Methods

extension MovieDetailsController {
    
    func setupUI() {
        setupScreenTableView(tableView: tableView)
        
        closeButton.layer.cornerRadius = closeButton.bounds.width / 2
        shareButton.layer.cornerRadius = shareButton.bounds.width / 2
        
        self.title = movie?.title
    }
}

// MARK: MovieDetailsHeaderDelegate

extension MovieDetailsController: MovieDetailsHeaderDelegate {
    
    func didGenreSelected(_ genre: Genre) {
        self.presenter?.didSelectGenre(genre)
    }
    
}

// MARK: MovieDetailsCreditsDelegate

extension MovieDetailsController: MovieDetailsOverviewDelegate {
    
    func didImdbLinkButtonClicked() {
        guard let imdbURL = URLUtils.formatIMDBUrl(imdbId: movie?.imdbID) else { return }
        
        self.presenter?.didSelectLink(url: imdbURL)
    }
    
    func didTomatoesLinkButtonClicked() {
        guard let tomatoURL = movieRankings?.tomatoURL else { return }
        
        self.presenter?.didSelectLink(url: tomatoURL)
    }
    
    func didWikiLinkButtonClicked() {
        guard let wikiUrl = URLUtils.formatWikiUrl(wikiSearchTerm: movie?.originalTitle) else { return }
        
        self.presenter?.didSelectLink(url: wikiUrl)
    }

}

// MARK: MovieDetailsCreditsDelegate

extension MovieDetailsController: MovieDetailsCreditsDelegate {
    
    func didSelectPerson(_ person: Person) {
        self.presenter?.didSelectPerson(person)
    }
    
}

// MARK: MovieDetailsRelatedDelegate

extension MovieDetailsController: MovieDetailsRelatedDelegate {
    
    func didMovieSelect(_ movie: Movie) {
        self.presenter?.didSelectMovie(movie)
    }
    
    func didSeeAllRelatedMoviesClicked() {
        self.presenter?.didSeeAllRelatedMoviesClicked()
    }
    
}

// MARK: MovieDetailsMidiaDelegate

extension MovieDetailsController: MovieDetailsMidiaDelegate {
    
    func didImageSelected(_ image: Image, _ allImages: [Image], indexPath: IndexPath) {
        self.presenter?.didSelectImage(image, allImages, indexPath: indexPath)
    }
    
    func didVideoSelected(_ video: Video, _ allVideos: [Video]) {
        self.presenter?.didSelectVideo(video, allVideos)
    }
    
    func didSeeAllVideosClicked(_ allVideos: [Video]) {
        self.presenter?.didSeeAllVideosClicked(allVideos)
    }
    
    func didSeeAllWallpapersClicked(_ allImages: [Image]) {
        self.presenter?.didSeeAllWallpapersClicked(allImages)
    }
    
}

// MARK: Actions Methods

private extension MovieDetailsController {
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let progress = translation.y / 2 / view.bounds.height
        
        switch sender.state {
        case .began:
            dismiss()
        case .changed:
            Hero.shared.update(progress)
            
            let currentPos = CGPoint(x: translation.x + view.center.x, y: translation.y + view.center.y)
            
            Hero.shared.apply(modifiers: [.position(currentPos)], to: view)
        default:
            if progress + sender.velocity(in: nil).y / view.bounds.height > 0.2 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
    
    @IBAction func dismiss() {
        hero.dismissViewController()
    }
}
