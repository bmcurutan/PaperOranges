//
//  InsertionSortButtonsTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/14/21.
//

import Foundation

import UIKit

protocol InsertionSortButtonsTableViewCellDelegate {
	func showButtonsError(with completion: (() -> Void)?)
	func showSlotsError(with completion: (() -> Void)?)
    func evaluate(buttonID: Int, slotID: Int, with completion: ((Bool) -> Void)?)
}

class InsertionSortButtonsTableViewCell: UITableViewCell {
	var delegate: InsertionSortButtonsTableViewCellDelegate?

	private var buttons: [ButtonData] = []
	private var slots: [ButtonData] = []

	private let buttonsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.distribution = .fillEqually
		stackView.spacing = 4
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private let slotsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.distribution = .fillEqually
		stackView.spacing = 4
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private var blueLineView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.desertBlue.withAlphaComponent(0.4)
		view.isHidden = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

    private var redLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.desertRed.withAlphaComponent(0.4)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .backgroundColor

		contentView.addSubview(blueLineView)
        blueLineView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36).isActive = true
        blueLineView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
		contentView.rightAnchor.constraint(equalTo: blueLineView.rightAnchor).isActive = true
        blueLineView.heightAnchor.constraint(equalToConstant: 8).isActive = true

		contentView.addSubview(buttonsStackView)
		buttonsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
		buttonsStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		contentView.rightAnchor.constraint(equalTo: buttonsStackView.rightAnchor, constant: 16).isActive = true

        contentView.addSubview(redLineView)
        redLineView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 36).isActive = true
        redLineView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: redLineView.rightAnchor).isActive = true
        redLineView.heightAnchor.constraint(equalToConstant: 8).isActive = true

		contentView.addSubview(slotsStackView)
		slotsStackView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 8).isActive = true
		slotsStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		contentView.bottomAnchor.constraint(equalTo: slotsStackView.bottomAnchor, constant: 16).isActive = true
		contentView.rightAnchor.constraint(equalTo: slotsStackView.rightAnchor, constant: 16).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    func showLines() {
        blueLineView.isHidden = false
        redLineView.isHidden = false
    }

	func addButtons(_ buttons: [ButtonData]) {
		self.buttons = buttons
		// Reset button stack view
		buttonsStackView.arrangedSubviews.forEach {
			$0.removeFromSuperview()
		}

        buttons.forEach { button in
			let imageLabelButton = ImageLabelButton()
			imageLabelButton.delegate = self
            imageLabelButton.alpha = button.isHidden ? 0 : 1 // Hide button - use alpha instead of removing to maintain arranged subviews positions
			imageLabelButton.image = button.image
            imageLabelButton.isUserInteractionEnabled = !button.isHidden
			imageLabelButton.name = button.name
            imageLabelButton.tag = button.id
			buttonsStackView.addArrangedSubview(imageLabelButton)
        }
    }

    func addSlots(_ slots: [ButtonData]) {
        self.slots = slots
        // Reset button stack view
        slotsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        slots.forEach { slot in
            let imageLabelButton = ImageLabelButton()
            imageLabelButton.layer.borderColor = UIColor.borderColor.cgColor
            imageLabelButton.layer.borderWidth = 1
            imageLabelButton.delegate = self
            imageLabelButton.name = slot.name
            imageLabelButton.image = slot.image
            imageLabelButton.tag = slot.id
            slotsStackView.addArrangedSubview(imageLabelButton)
        }
	}

	func disableAllButtons() {
		buttonsStackView.arrangedSubviews.forEach { button in
			if let button = button as? UIButton {
				button.isUserInteractionEnabled = false
			}
		}
		slotsStackView.arrangedSubviews.forEach { button in
			if let button = button as? UIButton {
				button.isUserInteractionEnabled = false
			}
		}
	}
}

extension InsertionSortButtonsTableViewCell: ImageLabelButtonDelegate {
	func imageLabelButtonTapped(_ sender: ImageLabelButton) {
        var senderButtonIndex = -1
        var senderSlotIndex = -1

		// Set selected state
		if let index = buttons.firstIndex(where: { $0.id == sender.tag }) {
			buttons[index].isSelected = sender.isSelected
            senderButtonIndex = index
		}
		if sender.tag > buttons.count {
            senderSlotIndex = sender.tag - buttons.count - 1 // insertion sort uses a 1-indexed array for student height
			slots[senderSlotIndex].isSelected = sender.isSelected
		}
        let selectedButtonsCount = buttons.filter({ $0.isSelected }).count
        let selectedSlotsCount = slots.filter({ $0.isSelected }).count
        guard (senderButtonIndex > -1 || senderSlotIndex > -1) && (selectedButtonsCount > 0 || selectedSlotsCount > 0) else { return }

		if selectedButtonsCount > 1, senderButtonIndex > -1 {
			// Only one button may be selected at a time
			delegate?.showButtonsError(with: { [weak self] in
				guard let `self` = self else { return }
				if self.buttons.indices.contains(senderButtonIndex) {
					// Undo button selection data and UI
					self.buttons[senderButtonIndex].isSelected = false
					sender.isSelected = false
				}
			})

		} else if selectedSlotsCount > 1, senderSlotIndex > -1 {
			// Only one slot may be selected at a time
			delegate?.showSlotsError(with: { [weak self] in
				guard let `self` = self else { return }
				// Undo slot selection data and UI
				self.slots[senderSlotIndex].isSelected = false
				sender.isSelected = false
			})

		} else if selectedButtonsCount == 1, selectedSlotsCount == 1,
            let buttonIndex = buttons.firstIndex(where: { $0.isSelected }),
            let slotIndex = slots.firstIndex(where: { $0.isSelected }),
            let button = buttonsStackView.arrangedSubviews[buttonIndex] as? ImageLabelButton,
            let slot = slotsStackView.arrangedSubviews[slotIndex] as? ImageLabelButton {
            // One button and one slot selected
            // Re-calculated indices because don't know if button/slot was selected first/second

			delegate?.evaluate(buttonID: button.tag, slotID: slot.tag) { [weak self] isSuccess in
				guard let `self` = self else { return }

				guard isSuccess else {
					// Error - reset selection UI
					self.resetButtonSelection(button: button, slot: slot)
					return
				}

				// If evaluation is successful, make copy of the button
				let copy = button.createCopy()
				copy.frame = self.buttonsStackView.convert(button.frame, to: self.contentView)
				self.contentView.addSubview(copy)

                // Hide the original button - use alpha instead of removing to maintain arranged subviews positions
				button.alpha = 0

				// Animate the buttons moving
				UIView.animate(withDuration: 0.3, animations: {
                    copy.frame.origin =  self.slotsStackView.convert(slot.frame, to: self.contentView).origin
				}) { _ in
					slot.copyData(from: copy)
					// Remove copy
					copy.removeFromSuperview()
				}

				// Reset selection UI
                self.resetButtonSelection(button: button, slot: slot)
			}
		}
	}

	private func resetButtonSelection(button: ImageLabelButton, slot: ImageLabelButton) {
		// Update button UI
		UIView.animate(withDuration: 0.3, animations: {
			button.isSelected = false
			slot.isSelected = false
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

