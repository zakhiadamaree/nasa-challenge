//
//  NetworkManager.swift
//  NasaChallenge
//
//  Created by Zakhia Damaree on 19/08/2021.
//  Copyright © 2021 Zakhia Damaree. All rights reserved.
//

import Foundation
import Combine

class NetworkManager: NSObject, NetworkHandler {
    var delegate: NetworkManagerDelegate?
    private var session: URLSession?
    
    override init() {
        super.init()
        configureSession()
    }
    
    func fetchData<Result: Codable>(_ type: Result.Type, urlString: String) -> AnyPublisher<Result, NetworkError> {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601

        guard let session = self.session,
              let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidUrl)
                .eraseToAnyPublisher()
        }

        return session
            .dataTaskPublisher(for: url)
            .mapError { NetworkError.mapError($0) }
            .tryMap { response in
                if let httpUrlResponse = response.response as? HTTPURLResponse,
                   httpUrlResponse.statusCode != 200 {
                    throw NetworkError.mapErrorByStatusCode(httpUrlResponse.statusCode)
                }
                return response.data
            }
            .decode(type: Result.self, decoder: jsonDecoder)
            .mapError { NetworkError.mapError($0) }
            .eraseToAnyPublisher()
    }
    
    private func configureSession() {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 60
        
        session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
    }

}

// MARK: - NetworkManagerDelegate

protocol NetworkManagerDelegate {
    func taskIsWaitingForConnectivity()
}

// MARK: - URLSessionTaskDelegate

extension NetworkManager: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        delegate?.taskIsWaitingForConnectivity()
    }
}
