//
//  RestaurantsInteractor.swift
//  YRestaurants
//
//  Created by Vladimir Svetlanov on 02/11/2018.
//  Copyright © 2018 Svetlanov Vladimir. All rights reserved.
//

import UIKit

protocol RestaurantsInteractorProtocol {
    func fetchItems()
    func fetchImage(_ uri: String, withSize size: CGSize)
    func setTitle()
    func chooseImageProvider()
    func changeImageProvider(toProviderAtIndex index: Int)
    func chooseProviderToClearCache()
    func clearImageCache(forProviderAtIndex index: Int)
}

class RestaurantsInteractor {
    let presenter: RestaurantsPresenterProtocol
    let networkProvider: NetworkProviderProtocol
    let imageProvider: ImageProviderProtocol
    private var selectedImageProviderType: ImageProviderType
    
    init(presenter: RestaurantsPresenterProtocol,
         networkProvider: NetworkProviderProtocol = NetworkProvider(),
         imageProvider: ImageProviderProtocol = ImageProvider(),
         imageProviderType: ImageProviderType = .kingfisher) {
        self.presenter = presenter
        self.networkProvider = networkProvider
        self.imageProvider = imageProvider
        self.selectedImageProviderType = imageProviderType
    }
}

extension RestaurantsInteractor: RestaurantsInteractorProtocol {
    func fetchItems() {
        presenter.presentLoading()
        networkProvider.getRestaurants(onSuccess: { [weak self] (response) in
            let models = response.foundPlaces.map({
                return RestaurantModel(image: $0.place.picture,
                                       name: $0.place.name,
                                       description: $0.place.description)
            })
            DispatchQueue.main.async {
                self?.presenter.presentItems(models)
            }
        }) { [weak self] (error) in
            DispatchQueue.main.async {
                self?.presenter.presentError(error)
            }
        }
    }
    
    func fetchImage(_ uri: String, withSize size: CGSize) {
        imageProvider.getImage(via: selectedImageProviderType, from: uri, withSize: size) { [weak self] (image, error, _) in
            DispatchQueue.main.async {
                self?.presenter.setImage(image, error: error, for: uri)
            }
        }
    }
    
    func setTitle() {
        presenter.presentImageProviderTitle(selectedImageProviderType.rawValue)
    }
    
    func chooseImageProvider() {
        presenter.presentImageProviderChooser(getImageProvidersTypesNames())
    }
    
    func changeImageProvider(toProviderAtIndex index: Int) {
        let newProvider = getImageProvider(at: index)
        guard self.selectedImageProviderType != newProvider else { return }
        
        imageProvider.cancelAllTasks(for: self.selectedImageProviderType)
        self.selectedImageProviderType = newProvider
        presenter.reloadVisibleCells()
    }
    
    func chooseProviderToClearCache() {
        presenter.presentClearCacheChooser(getImageProvidersTypesNames())
    }
    
    func clearImageCache(forProviderAtIndex index: Int) {
        let providerToClear = getImageProvider(at: index)
        imageProvider.clearCache(for: providerToClear, completion: { [weak self] in
            if providerToClear == self?.selectedImageProviderType {
                self?.presenter.reloadVisibleCells()
            }
        })
    }
    
    private func getImageProvidersTypesNames() -> [String] {
        return ImageProviderType.allCases.map({ $0.rawValue })
    }
    
    private func getImageProvider(at index: Int) -> ImageProviderType {
        return ImageProviderType.allCases[index]
    }
}
