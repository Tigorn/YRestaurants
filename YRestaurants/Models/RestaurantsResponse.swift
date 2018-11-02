//
//  RestaurantResponse.swift
//  YRestaurants
//
//  Created by Vladimir Svetlanov on 02/11/2018.
//  Copyright © 2018 Svetlanov Vladimir. All rights reserved.
//

import Foundation

struct RestaurantsResponse: Decodable {
    
    struct FoundPlacesResponse: Decodable {
        
        struct PlaceResponse: Decodable {
            
            let name: String
            let description: String
            let picture: String
            
            enum CodingKeys: String, CodingKey {
                case name
                case description = "footerDescription"
                case picture
                case uri = "uri"
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                name = try container.decode(String.self, forKey: .name)
                description = try container.decode(String.self, forKey: .description)
                let picture = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .picture)
                self.picture = try picture.decode(String.self, forKey: .uri)
            }
        }
        
        let place: PlaceResponse
        
        enum CodingKeys: String, CodingKey {
            case place
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            place = try container.decode(PlaceResponse.self, forKey: .place)
        }
    }
    
    var foundPlaces: [FoundPlacesResponse]
    
    enum CodingKeys: String, CodingKey {
        case payload
        case foundPlaces
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let payload = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .payload)
        foundPlaces = try payload.decode([FoundPlacesResponse].self, forKey: .foundPlaces)
    }
}
