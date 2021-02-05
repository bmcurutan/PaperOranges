//
//  RoundedButton.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/13/21.
//

import UIKit

class RoundedButton: UIButton {
	override init(frame: CGRect) {
		super.init(frame: frame)

		layer.borderColor = UIColor.primaryButtonColor.cgColor
		layer.borderWidth = 1
		layer.cornerRadius = 16
		layer.masksToBounds = true
		contentHorizontalAlignment = .left
		// 76 = padding + image + padding
		// 56 = padding + icon + padding
		titleEdgeInsets = UIEdgeInsets(top: 0, left: 76, bottom: 0, right: 52)
		titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
		titleLabel?.lineBreakMode = .byWordWrapping
		titleLabel?.numberOfLines = 0
		setBackgroundImage(UIImage.withColor(UIColor.primaryButtonColor), for: .highlighted)
		setTitleColor(.primaryButtonColor, for: .normal)
		setTitleColor(.white, for: .highlighted)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
