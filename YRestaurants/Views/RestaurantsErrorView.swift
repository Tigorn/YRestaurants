//
//  RestaurantsErrorView.swift
//  YRestaurants
//
//  Created by Vladimir Svetlanov on 02/11/2018.
//  Copyright © 2018 Svetlanov Vladimir. All rights reserved.
//

import UIKit

class RestaurantsErrorView: UIView {
    
    lazy var container: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        return view
    }()
    
    lazy var title: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var button: UIButton = {
        let view = UIButton()
        view.setTitleColor(.black, for: .normal)
        view.addTarget(self, action: #selector(self.didClickButton(sender:)), for: .touchUpInside)
        return view
    }()
    
    typealias OnButtonClickHandler = (UIButton) -> Void
    var onButtonClick: OnButtonClickHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(container)
        container.addArrangedSubview(title)
        container.addArrangedSubview(button)
    }
    
    private func addConstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(greaterThanOrEqualTo: topAnchor).isActive = true
        container.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor).isActive = true
        container.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        container.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
        centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
    }
    
    @objc
    private func didClickButton(sender: UIButton) {
        onButtonClick?(sender)
    }
}
