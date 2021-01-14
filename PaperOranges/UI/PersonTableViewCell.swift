//
//  PersonTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/13/21.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
	var roundImage: UIImage? {
		didSet {
			roundImageView.image = roundImage
		}
	}

	var role: String? {
		didSet {
			roleLabel.text = role?.uppercased()
		}
	}

	var details: String? {
		didSet {
			detailsLabel.text = details
		}
	}

	private var borderedView: UIView = {
		let view = UIView()
		view.layer.borderColor = UIColor.borderColor.cgColor
		view.layer.borderWidth = 1
		view.layer.cornerRadius = 16
		view.clipsToBounds = true
		view.backgroundColor = .white
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private var roundImageView: RoundImageView = {
		let imageView = RoundImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private var roleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 12)
		label.textColor = .accentColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private var detailsLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .backgroundColor

		contentView.addSubview(borderedView)
		borderedView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		borderedView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		contentView.bottomAnchor.constraint(equalTo: borderedView.bottomAnchor, constant: 8).isActive = true
		contentView.rightAnchor.constraint(equalTo: borderedView.rightAnchor, constant: 16).isActive = true

		borderedView.addSubview(roundImageView)
		roundImageView.topAnchor.constraint(equalTo: borderedView.topAnchor, constant: 8).isActive = true
		roundImageView.leftAnchor.constraint(equalTo: borderedView.leftAnchor, constant: 16).isActive = true
		borderedView.bottomAnchor.constraint(greaterThanOrEqualTo: roundImageView.bottomAnchor, constant: 8).isActive = true
		roundImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
		roundImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true

		borderedView.addSubview(roleLabel)
		roleLabel.topAnchor.constraint(equalTo: borderedView.topAnchor, constant: 8).isActive = true
		roleLabel.leftAnchor.constraint(equalTo: roundImageView.rightAnchor, constant: 8).isActive = true
		borderedView.rightAnchor.constraint(equalTo: roleLabel.rightAnchor, constant: 16).isActive = true

		borderedView.addSubview(detailsLabel)
		detailsLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 4).isActive = true
		detailsLabel.leftAnchor.constraint(equalTo: roundImageView.rightAnchor, constant: 8).isActive = true
		borderedView.bottomAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 8).isActive = true
		borderedView.rightAnchor.constraint(equalTo: detailsLabel.rightAnchor, constant: 16).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

