//
//  UIAlertController+Ext.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/15/21.
//

import UIKit

extension UIAlertController {
    convenience init(with userInterfaceStyle: UIUserInterfaceStyle = .light, title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        var textColor: UIColor = .primaryTextColor
        if userInterfaceStyle == .dark {
            textColor = .white
        }
        setAttributedTitle(color: textColor)
        view.tintColor = .accentColor
        addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
    }

    private func setAttributedTitle(font: UIFont = UIFont.systemFont(ofSize: 14), color: UIColor = .primaryTextColor) {
        guard let title = title else { return }
        var attributedText = NSMutableAttributedString(string: title)
        attributedText = attributedText.setFont(font)
        attributedText = attributedText.setTextColor(color)
        setValue(attributedText, forKey: "attributedTitle")
    }
}
