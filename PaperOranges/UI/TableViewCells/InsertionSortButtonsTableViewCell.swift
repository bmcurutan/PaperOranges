//
//  InsertionSortButtonsTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/14/21.
//

import Foundation

import UIKit

protocol InsertionSortButtonsTableViewCellDelegate {
	func evaluate(sortId: Int, slotId: Int, with completion: ((Bool) -> Void)?) // TODO
}

class InsertionSortButtonsTableViewCell: UITableViewCell {
	var delegate: InsertionSortButtonsTableViewCellDelegate?

	private var buttons: [ButtonData] = []
	private var slots: [ButtonData] = []

	private let topStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.distribution = .fillEqually
		stackView.spacing = 4
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private let bottomStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.distribution = .fillEqually
		stackView.spacing = 4
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	var lineView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.desertBlue.withAlphaComponent(0.4)
		view.isHidden = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .backgroundColor

		contentView.addSubview(lineView)
		lineView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32).isActive = true
		lineView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
		contentView.rightAnchor.constraint(equalTo: lineView.rightAnchor).isActive = true
		lineView.heightAnchor.constraint(equalToConstant: 8).isActive = true

		contentView.addSubview(topStackView)
		topStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
		topStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		contentView.rightAnchor.constraint(equalTo: topStackView.rightAnchor, constant: 16).isActive = true

		contentView.addSubview(bottomStackView)
		bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 8).isActive = true
		bottomStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: 16).isActive = true
		contentView.rightAnchor.constraint(equalTo: bottomStackView.rightAnchor, constant: 16).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func addButtons(_ buttons: [ButtonData]) {
		self.buttons = buttons

		// Reset stack views and slot data
		topStackView.arrangedSubviews.forEach {
			$0.removeFromSuperview()
		}
		bottomStackView.arrangedSubviews.forEach {
			$0.removeFromSuperview()
		}
		slots = []

		for (slotID, button) in buttons.enumerated() {
			let imageLabelButton0 = ImageLabelButton()
			imageLabelButton0.delegate = self
			imageLabelButton0.image = button.image
			imageLabelButton0.isSelected = button.isSelected
			imageLabelButton0.name = button.name
			if let sortID = button.sortID {
				imageLabelButton0.tag = sortID
			}
			topStackView.addArrangedSubview(imageLabelButton0)

			// TODO bottom
			let imageLabelButton1 = ImageLabelButton()
			imageLabelButton1.layer.borderColor = UIColor.secondaryTextColor.cgColor
			imageLabelButton1.layer.borderWidth = 1
			imageLabelButton1.delegate = self
//			imageLabelButton1.image = button.image
//			imageLabelButton1.isSelected = button.isSelected
			imageLabelButton1.name = "\n" // Placeholder to make button1s the same height as button0s
			imageLabelButton1.tag = buttons.count + slotID // e.g., buttonIDs = [0, 1, 2], slotIDs = [3, 4, 5]
			bottomStackView.addArrangedSubview(imageLabelButton1)
			slots.append(ButtonData())
		}
	}

	func disableAllButtons() {
		topStackView.arrangedSubviews.forEach { button in
			if let button = button as? UIButton {
				button.isUserInteractionEnabled = false
			}
		}
		bottomStackView.arrangedSubviews.forEach { button in
			if let button = button as? UIButton {
				button.isUserInteractionEnabled = false
			}
		}
	}
}

extension InsertionSortButtonsTableViewCell: ImageLabelButtonDelegate {
	func imageLabelButtonTapped(_ sender: ImageLabelButton) {
		// Set selected state
		if let index = buttons.firstIndex(where: { $0.sortID == sender.tag }) {
			buttons[index].isSelected = sender.isSelected
		}
		if let index = slots.firstIndex(where: { $0.sortID == sender.tag }) {
			slots[index].isSelected = sender.isSelected
		}

		let selectedButtonsCount = buttons.filter({ $0.isSelected }).count
		let selectedSlotsCount = slots.filter({ $0.isSelected }).count

		// Show alert if more than one button is selected
		if selectedButtonsCount > 1 {
//			let alert = UIAlertController(title: "Did you bring your towel?", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)
//
//			alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
//			alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

//			self.present(alert, animated: true)
		}

		// If one buttons from each stack view is selected, determine the associated indices
		if selectedButtonsCount == 1, selectedSlotsCount == 1 {
			print("TESTTEST")
//			let index0 = buttons.firstIndex(where: { $0.isSelected }),
//			index0 < buttons.count - 1,
//			let index1 = buttons[index0 + 1...buttons.count - 1].firstIndex(where: { $0.isSelected }),
//			let button0 = stackView.arrangedSubviews[index0] as? ImageLabelButton,
//			let button1 = stackView.arrangedSubviews[index1] as? ImageLabelButton {
//
//			delegate?.evaluate(sortId0: button0.tag, sortId1: button1.tag) { [weak self] result in
//				guard let `self` = self else { return }
//
//				guard result else {
//					// Error - reset selection UI without swapping buttons
//					self.resetButtonSelection(button0: button0, button1: button1)
//					return
//				}
//
//				// If evaluation is successful, make copies of the two buttons
//				let copy0 = button0.createCopy()
//				copy0.frame = self.stackView.convert(button0.frame, to: self.contentView)
//				self.contentView.addSubview(copy0)
//
//				let copy1 = button1.createCopy()
//				copy1.frame = self.stackView.convert(button1.frame, to: self.contentView)
//				self.contentView.addSubview(copy1)
//
//				// Hide the original buttons temporarily
//				// Use alpha instead of removing to maintain arranged subviews positions
//				button0.alpha = 0
//				button1.alpha = 0
//
//				// Animate the buttons swapping positions
//				UIView.animate(withDuration: 0.3, animations: {
//					let tmp = copy0.frame.origin.x
//					copy0.frame.origin.x = copy1.frame.origin.x
//					copy1.frame.origin.x = tmp
//				}) { _ in
//					// Update buttons with new (swapped) data, then show
//					button0.copyData(from: copy1)
//					button1.copyData(from: copy0)
//					button0.alpha = 1
//					button1.alpha = 1
//
//					// Remove copies
//					copy0.removeFromSuperview()
//					copy1.removeFromSuperview()
//				}
//
//				// Reset selection UI
//				self.resetButtonSelection(button0: button0, button1: button1)
//			}
		}
	}

	private func resetButtonSelection(button0: ImageLabelButton, button1: ImageLabelButton) {
		// Update button UI
		UIView.animate(withDuration: 0.3, animations: {
			button0.isSelected = false
			button1.isSelected = false
		})

		// Update button and slot data
		buttons.indices.forEach { index in
			buttons[index].isSelected = false
		}
		slots.indices.forEach { index in
			buttons[index].isSelected = false
		}
	}
}

