//
//  RestaurantsView.swift
//  YRestaurants
//
//  Created by Vladimir Svetlanov on 02/11/2018.
//  Copyright © 2018 Svetlanov Vladimir. All rights reserved.
//

import UIKit

protocol RestaurantsViewDelegate: UITableViewDelegate {
    func didClickReloadButton()
}

protocol RestaurantsViewDataSource: UITableViewDataSource {
}

class RestaurantsView: UIView {
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.allowsSelection = false
        return view
    }()
    
    lazy var emptyView: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var errorView: RestaurantsErrorView = {
        let view = RestaurantsErrorView()
        view.onButtonClick = { [weak self] _ in
            self?.delegate?.didClickReloadButton()
        }
        return view
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .gray
        return view
    }()
    
    weak var delegate: RestaurantsViewDelegate? { didSet { tableView.delegate = delegate } }
    weak var dataSource: RestaurantsViewDataSource? { didSet { tableView.dataSource = dataSource } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func showEmptyView(description: String) {
        show(view: emptyView)
        emptyView.text = description
    }
    
    func showLoading() {
        show(view: loadingView)
        loadingView.startAnimating()
    }
    
    func showError(description: String, action: String) {
        show(view: errorView)
        errorView.title.text = description
        errorView.button.setTitle(action, for: .normal)
    }
    
    func showTable() {
        show(view: tableView)
    }
    
    private func setup() {
        backgroundColor = .white
        addSubviews()
    }
    
    private func addSubviews() {
        addSubviewWithEqualConstraints(tableView)
        addSubviewWithEqualConstraints(emptyView)
        addSubviewWithEqualConstraints(errorView)
        addSubviewWithEqualConstraints(loadingView)
    }
    
    private func addSubviewWithEqualConstraints(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func show(view: UIView) {
        subviews.forEach { $0.isHidden = (view != $0) }
    }
}
