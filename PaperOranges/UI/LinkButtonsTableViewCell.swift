//
//  LinkButtonsTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/14/21.
//

import UIKit

protocol LinkButtonsTableViewCellDelegate {
	func openURL(_ url: URL)
}

class LinkButtonsTableViewCell: UITableViewCell {
	var delegate: LinkButtonsTableViewCellDelegate?

	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.distribution = .fillEqually
		stackView.spacing = 4
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .backgroundColor

		contentView.addSubview(stackView)
		stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
		stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16).isActive = true
		contentView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 16).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func addButtons(_ buttons: [ButtonData]) {
		// Reset stack view
		stackView.arrangedSubviews.forEach {
			$0.removeFromSuperview()
		}

		buttons.forEach { button in
			let linkButton = LinkButton()
			linkButton.translatesAutoresizingMaskIntoConstraints = false
			if let urlString = button.url,
			   let url = URL(string: urlString) {
				linkButton.url = url
			}
			linkButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
			linkButton.imageView?.widthAnchor.constraint(equalToConstant: 40).isActive = true
			linkButton.imageView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
			linkButton.tintColor = .accentColor
			linkButton.setImage(button.image.withRenderingMode(.alwaysTemplate), for: .normal)
			linkButton.setImage(button.image.withTintColor(.secondaryAccentColor, renderingMode: .alwaysOriginal), for: .highlighted)
			stackView.addArrangedSubview(linkButton)
			linkButton.addTarget(self, action: #selector(linkButtonTapped(_:)), for: .touchUpInside)
		}
	}

	@objc func linkButtonTapped(_ sender: LinkButton) {
		if let url = sender.url {
			delegate?.openURL(url)
		}
	}
}

class LinkButton: UIButton {
	var url: URL?

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

