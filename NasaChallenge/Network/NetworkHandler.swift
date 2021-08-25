//
//  NetworkHandler.swift
//  NasaChallenge
//
//  Created by Zakhia Damaree on 25/08/2021.
//  Copyright © 2021 Zakhia Damaree. All rights reserved.
//

import Foundation
import Combine

protocol NetworkHandler {
    func fetchData<Result: Codable>(_ type: Result.Type, urlString: String) -> AnyPublisher<Result, NetworkError>
}
