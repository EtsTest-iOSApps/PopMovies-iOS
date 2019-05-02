//
//  UpcomingMoviesCell.swift
//  popmovies
//
//  Created by Tiago Silva on 01/05/2019.
//  Copyright © 2019 Tiago Silva. All rights reserved.
//

import UIKit

class UpcomingMoviesCell: MovieListCell {
    
    override var nibName: String {
        get { return "MovieSmallCell" }
        set {}
    }
    
    override func bindMovieCell(cell: MovieCell, movie: Movie, index: Int) -> UICollectionViewCell {
        cell.bindMovieCellDefault(movie: movie)
        
        return cell
    }
}
