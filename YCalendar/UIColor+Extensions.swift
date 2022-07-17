//
//  UIColor+Extensions.swift
//  YCalendar
//
//  Created by Archie on 2022/7/17.
//

import UIKit

extension UIColor {
    class var randomColor: UIColor {
        return UIColor(red: ((CGFloat)(arc4random() % 256)) / 255.0, green: ((CGFloat)(arc4random() % 256)) / 255.0, blue: ((CGFloat)(arc4random() % 256)) / 255.0, alpha: 1.0)
    }
}
