//
//  SectionHeaderView.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/10/21.
//

import UIKit

protocol SectionHeaderViewDelegate {
	func infoButtonTapped()
}

class SectionHeaderView: UIView {
	var delegate: SectionHeaderViewDelegate? {
		didSet {
			infoButton.isHidden = false
		}
	}

	private var separator: UIView = {
		let view = UIView()
		view.backgroundColor = .borderColor
		view.translatesAutoresizingMaskIntoConstraints = false
		view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
		return view
	}()

	private var textLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 14)
		label.textColor = .primaryTextColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private var infoButton: UIButton = {
		let button = UIButton()
		button.isHidden = true
		button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
		button.setTitle("ⓘ", for: .normal)
		button.setTitleColor(.accentColor, for: .normal)
		button.setTitleColor(.secondaryAccentColor, for: .highlighted)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	init(title: String) {
		self.init()
		textLabel.text = title.uppercased() 
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .backgroundColor

		addSubview(separator)
		separator.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
		separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		rightAnchor.constraint(equalTo: rightAnchor).isActive = true

		addSubview(textLabel)
		textLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 8).isActive = true
		textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		bottomAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 8).isActive = true

		addSubview(infoButton)
		infoButton.leftAnchor.constraint(equalTo: textLabel.rightAnchor, constant: 8).isActive = true
		rightAnchor.constraint(equalTo: infoButton.rightAnchor, constant: 16).isActive = true
		infoButton.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor).isActive = true
		infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc private func infoButtonTapped() {
		delegate?.infoButtonTapped()
	}
}
