//
//  MovieService.swift
//  popmovies
//
//  Created by Tiago Silva on 14/04/2019.
//  Copyright © 2019 Tiago Silva. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire

// MARK: IMovieService

protocol IMovieService {
    
    func getMovieRankings(imdbId: String) -> Observable<MovieOMDB>
    func getDetails(movieId: Int, appendToResponse: [String], language: String) -> Observable<Movie>
    
    func getImages(movieId: Int, includeImageLanguage: [String], language: String?) -> Observable<Images>
    func getVideos(movieId: Int, language: String?) -> Observable<Results<Video>>
    
    func getPopularMovies(page: Int, region: String) -> Observable<Results<Movie>>
    func getNowPlaying(page: Int, region: String) -> Observable<Results<Movie>>
    func getTopRated(page: Int, region: String) -> Observable<Results<Movie>>
    func getUpcoming(page: Int, region: String) -> Observable<Results<Movie>>
    func getMovieList(url: String, paramenters: [String : String]) -> Observable<Results<Movie>> 
}

// MARK: MovieService: IMovieService

class MovieService: IMovieService {
    
    func getMovieRankings(imdbId: String) -> Observable<MovieOMDB> {
        let baseUrl = OMDB.BASE_URL
        let parameters = OMDB.URL.buildMovieRankingsParameters(imdbId)
        
        return requestJSON(.get, baseUrl, parameters: parameters)
            .debug()
            .mapObject(type: MovieOMDB.self)
    }
    
    func getDetails(movieId: Int, appendToResponse: [String], language: String = "pt_BR") -> Observable<Movie> {
        let url = TMDB.URL.MOVIES.buidMovieDetailsUrl(movieId: movieId)
        let parameters = TMDB.URL.MOVIES.buildMovieDetailsParameters(appendToResponse, language)
        
        return requestJSON(.get, url, parameters: parameters)
                    .debug()
                    .mapObject(type: Movie.self)
    }
    
    func getImages(movieId: Int, includeImageLanguage: [String], language: String? = nil) -> Observable<Images> {
        let url = TMDB.URL.MOVIES.buildImagesUrl(movieId: movieId)
        let parameters = TMDB.URL.MOVIES.buildImagesParameters(includeImageLanguage, language)
        
        return requestJSON(.get, url, parameters: parameters)
            .debug()
            .mapObject(type: Images.self)
    }
    
    func getVideos(movieId: Int, language: String? = nil) -> Observable<Results<Video>> {
        let url = TMDB.URL.MOVIES.buidVideosUrl(movieId: movieId)
        let parameters = TMDB.URL.MOVIES.buildVideosParameters(language)
        
        return requestJSON(.get, url, parameters: parameters)
            .debug()
            .mapObject(type: Results<Video>.self)
    }
    
    func getNowPlaying(page: Int, region: String = "BR") -> Observable<Results<Movie>> {
        let url = TMDB.URL.MOVIES.NOW_PLAYING_MOVIES_URL
        
        return buildMovieList(url: url, region: region, page: page)
    }
    
    func getTopRated(page: Int, region: String = "BR") -> Observable<Results<Movie>> {
        let url = TMDB.URL.MOVIES.TOP_RATED_MOVIES_URL
        
        return buildMovieList(url: url, region: region, page: page)
    }
    
    func getUpcoming(page: Int, region: String = "BR") -> Observable<Results<Movie>> {
        let url = TMDB.URL.MOVIES.UPCOMING_MOVIES_URL
        
        return buildMovieList(url: url, region: region, page: page)
    }
    
    func getPopularMovies(page: Int, region: String = "BR") -> Observable<Results<Movie>> {
        let url = TMDB.URL.MOVIES.POPULAR_MOVIES_URL
        
        return buildMovieList(url: url, region: region, page: page)
    }
    
    func getMovieList(url: String, paramenters: [String : String]) -> Observable<Results<Movie>> {
        return requestJSON(.get, url, parameters: paramenters)
            .debug()
            .mapObject(type: Results<Movie>.self)
    }
    
}

// MARK: Helpers Method

private extension MovieService {
    
    private func buildMovieList(url: String, region: String, page: Int) -> Observable<Results<Movie>> {
        let parameters = TMDB.URL.MOVIES.buildMovieListParameters(region, page)
        
        return requestJSON(.get, url, parameters: parameters)
            .debug()
            .mapObject(type: Results<Movie>.self)
    }
}
