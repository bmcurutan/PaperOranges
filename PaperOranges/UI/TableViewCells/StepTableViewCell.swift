//
//  StepsTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/14/21.
//

import UIKit

class StepTableViewCell: UITableViewCell {
    var stepText: String? {
        didSet {
            if let text = stepText {
                stepLabel.text = text
                contentView.backgroundColor = .white
            } else {
                stepLabel.text = ""
                contentView.backgroundColor = .backgroundColor
            }
        }
    }

    private var stepLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
        contentView.backgroundColor = .backgroundColor

        contentView.addSubview(stepLabel)
        stepLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        stepLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        contentView.bottomAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 8).isActive = true
        contentView.rightAnchor.constraint(equalTo: stepLabel.rightAnchor, constant: 16).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
