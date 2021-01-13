//
//  ButtonsTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/13/21.
//

import UIKit

protocol ButtonsTableViewCellDelegate {
	func evaluate(id0: Int, id1: Int, with completion: ((Bool) -> Void)?)
}

class ButtonsTableViewCell: UITableViewCell {
	var delegate: ButtonsTableViewCellDelegate?

	private var buttons: [SortingButton] = []

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
		stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
		stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16).isActive = true
		contentView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 16).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func addButtons(_ buttons: [SortingButton]) {
		self.buttons = buttons
		// Reset stack view
		stackView.arrangedSubviews.forEach {
			$0.removeFromSuperview()
		}

		// Calculate width: (screen width - left padding - right padding - spacing) / buttons.count
		let spacing = CGFloat(buttons.count - 1) * (stackView.spacing * 2)
		let width = (UIScreen.main.bounds.width - 16 - 16 - spacing) / CGFloat(buttons.count)
		buttons.forEach {
			let button = ImageAndLabelButton()
			button.delegate = self
			button.tag = $0.id
			button.image = $0.image
			button.name = $0.name
			button.isSelected = $0.isSelected
			button.setImageWidth(width)
			stackView.addArrangedSubview(button)
		}
	}
}

// TODO2 on button long press, scale up??
extension ButtonsTableViewCell: ImageAndLabelButtonDelegate {
	func buttonTapped(_ sender: ImageAndLabelButton) {
		if let index = buttons.firstIndex(where: { $0.id == sender.tag }) {
			buttons[index].isSelected = sender.isSelected
		}

		// If two buttons are selected, determine the associated indices and button views
		if buttons.filter({ $0.isSelected }).count == 2,
			let index0 = buttons.firstIndex(where: { $0.isSelected }),
			index0 < buttons.count - 1,
			let index1 = buttons[index0 + 1...buttons.count - 1].firstIndex(where: { $0.isSelected }),
			let button0 = stackView.arrangedSubviews[index0] as? ImageAndLabelButton,
			let button1 = stackView.arrangedSubviews[index1] as? ImageAndLabelButton {

			delegate?.evaluate(id0: button0.tag, id1: button1.tag) { [weak self] result in
				guard let `self` = self else { return }

				guard result else {
					// Error - reset selection UI without swapping buttons
					self.resetButtonSelection(button0: button0, button1: button1)
					return
				}

				// If evaluation is successful, make copies of the two buttons
				let copy0 = button0.createCopy()
				copy0.frame = self.stackView.convert(button0.frame, to: self.contentView)
				self.contentView.addSubview(copy0)

				let copy1 = button1.createCopy()
				copy1.frame = self.stackView.convert(button1.frame, to: self.contentView)
				self.contentView.addSubview(copy1)

				// Hide the original buttons temporarily
				// Use alpha instead of removing to maintain arranged subviews positions
				button0.alpha = 0
				button1.alpha = 0

				// Animate the buttons swapping positions
				UIView.animate(withDuration: 0.3, animations: {
					let tmp = copy0.frame
					copy0.frame = copy1.frame
					copy1.frame = tmp
				}) { _ in
					// Update buttons with new (swapped) data, then show
					button0.copyData(from: copy1)
					button1.copyData(from: copy0)
					button0.alpha = 1
					button1.alpha = 1

					// Remove copies
					copy0.removeFromSuperview()
					copy1.removeFromSuperview()
				}

				// Reset selection UI
				self.resetButtonSelection(button0: button0, button1: button1)
			}
		}
	}

	private func resetButtonSelection(button0: ImageAndLabelButton, button1: ImageAndLabelButton) {
		// Update button UI
		UIView.animate(withDuration: 0.3, animations: {
			button0.isSelected = false
			button1.isSelected = false
		})

		// Update button data
		buttons.indices.forEach { index in
			buttons[index].isSelected = false
		}
	}
}

