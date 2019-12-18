//
//  PodcastAPIClient.swift
//  Unit 3 Project Review
//
//  Created by Bienbenido Angeles on 12/17/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import Foundation

struct PodcastAPIClient {
    static func getPodCast(searchQuery: String, completion: @escaping (Result<[Podcast],AppError>)->()){
        let searchQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let endPointURLString = "https://itunes.apple.com/search?media=podcast&limit=200&term=\(searchQuery)"
        guard let url = URL(string: endPointURLString) else {
            completion(.failure(.badURL(endPointURLString)))
            return
        }
        let urlRequest = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: urlRequest) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do{
                    let podcastsData = try JSONDecoder().decode(AppleSearchAPI.self, from: data)
                    let podcasts = podcastsData.results
                    completion(.success(podcasts))
                }catch{
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    static func postPodCast(favoritedPodcast: Podcast, completion: @escaping (Result<Bool ,AppError>)->()){
        let endPointURLString = "https://5c2e2a592fffe80014bd6904.mockapi.io/api/v1/favorites"
        guard let url = URL(string: endPointURLString) else {
            completion(.failure(.badURL(endPointURLString)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let data = try JSONEncoder().encode(favoritedPodcast)
            request.httpBody = data
            NetworkHelper.shared.performDataTask(with: request) { (result) in
                switch result{
                case .failure(let appError):
                    completion(.failure(.networkClientError(appError)))
                case .success:
                    completion(.success(true))
                }
            }
        }catch{
            completion(.failure(.encodingError(error)))
        }
    }
    
    static func getPodcast(completion: @escaping (Result<[Podcast] ,AppError>)->()){
        let endPointURLString = "https://5c2e2a592fffe80014bd6904.mockapi.io/api/v1/favorites"
        guard let url = URL(string: endPointURLString) else {
            completion(.failure(.badURL(endPointURLString)))
            return
        }
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do{
                    let favoritedPodcasts = try JSONDecoder().decode([Podcast].self, from: data)
                    completion(.success(favoritedPodcasts))
                } catch {
                    
                }
            }
        }
    }
}
