//
//  HeroView.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/11/21.
//

import UIKit

// TODO convert this outright into a table view cell?
class HeroView: UIView {
	var image: UIImage? {
		didSet {
			imageView.image = image
		}
	}

	var title: String? {
		didSet {
			titleLabel.text = title?.uppercased()
		}
	}

	private var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.heightAnchor.constraint(equalToConstant: 129).isActive = true // TODO screen math
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

	init(title: String?, image: UIImage?) {
		self.init()
		titleLabel.text = title?.uppercased()
		imageView.image = image
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(imageView)
		imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
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
