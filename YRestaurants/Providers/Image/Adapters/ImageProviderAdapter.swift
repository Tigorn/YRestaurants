//
//  ImageProviderAdapter.swift
//  YRestaurants
//
//  Created by Vladimir Svetlanov on 02/11/2018.
//  Copyright © 2018 Svetlanov Vladimir. All rights reserved.
//

import UIKit

protocol ImageProviderAdapter {
    func clearCache(completion: @escaping () -> Void)
    func cancelAllTasks()
    func getImage(from url: URL, completion: @escaping (_ image: UIImage?, _ error: Error?, _ url: URL?) -> Void)
}
