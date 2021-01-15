//
//  HeroView.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/11/21.
//

import UIKit

class HeroView: UIView {
	private var handleBar: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 2
		view.backgroundColor = .borderColor
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.heightAnchor.constraint(equalToConstant: 136).isActive = true
		return imageView
	}()

	private var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 14.0)
		label.textAlignment = .right
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	init(image: UIImage, title: String?) {
		self.init()
		imageView.image = image
		if let title = title {
			titleLabel.text = title.uppercased()
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .backgroundColor

		addSubview(handleBar)
		handleBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
		handleBar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		handleBar.widthAnchor.constraint(equalToConstant: 32).isActive = true
		handleBar.heightAnchor.constraint(equalToConstant: 4).isActive = true

		addSubview(imageView)
		imageView.topAnchor.constraint(equalTo: handleBar.bottomAnchor, constant: 8).isActive = true
		imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
		rightAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true

		imageView.addSubview(titleLabel)
		titleLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 8).isActive = true
		imageView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
		imageView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 8).isActive = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		imageView.addVerticalGradient()
	}
}
