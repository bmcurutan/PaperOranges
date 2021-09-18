//
//  TopicTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 9/17/21.
//

import UIKit

protocol TopicTableViewCellDelegate {
    func buttonTapped(topic: Topic)
}

class TopicTableViewCell: UITableViewCell {
    var delegate: TopicTableViewCellDelegate?

    var topic: Topic? = nil {
        didSet {
            guard let topic = topic else { return }
            roundImageView.image = topic.image
            button.setTitle(topic.title, for: .normal)
            if let text = topic.text {
                button.setTitle("\(topic.title)\n\(text)", for: .normal)
            } else {
                button.setTitle(topic.title, for: .normal)
            }
            if !topic.isActive {
                roundImageView.alpha = 0.5
                button.layer.borderColor = UIColor.borderColor.cgColor
                button.setTitleColor(.secondaryTextColor, for: .normal)
                button.isEnabled = false
            }
            checkmarkView.isHidden = !topic.isCompleted
        }
    }

    var button: RoundedButton = {
        let button = RoundedButton()
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var roundImageView: RoundImageView = {
        let imageView = RoundImageView()
        imageView.backgroundColor = .backgroundColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var checkmarkView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "ic_checkmark").withRenderingMode(.alwaysTemplate))
        imageView.isHidden = true
        imageView.tintColor = .primaryButtonColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .backgroundColor
        selectedBackgroundView = UIView()

        contentView.addSubview(button)
        button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        contentView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 8).isActive = true
        contentView.rightAnchor.constraint(equalTo: button.rightAnchor, constant: 16).isActive = true

        button.addSubview(roundImageView)
        roundImageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 8).isActive = true
        roundImageView.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 16).isActive = true
        button.bottomAnchor.constraint(greaterThanOrEqualTo: roundImageView.bottomAnchor, constant: 8).isActive = true
        roundImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        roundImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true

        button.addSubview(checkmarkView)
        button.rightAnchor.constraint(equalTo: checkmarkView.rightAnchor, constant: 16).isActive = true
        checkmarkView.centerYAnchor.constraint(equalTo: roundImageView.centerYAnchor).isActive = true
        checkmarkView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        checkmarkView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonTapped() {
        if let topic = topic {
            delegate?.buttonTapped(topic: topic)
        }
    }
}

