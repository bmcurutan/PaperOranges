//
//  BubbleSortButtonsTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/13/21.
//

import UIKit

protocol BubbleSortButtonsTableViewCellDelegate {
	func evaluate(sortID0: Int, sortID1: Int, with completion: ((Bool) -> Void)?)
}

class BubbleSortButtonsTableViewCell: UITableViewCell {
	var delegate: BubbleSortButtonsTableViewCellDelegate?

	private var buttons: [ButtonData] = []

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
		self.buttons = buttons

		// Reset stack view
		stackView.arrangedSubviews.forEach {
			$0.removeFromSuperview()
		}

		buttons.forEach { button in
			let imageLabelButton = ImageLabelButton()
			imageLabelButton.delegate = self
			imageLabelButton.image = button.image
			imageLabelButton.isSelected = button.isSelected
			imageLabelButton.name = button.name
			if let sortID = button.sortID {
				imageLabelButton.tag = sortID
			}
			stackView.addArrangedSubview(imageLabelButton)
		}
	}

	func disableAllButtons() {
		stackView.arrangedSubviews.forEach { button in
			if let button = button as? UIButton {
				button.isUserInteractionEnabled = false
			}
		}
	}
}

extension BubbleSortButtonsTableViewCell: ImageLabelButtonDelegate {
	func imageLabelButtonTapped(_ sender: ImageLabelButton) {
		// Set selected state
		if let index = buttons.firstIndex(where: { $0.sortID == sender.tag }) {
			buttons[index].isSelected = sender.isSelected
		}

		// If two buttons are selected, determine the associated indices and button views
		guard buttons.filter({ $0.isSelected }).count == 2,
			let index0 = buttons.firstIndex(where: { $0.isSelected }),
			index0 < buttons.count - 1,
			let index1 = buttons[index0 + 1...buttons.count - 1].firstIndex(where: { $0.isSelected }),
			let button0 = stackView.arrangedSubviews[index0] as? ImageLabelButton,
            let button1 = stackView.arrangedSubviews[index1] as? ImageLabelButton else { return }

        delegate?.evaluate(sortID0: button0.tag, sortID1: button1.tag) { [weak self] result in
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
                let tmp = copy0.frame.origin.x
                copy0.frame.origin.x = copy1.frame.origin.x
                copy1.frame.origin.x = tmp
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

	private func resetButtonSelection(button0: ImageLabelButton, button1: ImageLabelButton) {
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

