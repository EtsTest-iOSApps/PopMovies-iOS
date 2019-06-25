//
//  PersonDetailsController.swift
//  popmovies
//
//  Created by Tiago Silva on 19/06/19.
//  Copyright © 2019 Tiago Silva. All rights reserved.
//

import UIKit
import Hero

class PersonDetailsController: BaseViewController {
    let MovieDetailsControllerIdentifier            = "MovieDetailsControllerIdentifier"
    let ImageListControllerIdentifier               = "ImageListControllerIdentifier"
    let ImageViewerControllerIdentifier             = "ImageViewerControllerIdentifier"

    let PersonDetailsHeaderCellIdentifier           = "PersonDetailsHeaderCellIdentifier"
    let PersonDetailsOverviewCellIdentifier         = "PersonDetailsOverviewCellIdentifier"
    let PersonDetailsKnownForCellIdentifier         = "PersonDetailsKnownForCellIdentifier"
    let PersonDetailsFilmographyCellIdentifier      = "PersonDetailsFilmographyCellIdentifier"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var isFromServer = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
    
    var style:UIStatusBarStyle = .lightContent
    
    var presenter: IPersonDetailsPresenter!
    var person: Person?
    
    override func viewWillAppear(_ animated: Bool) {
        setupScreenTableView(tableView: tableView)
        
        backButton.layer.cornerRadius = backButton.bounds.width / 2
        shareButton.layer.cornerRadius = backButton.bounds.width / 2
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        presenter = PersonDetailsPresenter(view: self)
        presenter.fetchPersonDetails(personId: person?.id)
        
        tableView.reloadData()
    }
    
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
        
        backButton.backgroundColor = color
        backButton.imageView?.setImageColorBy(uiColor: imageColor)
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

extension PersonDetailsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonDetailsHeaderCellIdentifier, for: indexPath) as? PersonDetailsHeaderCell else {
                return UITableViewCell()
            }
            
            if person != nil {
                cell.person = person
                
                if (isFromServer) {
                    cell.bindBackdropImage(person!)
                }
            }
            
            if cell.headerListener == nil {
                cell.headerListener = self
            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonDetailsOverviewCellIdentifier, for: indexPath) as? PersonDetailsOverviewCell else {
                return UITableViewCell()
            }
            
            if person != nil { cell.person = person }
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonDetailsKnownForCellIdentifier, for: indexPath) as? PersonDetailsKnownForCell else {
                return UITableViewCell()
            }
            
            if person != nil { cell.person = person }
            if cell.knownForListener == nil {
                cell.knownForListener = self
            }
            
            return cell
        case 3:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonDetailsFilmographyCellIdentifier, for: indexPath) as? PersonDetailsFilmographyCell else {
                return UITableViewCell()
            }
        
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension PersonDetailsController: IPersonDetailsView {
    
    func bindPerson(person: Person) {
        self.person = person
        
        isFromServer = true
        
        self.tableView.reloadData()
    }
    
}

extension PersonDetailsController: IKnownForListener, IHeaderListener {
    
    func didMovieSelect(_ movie: Movie) {
        if let controller = self.storyboard!.instantiateViewController(withIdentifier: MovieDetailsControllerIdentifier) as? MovieDetailsController {
            
            controller.hero.modalAnimationType = .slide(direction: .up)
            controller.movie = movie
            
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func didImageSelect(_ image: Image, allImages: [Image], indexPath: IndexPath) {
        guard let controller = self.storyboard!.instantiateViewController(withIdentifier: ImageViewerControllerIdentifier) as? ImageViewerController else {
            return
        }
        
        controller.hero.modalAnimationType = .fade
        controller.selectedIndex = indexPath
        controller.image = image
        controller.allImages = allImages
        controller.person = self.person
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func didSeeAllMoviesHeaderButtonSelect(_ allMovies: [Movie]) {
        
    }
    
    func didSeeAllImagesHeaderButtonSelect(_ allImages: [Image]) {
        seeAllImages(allImages)
    }
    
    func didSeeAllImagesSelect(_ allImages: [Image]) {
        seeAllImages(allImages)
    }
    
    private func seeAllImages(_ allImages: [Image]) {
        guard let controller = self.storyboard!.instantiateViewController(withIdentifier: ImageListControllerIdentifier) as? ImageListController else {
            return
        }
        
        controller.hero.modalAnimationType = .fade
        controller.allImages = allImages
        controller.person = self.person
        
        self.present(controller, animated: true, completion: nil)
    }
}
