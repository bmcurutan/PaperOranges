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
    // Currently only adds tooltip below `view`
    func addTooltip(with view: UIView, text: String) {
        let tooltip = Tooltip()
        tooltip.text = text
        tooltip.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tooltip)
        tooltip.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        rightAnchor.constraint(equalTo: tooltip.rightAnchor, constant: 8).isActive = true

        let line = UIView()
        line.backgroundColor = .tooltipBackgroundColor
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)
        tooltip.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: line.rightAnchor, constant: 14).isActive = true
        line.widthAnchor.constraint(equalToConstant: 2).isActive = true
        line.heightAnchor.constraint(equalToConstant: 8).isActive = true
    }
}
