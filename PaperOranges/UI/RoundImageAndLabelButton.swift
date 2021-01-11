//
//  RoundImageAndLabelButton.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/10/21.
//

import UIKit

protocol RoundImageAndLabelButtonDelegate {
	func buttonTapped(_ sender: RoundImageAndLabelButton)
}

class RoundImageAndLabelButton: UIButton {
	var delegate: RoundImageAndLabelButtonDelegate?
	
	var image: UIImage? {
		didSet {
			roundImageView.image = image
		}
	}

	var name: String? {
		didSet {
			nameLabel.text = name
		}
	}

	override var isSelected: Bool {
		didSet {
			if isSelected {
				backgroundColor = UIColor.highlightColor.withAlphaComponent(0.4)
			} else {
				backgroundColor = .clear
			}
		}
	}

	private var roundImageView: RoundedImageView = {
		let imageView = RoundedImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.widthAnchor.constraint(equalToConstant: 56).isActive = true // TODO math
		imageView.heightAnchor.constraint(equalToConstant: 56).isActive = true // TODO math
		return imageView
	}()

	private var nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 14.0)
		label.textAlignment = .center
		label.textColor = .primaryButtonColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		layer.cornerRadius = 16
		clipsToBounds = true

		addSubview(roundImageView)
		roundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		roundImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

		addSubview(nameLabel)
		nameLabel.topAnchor.constraint(equalTo: roundImageView.bottomAnchor, constant: 8).isActive = true
		nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
		bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		rightAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 8).isActive = true

		addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc private func buttonTapped() {
		isSelected = !isSelected
		delegate?.buttonTapped(self)
	}

	// Create copy for UI purposes (doesn't have tap functionality)
	func createCopy() -> RoundImageAndLabelButton {
		let button = RoundImageAndLabelButton()
		button.image = image
		button.name = name
		button.isSelected = isSelected
		return button
	}

	func copyData(from button: RoundImageAndLabelButton) {
		image = button.image
		name = button.name
		// Doesn't include isSelected state
	}
}
