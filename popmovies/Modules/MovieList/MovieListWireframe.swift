//
//  MovieListWireframe.swift
//  popmovies
//
//  Created by Tiago Silva on 29/06/19.
//  Copyright © 2019 Tiago Silva. All rights reserved.
//

import UIKit

// MARK: MovieListWireframe: MovieListWireframeInterface

class MovieListWireframe: MovieListWireframeInterface {
    
    weak var viewController: UIViewController?
    
    func presentDetails(for movie: Movie) {
        let movieDetailsModule = MovieDetailsWireframe.buildModule(with: movie)
        
        self.viewController?.navigationController?.present(movieDetailsModule, animated: true, completion: nil)
    }
}

// MARK: build's Module

extension MovieListWireframe {
    
    static func buildModule(url: String, parameters: [String : String], title: String) -> UIViewController {
        let module = buildModule() as! MovieListController
        
        module.url = url
        module.parameters = parameters
        module.title = title
        
        return module
    }
    
    static func buildModule(with movies: [Movie]) -> UIViewController {
        let module = buildModule() as! MovieListController
        
        module.movies = movies
        
        return module
    }
    
    static func buildModule() -> UIViewController {
        let view = R.storyboard.main.movieListController()
        
        return build(view)
    }
    
    static func buildModuleFromUINavigation() -> UIViewController {
        let navigationController = R.storyboard.main.movieListNavigationController()
        let view = navigationController?.viewControllers.first as! MovieListController
        
        return build(view)
    }
    
    static func buildModuleFromUINavigation(url: String, parameters: [String : String], title: String) -> UIViewController {
        let module = buildModuleFromUINavigation() as! MovieListController
        
        module.url = url
        module.parameters = parameters
        module.title = title
        
        return module
    }
    
    static func buildModuleFromUINavigation(with movies: [Movie]) -> UIViewController {
        let module = buildModuleFromUINavigation() as! MovieListController
        
        module.movies = movies
        
        return module
    }
    
    private static func build(_ view: MovieListController?) -> UIViewController {
        let wireframe = MovieListWireframe()
        let presenter = MovieListPresenter(view: view)
        let interactor = MovieListInteractor(output: presenter)
        
        view?.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        
        interactor.output = presenter
        wireframe.viewController = view
        
        return view!
    }
}
