//
//  ProfileController.swift
//  popmovies
//
//  Created by Tiago Silva on 10/04/2019.
//  Copyright © 2019 Tiago Silva. All rights reserved.
//

import UIKit

// MARK:

class ProfileController: BaseViewController {
    
    // MARK: Constants
    
    let ProfileHeaderCell                   = R.nib.profileHeaderCell.name
    let ProfileHeaderCellIdentifier         = "ProfileHeaderCellIdentifier"
    
    let ProfileFavoriteCell                 = R.nib.profileFavoriteCell.name
    let ProfileFavoriteCellIdentifier       = "ProfileFavoriteCellIdentifier"
    
    let ProfileWantToSeeCell                = R.nib.profileWantToSeeCell.name
    let ProfileWantToSeeCellIdentifier      = "ProfileWantToSeeIdentifier"
    
    let ProfileWatchedCell                  = R.nib.profileWatchedCell.name
    let ProfileWatchedCellIdentifier        = "ProfileWatchedCellIdentifier"
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signOutButton: UIButton!
    
    // MARK: Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return style
    }
    
    var style: UIStatusBarStyle = .lightContent
    var presenter: ProfilePresenterInterface?
    var user: UserLocal?
    
    var watchedMovies: [Movie] = []
    var favoriteMovies: [Movie] = []
}

// MARK: Lifecycle Methods

extension ProfileController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenter?.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter?.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.presenter?.viewDidDisappear(animated)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y / 180
        let color = UIColor(white: 1.0 - offset, alpha: 1.0)
        let imageColor = UIColor(white: offset, alpha: 1.0)
        
        if offset > 1 {
            offset = 1
            
            updateStatusBarStyle(offset: offset, barStyle: .default)
        } else {
            updateStatusBarStyle(offset: offset, barStyle: .black)
        }
        
        updateButtonStyle(signOutButton, color, imageColor)
    }
    
    private func updateStatusBarStyle(offset: CGFloat, barStyle: UIBarStyle) {
        
        if (offset > 0.3) {
            self.style = .default
        } else {
            self.style = .lightContent
        }
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func updateButtonStyle(_ button: UIButton, _ backgroundColor: UIColor, _ imageColor: UIColor) {
        
        button.backgroundColor = backgroundColor
        button.imageView?.setImageColorBy(uiColor: imageColor)
    }
    
}

// MARK: ProfileViewInterface - Setup Methods

extension ProfileController: ProfileViewInterface {
    
    func setupUI() {
        signOutButton.layer.cornerRadius = signOutButton.bounds.width / 2
        
        setupTableView()
    }
    
    func setupTableView() {
        setupScreenTableView(tableView: tableView)
        
        tableView.contentInset = UIEdgeInsets(top: 240, left: 0, bottom: 100, right: 0)

        tableView.configureNibs(nibName: ProfileHeaderCell, identifier: ProfileHeaderCellIdentifier)
        tableView.configureNibs(nibName: ProfileFavoriteCell, identifier: ProfileFavoriteCellIdentifier)
        tableView.configureNibs(nibName: ProfileWatchedCell, identifier: ProfileWatchedCellIdentifier)
        
        tableView.reloadData()
    }
    
    func setupProfileUI(with user: UserLocal) {
        self.user = user
        
        tableView.reloadData()
    }
}

extension ProfileController {
    
    func updateUserData(_ user: UserLocal) {
        self.user = user
        
        self.updateRow(itemIndex: 0)
    }
    
    func showFavorites(with movies: [Movie]) {
        self.favoriteMovies = movies
        
        self.updateRow(itemIndex: 1)
    }
    
    func showWatched(with movies: [Movie]) {
        self.watchedMovies = movies
        
        self.updateRow(itemIndex: 2)
    }
    
    private func updateRow(itemIndex: Int) {
        let indexPath = IndexPath(item: itemIndex, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .left)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return setupProfileHeader(tableView, cellForRowAt: indexPath)
        case 1:
            return setupProfileFavorite(tableView, cellForRowAt: indexPath)
        case 2:
            return setupProfileWatched(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func setupProfileHeader(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHeaderCellIdentifier) as? ProfileHeaderCell else {
            return UITableViewCell()
        }
        
        if (self.user != nil) { cell.user = self.user }
        
        return cell
    }
    
    private func setupProfileFavorite(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileFavoriteCellIdentifier) as? ProfileFavoriteCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.bindContent(self.favoriteMovies)
        
        return cell
    }
    
    private func setupProfileWantToSee(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileWantToSeeCellIdentifier) as? ProfileWantToSeeCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    private func setupProfileWatched(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileWatchedCellIdentifier) as? ProfileWatchedCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.bindContent(self.watchedMovies)
        
        return cell
    }
}

extension ProfileController: ProfileMoviesCellDelegate {
    
    func didSelectMovie(with movie: Movie) {
        self.presenter?.didSelectMovie(movie)
    }
    
    func didSeeAllClicked(with movies: [Movie], _ listName: String) {
        self.presenter?.didSeeAllClicked(with: movies, listName)
    }
}

extension ProfileController {
    
    @IBAction func didSingUpClicked(_ sender: Any) {
        presenter?.didSingUpClicked()
    }
}
