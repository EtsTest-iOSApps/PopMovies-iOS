//
//  GenreCell.swift
//  popmovies
//
//  Created by Tiago Silva on 24/06/19.
//  Copyright © 2019 Tiago Silva. All rights reserved.
//

import UIKit

class GenreCell: UICollectionViewCell {
    
    @IBOutlet weak var genreImageView: UIGradientImageView!
    @IBOutlet weak var genreNameLabel: UILabel!
    
    var genre: Genre? {
        didSet { bindGenre(self.genre!) }
    }
    
    var isBind = false
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience required init(key:String) {
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    private func bindGenre(_ genre: Genre) {
        genreNameLabel.text = genre.name
        
        if let imageName = genre.imageName {
            let image = UIImage(named: imageName)
            
            genreImageView.setImage(image: image, animation: .transitionCrossDissolve) 
        }
        
        if !isBind {
            let color = UIColor.black
            color.withAlphaComponent(0.6)
            
            genreImageView.updateColors(colors:
                [UIColor.clear.cgColor, color.cgColor]
            )
            
            isBind = true
        }
        
    }
}
