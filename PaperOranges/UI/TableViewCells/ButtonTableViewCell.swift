//
//  ButtonTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 9/17/21.
//

import UIKit

protocol ButtonTableViewCellDelegate {
    func buttonTapped()
}

class ButtonTableViewCell: UITableViewCell {
    var delegate: ButtonTableViewCellDelegate?

    var helpButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primaryButtonColor.cgColor
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.setBackgroundColor(.white, for: .normal)
        button.setBackgroundColor(.primaryButtonColor, for: .highlighted)
        button.setTitle("HELP", for: .normal)
        button.setTitleColor(.primaryButtonColor, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .backgroundColor

        contentView.addSubview(helpButton)
        helpButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        contentView.bottomAnchor.constraint(equalTo: helpButton.bottomAnchor).isActive = true
        helpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        helpButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonTapped() {
        delegate?.buttonTapped()
    }
}
