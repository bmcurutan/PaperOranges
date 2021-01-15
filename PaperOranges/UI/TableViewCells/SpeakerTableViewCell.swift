//
//  SpeakerTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/14/21.
//

import UIKit

protocol SpeakerTableViewCellDelegate {
	func speechBubbleTapped()
}

class SpeakerTableViewCell: UITableViewCell {
	var delegate: SpeakerTableViewCellDelegate?

	private var speechBubbleView: UIButton = {
		let button = UIButton()
		button.layer.borderColor = UIColor.lightGray.cgColor
		button.layer.borderWidth = 1
		button.layer.cornerRadius = 16
		button.backgroundColor = .white
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	private var speechBubbleLabel: UILabel = {
		let label = UILabel()
		label.font = label.font.withSize(14.0)
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.textColor = .primaryTextColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private var speakerImageView: RoundImageView = {
		let imageView = RoundImageView(image: #imageLiteral(resourceName: "av_sorting_vanilla"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .backgroundColor

		contentView.addSubview(speakerImageView)
		speakerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
		speakerImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		speakerImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
		speakerImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true

		contentView.addSubview(speechBubbleView)
		speechBubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
		speechBubbleView.leftAnchor.constraint(equalTo: speakerImageView.rightAnchor, constant: 8).isActive = true
		contentView.rightAnchor.constraint(equalTo: speechBubbleView.rightAnchor, constant: 16).isActive = true
		contentView.bottomAnchor.constraint(equalTo: speechBubbleView.bottomAnchor, constant: 16).isActive = true
		speechBubbleView.addTarget(self, action: #selector(speechBubbleTapped), for: .touchUpInside)

		speechBubbleView.addSubview(speechBubbleLabel)
		speechBubbleLabel.topAnchor.constraint(equalTo: speechBubbleView.topAnchor, constant: 8).isActive = true
		speechBubbleLabel.leftAnchor.constraint(equalTo: speechBubbleView.leftAnchor, constant: 8).isActive = true
		speechBubbleView.bottomAnchor.constraint(equalTo: speechBubbleLabel.bottomAnchor, constant: 8).isActive = true
		speechBubbleView.rightAnchor.constraint(equalTo: speechBubbleLabel.rightAnchor, constant: 8).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setText(title: String? = nil, text: NSMutableAttributedString, ending: String? = nil) {
		let attributedText = NSMutableAttributedString(string: "")
		if let title = title {
			attributedText.append(NSMutableAttributedString(string: "\(title)\n\n").setTextColor(.accentColor))
		}
		attributedText.append(text)
		if let ending = ending {
			attributedText.append("\n\n\(ending)")
		}
		speechBubbleLabel.attributedText = attributedText
	}

	@objc private func speechBubbleTapped() {
		delegate?.speechBubbleTapped()
	}
}

