//
//  UITableViewExtension.swift
//  YRestaurants
//
//  Created by Vladimir Svetlanov on 02/11/2018.
//  Copyright © 2018 Svetlanov Vladimir. All rights reserved.
//

import UIKit

public extension UITableView {
    func registerCellFromClass<T: UITableViewCell>(_: T.Type) {
        let cellName = String(describing: T.self)
        self.register(T.self, forCellReuseIdentifier: cellName)
    }
    
    func registerCellFromNib<T: UITableViewCell>(_: T.Type) {
        let cellName = String(describing: T.self)
        self.register(UINib(nibName: cellName, bundle: Bundle(for: T.self)), forCellReuseIdentifier: cellName)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        let cellName = String(describing: T.self)
        return self.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! T
    }
}
