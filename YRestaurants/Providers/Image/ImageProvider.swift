//
//  ImageProvider.swift
//  YRestaurants
//
//  Created by Vladimir Svetlanov on 02/11/2018.
//  Copyright © 2018 Svetlanov Vladimir. All rights reserved.
//

import UIKit

protocol ImageProviderProtocol {
    func clearCache(for type: ImageProviderType, completion: @escaping () -> Void)
    func cancelAllTasks(for type: ImageProviderType)
    func getImage(via type: ImageProviderType, from uri: String, withSize size: CGSize, completion: @escaping (UIImage?, Error?, URL?) -> Void)
}

class ImageProvider {
    private var baseUrl: URL
    
    private lazy var kingfisherProvider = KingfisherAdapter()
    private lazy var nukeProvider = NukeAdapter()
    private lazy var sdWebImageProvider = SDWebImageAdapter()
    
    init(baseUrl: URL = AppConstants.baseUrl) {
        self.baseUrl = baseUrl
    }
    
    private func getProvider(for type: ImageProviderType) -> ImageProviderAdapter {
        switch type {
        case .kingfisher: return kingfisherProvider
        case .nuke: return nukeProvider
        case .sdWebImage: return sdWebImageProvider
        }
    }
}

extension ImageProvider: ImageProviderProtocol {
    func clearCache(for type: ImageProviderType, completion: @escaping () -> Void) {
        getProvider(for: type).clearCache(completion: completion)
    }
    
    func cancelAllTasks(for type: ImageProviderType) {
        getProvider(for: type).cancelAllTasks()
    }
    
    func getImage(via type: ImageProviderType, from uri: String, withSize size: CGSize, completion: @escaping (UIImage?, Error?, URL?) -> Void) {
        var sizedUri = uri.replacingOccurrences(of: "{w}", with: String(Int(size.width)))
        sizedUri = sizedUri.replacingOccurrences(of: "{h}", with: String(Int(size.height)))
        getProvider(for: type).getImage(from: baseUrl.appendingPathComponent(sizedUri), completion: completion)
    }
}
