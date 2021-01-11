//
//  RoundedImageView.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/10/21.
//

import UIKit

class RoundedImageView: UIImageView {
	convenience init() {
		self.init(frame: .zero)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	override init(image: UIImage?) {
		super.init(image: image)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = (frame.width + frame.height) / 2 / 2 // Use half of the average
		clipsToBounds = true
	}
}
