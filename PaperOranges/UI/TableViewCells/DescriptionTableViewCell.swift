//
//  DescriptionTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/13/21.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
	var title: String? {
		didSet {
			titleLabel.text = title?.uppercased()
		}
	}

	var descriptionText: String? {
		didSet {
			descriptionLabel.text = descriptionText
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

	private var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 12)
		label.textColor = .accentColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private var descriptionLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
        label.textColor = .primaryTextColor
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

		borderedView.addSubview(titleLabel)
		titleLabel.topAnchor.constraint(equalTo: borderedView.topAnchor, constant: 8).isActive = true
		titleLabel.leftAnchor.constraint(equalTo: borderedView.leftAnchor, constant: 16).isActive = true
		borderedView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 16).isActive = true

		borderedView.addSubview(descriptionLabel)
		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
		descriptionLabel.leftAnchor.constraint(equalTo: borderedView.leftAnchor, constant: 16).isActive = true
		borderedView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
		borderedView.rightAnchor.constraint(equalTo: descriptionLabel.rightAnchor, constant: 16).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

