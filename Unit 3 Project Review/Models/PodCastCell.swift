//
//  PodCastCell.swift
//  Unit 3 Project Review
//
//  Created by Bienbenido Angeles on 12/17/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import UIKit

class PodCastCell: UITableViewCell {

    @IBOutlet weak var podcastArtImageView: UIImageView!
    @IBOutlet weak var favoritesImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    
    @IBOutlet weak var favoriteCollectionLabel: UILabel!
    
    private var podcastURLString:String? = ""
    private var favoritesURLString: String? = ""
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        guard podcastArtImageView?.image != nil else {
            favoritesImageView.image = nil
            return
        }
        guard favoritesImageView?.image != nil else {
            podcastArtImageView.image = nil
            return
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard podcastArtImageView?.image != nil else {
            return
        }
        guard favoritesImageView?.image != nil else {
            podcastArtImageView.layer.cornerRadius = podcastArtImageView.frame.size.width / 2.0
            return
        }
        
    }
    
    func configureCell(for podcast: Podcast){
        self.podcastURLString = podcast.artworkUrl100
        guard let validImageAsString = self.podcastURLString else {
            return
        }
        
        podcastArtImageView.getImage(withURLString: validImageAsString) {[weak self] (result) in
            switch result{
            case .failure:
                DispatchQueue.main.async {
                    self?.podcastArtImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    if self?.podcastURLString == validImageAsString{
                        self?.podcastArtImageView.image = image
                    }
                }
            }
        }
        artistNameLabel.text = podcast.artistName
        collectionNameLabel.text = podcast.collectionName
        genresLabel.text = podcast.genres.joined(separator: ", ")
        
    }
    
    func configureFavoritesCell(for favorites: GetFavoritesModel){
        self.favoritesURLString = favorites.artworkUrl600
        guard let validImageAsString = self.favoritesURLString else {
            return
        }
        
        favoritesImageView.getImage(withURLString: validImageAsString) {[weak self] (result) in
            switch result{
            case .failure:
                DispatchQueue.main.async {
                    self?.favoritesImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    if self?.favoritesURLString == validImageAsString{
                        self?.favoritesImageView.image = image
                    }
                }
            }
        }
        favoriteCollectionLabel.text = favorites.collectionName
        
    }

}
