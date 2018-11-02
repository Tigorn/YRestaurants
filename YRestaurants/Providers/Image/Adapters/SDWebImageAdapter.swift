//
//  SDWebImageAdapter.swift
//  YRestaurants
//
//  Created by Vladimir Svetlanov on 02/11/2018.
//  Copyright © 2018 Svetlanov Vladimir. All rights reserved.
//

import Foundation
import SDWebImage

class SDWebImageAdapter: ImageProviderAdapter {
    
    // MARK: ImageProviderAdapter
    func clearCache(completion: @escaping () -> Void) {
        SDWebImageManager.shared().imageCache?.clearMemory()
        SDWebImageManager.shared().imageCache?.clearDisk(onCompletion: completion)
    }
    
    func cancelAllTasks() {
        SDWebImageManager.shared().cancelAll()
    }
    
    func getImage(from url: URL, completion: @escaping (_ image: UIImage?, _ error: Error?, _ url: URL?) -> Void) {
        SDWebImageManager.shared().loadImage(with: url, options: [], progress: nil) { (image, _, error, _, _, url) in
            completion(image, error, url)
        }
    }
}
