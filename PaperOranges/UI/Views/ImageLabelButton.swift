//
//  ImageLabelButton.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/10/21.
//

import UIKit

protocol ImageLabelButtonDelegate {
	func imageLabelButtonTapped(_ sender: ImageLabelButton)
}

class ImageLabelButton: UIButton {
	var delegate: ImageLabelButtonDelegate?
	
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
                backgroundColor = UIColor.backgroundColor.withAlphaComponent(0.4)
			}
		}
	}

	private var roundImageView: RoundImageView = {
		let imageView = RoundImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private var nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 14)
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.textAlignment = .center
		label.textColor = .primaryButtonColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		layer.cornerRadius = 16
		layer.masksToBounds = true
        backgroundColor = UIColor.backgroundColor.withAlphaComponent(0.4)
		setBackgroundImage(UIImage.withColor(UIColor.highlightColor.withAlphaComponent(0.4)), for: .highlighted)

		addSubview(roundImageView)
		roundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		roundImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		roundImageView.widthAnchor.constraint(equalToConstant: 56).isActive = true
		roundImageView.heightAnchor.constraint(equalToConstant: 56).isActive = true

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
		delegate?.imageLabelButtonTapped(self)
	}

	// Create copy for UI purposes (doesn't have tap functionality)
	func createCopy() -> ImageLabelButton {
		let button = ImageLabelButton()
		button.image = image
		button.name = name
		button.isSelected = isSelected
		return button
	}

	func copyData(from button: ImageLabelButton) {
		image = button.image
		name = button.name
		// Doesn't include isSelected state
	}
}
