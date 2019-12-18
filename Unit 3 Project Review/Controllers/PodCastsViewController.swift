//
//  ViewController.swift
//  Unit 3 Project Review
//
//  Created by Bienbenido Angeles on 12/16/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import UIKit

class PodCastsViewController: UIViewController {
    
    @IBOutlet weak var podcastSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var podcasts = [Podcast](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(query: "")
        delegates()
        dataSources()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let podCastDVC = segue.destination as? PodcastsDetailViewController, let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("failed to segue to destination controller")
        }
        
        let podcast = podcasts[indexPath.row]
        podCastDVC.passedObj = podcast
        
    }
    
    func loadData(query: String){
        PodcastAPIClient.getPodCast(searchQuery: query) {[weak self] (result) in
            switch result{
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "FAILED TO LOAD DATA", message: "\(appError)")
                }
            case .success(let podCasts):
                self?.podcasts = podCasts
            }
        }
    }
    
    func delegates(){
        tableView.dataSource = self
    }
    
    func dataSources(){
        podcastSearchBar.delegate = self
    }
}

extension PodCastsViewController: UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "podcastCell", for: indexPath) as? PodCastCell else {
            fatalError("failed to deque cell")
        }
        let podCast = podcasts[indexPath.row]
        cell.configureCell(for: podCast)
        return cell
    }
}

extension PodCastsViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text else {
            showAlert(title: "Warning", message: "Missing search query")
            return
        }
        loadData(query: query)
    }
}
