//
//  Extensions.swift
//  My Weather
//
//  Created by Pavel
//

import UIKit

extension UIColor {
    static var customTextColor: UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ? .white : .black
        }
    }
    static var customBackgroundColor: UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ? .black : .systemGray4
        }
    }
    static var customCurrentPageIndicatorTintColor: UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ? .white : .black
        }
    }
}

extension UIView {
    func addTopBorder(with color: UIColor?, andHeight borderHeight: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.width, height: borderHeight)
        addSubview(border)
    }
    
    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = UIColor.customTextColor
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.height)
        addSubview(border)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
