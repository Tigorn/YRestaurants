//
//  RestaurantsViewController.swift
//  YRestaurants
//
//  Created by Vladimir Svetlanov on 02/11/2018.
//  Copyright © 2018 Svetlanov Vladimir. All rights reserved.
//

import UIKit

protocol RestaurantsViewControllerProtocol: class {
    var title: String? { get set }
    func display(state: RestaurantsViewController.State)
    func displayImageProviderChooser(title: String, items: [String])
    func displayClearCacheChooser(title: String, items: [String])
    func setImage(_ image: UIImage?, error: Error?, for uri: String)
    func reloadVisibleCells()
}

class RestaurantsViewController: UIViewController, RestaurantsViewDataSource, RestaurantsViewDelegate {
    
    enum State {
        case loading
        case result([RestaurantViewModel])
        case emptyResult(description: String)
        case error(description: String, action: String)
    }
    private var state: State
    private let interactor: RestaurantsInteractorProtocol
    
    private lazy var customView = self.view as? RestaurantsView
    private lazy var chooseProviderButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.didClickChooseProviderBarButton))
        return button
    }()
    private lazy var clearCacheButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.didClickClearCacheBarButton))
        return button
    }()
    
    init(interactor: RestaurantsInteractorProtocol,
         initialState: State = .loading) {
        self.interactor = interactor
        self.state = initialState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = RestaurantsView(frame: UIScreen.main.bounds)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCustomView()
        updateTitle()
        loadData()
    }
    
    private func configureNavigationBar() {
        navigationItem.setLeftBarButton(chooseProviderButton, animated: false)
        navigationItem.setRightBarButton(clearCacheButton, animated: false)
    }
    
    private func configureCustomView() {
        customView?.tableView.registerCellFromNib(RestaurantsCell.self)
        customView?.tableView.estimatedRowHeight = RestaurantsCell.Constants.estimatedHeight
        customView?.tableView.rowHeight = UITableView.automaticDimension
        customView?.dataSource = self
        customView?.delegate = self
    }
    
    private func updateTitle() {
        interactor.setTitle()
    }
    
    private func loadData() {
        interactor.fetchItems()
    }
    
    @objc
    private func didClickChooseProviderBarButton() {
        interactor.chooseImageProvider()
    }
    
    @objc
    private func didClickClearCacheBarButton() {
        interactor.chooseProviderToClearCache()
    }
    
    // MARK: RestaurantsViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .result(let models): return models.count
        case .loading, .emptyResult, .error: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .result(let models):
            let model = models[indexPath.row]
            let cell = tableView.dequeueReusableCell(RestaurantsCell.self, for: indexPath)
            cell.nameLabel.text = model.name
            cell.descriptionLabel.text = model.description
            cell.pictureImageView.image = nil
            interactor.fetchImage(model.image, withSize: RestaurantsCell.Constants.imageSize)
            return cell
        case .loading, .emptyResult, .error: return UITableViewCell()
        }
    }
    
    // MARK: RestaurantsViewDelegate
    func didClickReloadButton() {
        loadData()
    }
}

extension RestaurantsViewController: RestaurantsViewControllerProtocol {
    func display(state: RestaurantsViewController.State) {
        self.state = state
        switch state {
        case .loading:
            customView?.showLoading()
        case .result:
            customView?.showTable()
            customView?.tableView.reloadData()
        case .emptyResult(let description):
            customView?.showEmptyView(description: description)
        case .error(let description, let action):
            customView?.showError(description: description, action: action)
        }
    }
    
    func displayImageProviderChooser(title: String, items: [String]) {
        displayActionSheet(title: title, withItems: items, from: chooseProviderButton) { [weak self] (selectedIndex) in
            self?.interactor.changeImageProvider(toProviderAtIndex: selectedIndex)
            self?.updateTitle()
        }
    }
    
    func displayClearCacheChooser(title: String, items: [String]) {
        displayActionSheet(title: title, withItems: items, from: clearCacheButton) { [weak self] (selectedIndex) in
            self?.interactor.clearImageCache(forProviderAtIndex: selectedIndex)
        }
    }
    
    func setImage(_ image: UIImage?, error: Error?, for uri: String) {
        switch state {
        case .result(let models):
            let modelsWithSuchUrl = models.enumerated().filter({ $0.element.image == uri })
            let indexPathsOfSuchModels = modelsWithSuchUrl.map({ IndexPath(row: $0.offset, section: 0) })
            let cellsOfSuchModels = indexPathsOfSuchModels.compactMap({ customView?.tableView.cellForRow(at: $0) as? RestaurantsCell })
            cellsOfSuchModels.forEach({ $0.pictureImageView.image = image })
        case .loading, .emptyResult, .error: return
        }
    }
    
    func reloadVisibleCells() {
        guard let indexPaths = customView?.tableView.indexPathsForVisibleRows else { return }
        customView?.tableView.reloadRows(at: indexPaths, with: .fade)
    }
    
    private func displayActionSheet(title: String, withItems items: [String], from sender: UIBarButtonItem, onSelect: ((Int) -> Void)? = nil) {
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        items.enumerated().forEach { (index, item) in
            let action = UIAlertAction(title: item, style: .default, handler: { (_) in
                onSelect?(index)
            })
            actionSheet.addAction(action)
        }
        actionSheet.popoverPresentationController?.barButtonItem = sender
        present(actionSheet, animated: true, completion: nil)
    }
}
