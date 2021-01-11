//
//  SAConfettiView+Ext.swift
//  PaperOranges
//
//  Created by Sudeep Agarwal on 12/14/15.
//  https://github.com/sudeepag/SAConfettiView
//

import UIKit
import QuartzCore

public class SAConfettiView: UIView {
	var emitter = CAEmitterLayer()

	public var colors: [UIColor] = [.accentColor, .secondaryAccentColor, .primaryButtonColor, .highlightColor]
	public var intensity: Float = 0.8
	private var active: Bool = false

	public func startConfetti() {
		emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
		emitter.emitterShape = CAEmitterLayerEmitterShape.line
		emitter.emitterSize = CGSize(width: frame.size.width, height: 1)

		var cells = [CAEmitterCell]()
		for color in colors {
			cells.append(confetti(with: color))
		}

		emitter.emitterCells = cells
		layer.addSublayer(emitter)
		active = true
	}

	public func stopConfetti() {
		emitter.birthRate = 0.0
		active = false
	}

	func confetti(with color: UIColor) -> CAEmitterCell {
		let confetti = CAEmitterCell()
		confetti.birthRate = 6.0 * intensity
		confetti.lifetime = 14.0 * intensity
		confetti.lifetimeRange = 0
		confetti.color = color.cgColor
		confetti.velocity = CGFloat(350.0 * intensity)
		confetti.velocityRange = CGFloat(80.0 * intensity)
		confetti.emissionLongitude = CGFloat(Double.pi)
		confetti.emissionRange = CGFloat(Double.pi)
		confetti.spin = CGFloat(3.5 * intensity)
		confetti.spinRange = CGFloat(4.0 * intensity)
		confetti.scaleRange = CGFloat(intensity)
		confetti.scaleSpeed = CGFloat(-0.1 * intensity)
		confetti.contents = #imageLiteral(resourceName: "confetti").cgImage
		return confetti
	}

	public func isActive() -> Bool {
		return self.active
	}
}
