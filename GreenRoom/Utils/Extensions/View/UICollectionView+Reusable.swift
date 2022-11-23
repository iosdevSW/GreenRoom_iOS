//
//  UICollectionView+Reusable.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/23.
//

import UIKit

extension UICollectionView {
    func register<T>(_ cellClass: T.Type) where T: UICollectionReusableView {
        self.register(cellClass.self, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeueCell<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? where T: UICollectionReusableView {
        return self.dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T
    }
    
    func dequeReusableView<T>(_ headerClass: T.Type, for indexPath: IndexPath) -> T? where T: UICollectionReusableView {
        return self.dequeueReusableSupplementaryView(ofKind: headerClass.reuseIdentifier, withReuseIdentifier: headerClass.reuseIdentifier, for: indexPath) as? T
    }
}

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
