//
//  KingfisherAdapter.swift
//  YRestaurants
//
//  Created by Vladimir Svetlanov on 02/11/2018.
//  Copyright © 2018 Svetlanov Vladimir. All rights reserved.
//

import Foundation
import Kingfisher

class KingfisherAdapter: ImageProviderAdapter {
    
    // MARK: ImageProviderAdapter
    func clearCache(completion: @escaping () -> Void) {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache(completion: completion)
    }
    
    func cancelAllTasks() {
        KingfisherManager.shared.downloader.cancelAll()
    }
    
    func getImage(from url: URL, completion: @escaping (_ image: UIImage?, _ error: Error?, _ url: URL?) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { (image, error, _, url) in
            completion(image, error, url)
        }
    }
}
