//
//  UIViewExt.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/11/21.
//

import UIKit

extension UIView {
	func addVerticalGradient(alpha: CGFloat = 0.6) {
		if let _ = layer.sublayers?.first as? CAGradientLayer {
			return
		}

		let gradient = CAGradientLayer()
		gradient.frame = bounds
		gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(alpha).cgColor]
		gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
		gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
		layer.insertSublayer(gradient, at: 0)
	  }
}
