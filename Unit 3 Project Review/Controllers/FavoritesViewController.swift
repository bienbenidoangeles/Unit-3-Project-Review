//
//  FavoritesViewController.swift
//  Unit 3 Project Review
//
//  Created by Bienbenido Angeles on 12/17/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    private var refreshControl: UIRefreshControl!
    
    var favorites = [Podcast](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
        datasources()
        configureRefreshControl()
    }
    
    func configureRefreshControl(){
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    func datasources(){
        tableView.dataSource = self
    }
    
    @objc
    func loadData(){
        PodcastAPIClient.getPodcast{[weak self] (result) in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
            switch result{
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "FAILED TO LOAD DATA", message: "\(appError)")
                }
                
            case .success(let favorites):
                self?.favorites = favorites.filter{$0.favoritedBy == "B.A."}
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? PodcastsDetailViewController, let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("failed to segue")
        }
        let favorite = favorites[indexPath.row]
        detailVC.passedObj = favorite
    }
}

extension FavoritesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? PodCastCell else {
            fatalError("failedtoDeque")
        }
        let favorite = favorites[indexPath.row]
        cell.configureFavoritesCell(for: favorite)
        return cell
    }
    
    
}
