//
//  UICollectionView+Extensions.swift
//  YCalendar
//
//  Created by 尤坤 on 2022/7/18.
//

import UIKit

extension UICollectionView {
    func reloadLayout() {
        let layout = collectionViewLayout
        setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
        layoutSubviews()
        setCollectionViewLayout(layout, animated: false)
    }
}
