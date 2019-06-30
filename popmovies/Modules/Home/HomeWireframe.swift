//
//  HomeWireframe.swift
//  popmovies
//
//  Created by Tiago Silva on 29/06/19.
//  Copyright © 2019 Tiago Silva. All rights reserved.
//

import UIKit

// MARK: HomeWireframe: HomeWireframaInterface

class HomeWireframe: HomeWireframaInterface {
    
    weak var viewController: UIViewController?
    
    func presentDetails(for movie: Movie) {
        let movieDetailsModule = MovieDetailsWireframe.buildModule(with: movie)
        
        self.viewController?.navigationController?.present(movieDetailsModule, animated: true, completion: nil)
    }
    
    func pushToPopularMoviesList() {
        let url = TMDB.URL.MOVIES.POPULAR_MOVIES_URL
        let parameters = TMDB.URL.MOVIES.buildMovieListParameters()
        let title = "Popular Movies"
        
        pushToMovieList(url, parameters, title)
    }
    
    func pushToTopRatedMoviesList() {
        let url = TMDB.URL.MOVIES.TOP_RATED_MOVIES_URL
        let parameters = TMDB.URL.MOVIES.buildMovieListParameters()
        let title = "To Rated Movies"
        
        pushToMovieList(url, parameters, title)
    }
    
    func pushToUpcomingMoviesList() {
        let url = TMDB.URL.MOVIES.UPCOMING_MOVIES_URL
        let parameters = TMDB.URL.MOVIES.buildMovieListParameters()
        let title = "Upcoming Movies"
        
        pushToMovieList(url, parameters, title)
    }
    
    private func pushToMovieList(_ url: String,_ parameters: [String : String],_ title: String) {
        let movieListModule = MovieListWireframe.buildModule(url: url, parameters: parameters, title: title)
        
        viewController?.navigationController?.pushViewController(movieListModule, animated: true)
    }
}

// MARK: build's Module

extension HomeWireframe {
    
    static func buildModule() -> UIViewController {
        let wireframe = HomeWireframe()
        let view = R.storyboard.main.homeController()
        let presenter = HomePresenter(view: view)
        let interactor = HomeInteractor(output: presenter)
        
        view?.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
       
        interactor.output = presenter
        wireframe.viewController = view
        
        return view!
    }
}
