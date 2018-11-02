//
//  RestaurantsPresenter.swift
//  YRestaurants
//
//  Created by Vladimir Svetlanov on 02/11/2018.
//  Copyright © 2018 Svetlanov Vladimir. All rights reserved.
//

import UIKit

protocol RestaurantsPresenterProtocol {
    func presentLoading()
    func presentItems(_ items: [RestaurantModel])
    func presentError(_ error: Error)
    func presentImageProviderChooser(_ items: [String])
    func presentImageProviderTitle(_ title: String)
    func presentClearCacheChooser(_ items: [String])
    func setImage(_ image: UIImage?, error: Error?, for uri: String)
    func reloadVisibleCells()
}

class RestaurantsPresenter {
    weak var viewController: RestaurantsViewControllerProtocol?
}

extension RestaurantsPresenter: RestaurantsPresenterProtocol {
    func presentLoading() {
        viewController?.display(state: .loading)
    }
    
    func presentItems(_ items: [RestaurantModel]) {
        if items.isEmpty {
            viewController?.display(state: .emptyResult(description: "Nothing found"))
        } else {
            let viewModels = items.map({
                return RestaurantViewModel(image: $0.image,
                                           name: $0.name,
                                           description: $0.description)
            })
            viewController?.display(state: .result(viewModels))
        }
    }
    
    func presentError(_ error: Error) {
        viewController?.display(state: .error(description: error.localizedDescription, action: "Reload"))
    }
    
    func presentImageProviderChooser(_ items: [String]) {
        viewController?.displayImageProviderChooser(title: "Set Image Provider:", items: items)
    }
    
    func presentImageProviderTitle(_ title: String) {
        viewController?.title = title
    }
    
    func presentClearCacheChooser(_ items: [String]) {
        viewController?.displayClearCacheChooser(title: "Clear cache for:", items: items)
    }
    
    func setImage(_ image: UIImage?, error: Error?, for uri: String) {
        viewController?.setImage(image, error: error, for: uri)
    }
    
    func reloadVisibleCells() {
        viewController?.reloadVisibleCells()
    }
}
