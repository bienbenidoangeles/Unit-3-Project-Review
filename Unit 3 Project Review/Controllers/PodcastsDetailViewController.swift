//
//  PodcastsDetailViewController.swift
//  Unit 3 Project Review
//
//  Created by Bienbenido Angeles on 12/17/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import UIKit

class PodcastsDetailViewController: UIViewController {
    
    @IBOutlet weak var podcastImageView:UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel:UILabel!
    @IBOutlet weak var genreLabel:UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    var passedObj: Podcast?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @IBAction func favorite(_ sender: UIButton){
        guard let validPodCast = passedObj else { fatalError("failed to get valid PodCAST, check prepare for segue")
        }
        
        let postedFavorite = PostFavoritesModel(trackId: validPodCast.trackId, favoritedBy: "B.A.", collectionName: validPodCast.collectionName, artworkUrl600: validPodCast.artworkUrl600)
        PodcastAPIClient.postPodCast(favoritedPodcast: postedFavorite) {[weak self] (result) in
            switch result{
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "FAILURE", message: "\(appError)")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "SUCCESS", message: "Podcast posted successfully")
                }
            }
        }
        
    }
    

    func configureUI(){
        guard let validPodCast = passedObj else {
            fatalError("failed to get valid PodCAST, check prepare for segue")
        }
        
        podcastImageView.getImage(withURLString: validPodCast.artworkUrl600) {[weak self] (result) in
            switch result{
            case .failure:
                DispatchQueue.main.async {
                    self?.podcastImageView.image = UIImage(systemName: "exclaimationmark.triangle.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.podcastImageView.image = image
                }
            }
        }
        artistNameLabel.text = validPodCast.artistName
        collectionNameLabel.text = validPodCast.collectionName
        genreLabel.text = "Genre: \(validPodCast.primaryGenreName)\nSubgenre(s): \(validPodCast.genres.joined(separator: ", "))"
        countryLabel.text = validPodCast.country
    }

}
