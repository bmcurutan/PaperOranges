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

	var infoButton: UIButton = {
        let image = #imageLiteral(resourceName: "ic_help")
        let button = UIButton(type: .custom)
        button.isHidden = true
        button.setImage(image.withTintColor(.accentColor, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(image.withTintColor(.secondaryAccentColor, renderingMode: .alwaysOriginal), for: .highlighted)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

    var progressView: UIProgressView = {
        let view = UIProgressView()
        view.backgroundColor = .borderColor
        view.tintColor = .secondaryAccentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

		addSubview(infoButton)
		infoButton.leftAnchor.constraint(equalTo: textLabel.rightAnchor, constant: 8).isActive = true
		rightAnchor.constraint(equalTo: infoButton.rightAnchor, constant: 16).isActive = true
		infoButton.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor).isActive = true
        infoButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
		infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)

        addSubview(progressView)
        progressView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 8).isActive = true
        progressView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16).isActive = true
        rightAnchor.constraint(equalTo: progressView.rightAnchor, constant: 16).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc private func infoButtonTapped() {
		delegate?.infoButtonTapped()
	}
}
