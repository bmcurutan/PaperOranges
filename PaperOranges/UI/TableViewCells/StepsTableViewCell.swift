//
//  StepsTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/14/21.
//

import UIKit

class StepsTableViewCell: UITableViewCell {
	var stepsText: [String?] = [] {
		didSet {
			addSteps()
		}
	}

	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fillProportionally
		stackView.spacing = 12
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none

		contentView.addSubview(stackView)
		stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
		stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16).isActive = true
		contentView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 16).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func addSteps() {
		// Reset stack view
		stackView.arrangedSubviews.forEach {
			$0.removeFromSuperview()
		}

		stepsText.forEach {
			if let stepText = $0 {
				stackView.addArrangedSubview(StepView(stepText, count: stackView.arrangedSubviews.count))
			}
		}
	}
}

private class StepView: UIView {
	private var stepLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.textColor = .primaryTextColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	init(_ stepText: String, count: Int) {
		self.init()
		stepLabel.text = "\(count + 1). \(stepText)"
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(stepLabel)
		stepLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
		stepLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		bottomAnchor.constraint(equalTo: stepLabel.bottomAnchor).isActive = true
		rightAnchor.constraint(equalTo: stepLabel.rightAnchor).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

