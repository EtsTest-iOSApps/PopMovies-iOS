//
//  MovieServiceInterface.swift
//  popmovies
//
//  Created by Tiago Silva on 06/07/19.
//  Copyright © 2019 Tiago Silva. All rights reserved.
//

import RxSwift
import RxAlamofire

protocol MovieServiceInterface {
    
    func getMovieRankings(imdbId: String) -> Observable<MovieOMDB>
    func getDetails(movieId: Int, appendToResponse: [String], language: String) -> Observable<Movie>
    
    func getImages(movieId: Int, includeImageLanguage: [String], language: String?) -> Observable<Images>
    func getAllImages(movieId: Int, language: String) -> Observable<ImageResultDTO>
    func getVideos(movieId: Int, language: String?) -> Observable<Results<Video>>
    func getAllVideos(movieId: Int, language: String) -> Observable<VideoResultDTO>
    func getTranslations(movieId: Int) -> Observable<TranslationResults>
    
    func searchMovie(with query: String, page: Int, language: String, region: String) -> Observable<Results<Movie>> 
    
    func getMovieDiscover(page: Int, discoverMovie: DiscoverMovie) -> Observable<Results<Movie>>
    func getPopularMovies(page: Int, region: String) -> Observable<Results<Movie>>
    func getNowPlaying(page: Int, region: String) -> Observable<Results<Movie>>
    func getTopRated(page: Int, region: String) -> Observable<Results<Movie>>
    func getUpcoming(page: Int, region: String) -> Observable<Results<Movie>>
    func getMovieList(url: String, paramenters: [String : String]) -> Observable<Results<Movie>>
}
