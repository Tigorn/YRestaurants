//
//  NukeAdapter.swift
//  YRestaurants
//
//  Created by Vladimir Svetlanov on 02/11/2018.
//  Copyright © 2018 Svetlanov Vladimir. All rights reserved.
//

import Foundation
import Nuke

class NukeAdapter: ImageProviderAdapter {
    
    private var imageTasks: [ImageTask] = []
    
    // MARK: ImageProviderAdapter
    func clearCache(completion: @escaping () -> Void) {
        ImageCache.shared.removeAll()
        completion()
    }
    
    func cancelAllTasks() {
        imageTasks.forEach({ $0.cancel() })
        imageTasks.removeAll()
    }
    
    func getImage(from url: URL, completion: @escaping (_ image: UIImage?, _ error: Error?, _ url: URL?) -> Void) {
        let task = ImagePipeline.shared.loadImage(with: url, progress: nil) { (response, error) in
            completion(response?.image, error, url)
        }
        imageTasks.append(task)
    }
}
