//
//  NetworkHelper.swift
//  Unit 3 Project Review
//
//  Created by Bienbenido Angeles on 12/16/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import Foundation

struct NetworkHelper {
    static let shared = NetworkHelper()
    private var session: URLSession
    private init(){
        session = URLSession(configuration: .default)
    }
    
    func performDataTask(with request: URLRequest, completion: @escaping (Result<Data, AppError>)->()){
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            //if there is an error, show it
            if let error = error{
                completion(.failure(.networkClientError(error)))
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse else{
                completion(.failure(.noResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            switch urlResponse.statusCode {
            case 200...299:
                break
            default:
                completion(.failure(.badStatusCode(urlResponse.statusCode)))
            }
            
            completion(.success(data))
        }
        
        dataTask.resume()
    }
}
