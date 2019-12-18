//
//  AppError.swift
//  Unit 3 Project Review
//
//  Created by Bienbenido Angeles on 12/16/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import Foundation

enum AppError: Error{
    case badURL(String)
    case networkClientError(Error)
    case noResponse
    case noData
    case badStatusCode(Int)
    case badMimeType(String)
    case decodingError(Error)
    case encodingError(Error)
}
