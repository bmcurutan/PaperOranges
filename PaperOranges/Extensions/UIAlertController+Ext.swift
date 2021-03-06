//
//  UIAlertController+Ext.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/15/21.
//

import UIKit

extension UIAlertController {
    func setAttributedTitle(font: UIFont = UIFont.systemFont(ofSize: 14), color: UIColor = .primaryTextColor) {
        guard let title = title else { return }
        var attributedText = NSMutableAttributedString(string: title)
        attributedText = attributedText.setFont(font)
        attributedText = attributedText.setTextColor(color)
        setValue(attributedText, forKey: "attributedTitle")
    }
}
