//
//  NetworkProvider.swift
//  YRestaurants
//
//  Created by Vladimir Svetlanov on 02/11/2018.
//  Copyright © 2018 Svetlanov Vladimir. All rights reserved.
//

import Foundation

protocol NetworkProviderProtocol {
    func getRestaurants(onSuccess: ((RestaurantsResponse) -> Void)?,
                        onError: ((Error) -> Void)?)
}

class NetworkProvider {
    enum NetworkError: Error {
        case incorrectUrl
        case dataNotExists
    }
    
    enum EndPoint: String {
        case restaurants = "/api/v2/catalog"
    }
    
    private var baseUrl: URL
    
    init(baseUrl: URL = AppConstants.baseUrl) {
        self.baseUrl = baseUrl
    }
}

extension NetworkProvider: NetworkProviderProtocol {
    func getRestaurants(onSuccess: ((RestaurantsResponse) -> Void)? = nil,
                        onError: ((Error) -> Void)? = nil) {
        let endPointUrl = baseUrl.appendingPathComponent(EndPoint.restaurants.rawValue)
        var urlComponents = URLComponents(url: endPointUrl, resolvingAgainstBaseURL: false)
        let latItem = URLQueryItem(name: "latitude", value: "55.762885")
        let lngItem = URLQueryItem(name: "longitude", value: "37.597360")
        urlComponents?.queryItems = [latItem, lngItem]
        guard let url = urlComponents?.url else {
            onError?(NetworkError.incorrectUrl)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onError?(error)
                return
            }
            
            guard let data = data else {
                onError?(NetworkError.dataNotExists)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(RestaurantsResponse.self, from: data)
                onSuccess?(response)
            } catch {
                onError?(error)
            }
        }.resume()
    }
}
