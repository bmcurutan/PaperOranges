//
//  UIViewExt.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/11/21.
//

import UIKit

extension UIView {
	func addVerticalGradient(alpha: CGFloat = 0.4) {
		if let _ = layer.sublayers?.first as? CAGradientLayer { return }
		let gradient = CAGradientLayer()
		gradient.frame = bounds
		gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(alpha).cgColor]
		gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
		gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
		layer.insertSublayer(gradient, at: 0)
	  }

    // TODO add bounce animation
    // Currently only adds tooltip below self
    func addTooltip(with text: String) -> Tooltip? {
        guard let superview = superview else { return nil }

        let tooltip = Tooltip()
        tooltip.text = text
        tooltip.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(tooltip)
        tooltip.topAnchor.constraint(equalTo: bottomAnchor, constant: 6).isActive = true
        tooltip.rightAnchor.constraint(equalTo: rightAnchor, constant: 8).isActive = true

        let line = UIView()
        line.backgroundColor = .tooltipBackgroundColor
        line.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(line)

        tooltip.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: line.rightAnchor, constant: 8).isActive = true
        line.widthAnchor.constraint(equalToConstant: 2).isActive = true
        line.heightAnchor.constraint(equalToConstant: 6).isActive = true
        return tooltip
    }
}
