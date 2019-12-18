//
//  UIImageView+extensions.swift
//  Unit 3 Project Review
//
//  Created by Bienbenido Angeles on 12/16/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import UIKit

extension UIImageView{
    func getImage(withURLString: String, completion: @escaping (Result<UIImage, AppError>)->()){
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemGray
        activityIndicator.startAnimating()
        activityIndicator.center = center
        addSubview(activityIndicator)
        
        guard let url = URL(string: withURLString) else {
            completion(.failure(.badURL(withURLString)))
            return
        }
        
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) {[weak activityIndicator] (result) in
            DispatchQueue.main.async {
                activityIndicator?.stopAnimating()
            }
            switch result{
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                if let image = UIImage(data: data){
                    completion(.success(image))
                }
            }
        }
    }
}
