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
    @IBOutlet weak var favoriteButton: UIButton!
    
    var passedObj: Podcast?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @IBAction func favorite(_ sender: UIButton){
        guard let validPodCast = passedObj else { fatalError("failed to get valid PodCAST, check prepare for segue")
        }
        
        let postedFavorite = Podcast(collectionId: passedObj?.collectionId ?? 0, trackId: validPodCast.trackId, artistName: passedObj?.artistName ?? "N/A", collectionName: validPodCast.collectionName, artworkUrl30: nil, artworkUrl60: nil, artworkUrl100: nil, releaseDate: nil, country: passedObj?.country ?? "N/A", currency: nil, primaryGenreName: passedObj?.primaryGenreName ?? "N/A", artworkUrl600: validPodCast.artworkUrl600, genres: passedObj?.genres ?? ["N/A"], favoritedBy: "B.A.")
        
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
                    if validPodCast.favoritedBy != nil {
                        self?.favoriteButton.isHidden = true
                    } else {
                        self?.favoriteButton.isHidden = false
                    }
                }
            }
        }
        artistNameLabel.text = validPodCast.artistName
        collectionNameLabel.text = validPodCast.collectionName
        genreLabel.text = "Genre: \(validPodCast.primaryGenreName ?? "N/A")\nSubgenre(s): \(validPodCast.genres?.joined(separator: ", ") ?? "N/A")"
        countryLabel.text = validPodCast.country
    }

}
