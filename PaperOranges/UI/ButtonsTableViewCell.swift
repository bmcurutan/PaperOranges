//
//  ButtonsTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/13/21.
//

import UIKit

protocol ButtonsTableViewCellDelegate {
	func evaluateAndSwap(sortId0: Int, sortId1: Int, with completion: ((Bool) -> Void)?)
	func openURL(_ url: URL)
}

class ButtonsTableViewCell: UITableViewCell {
	var delegate: ButtonsTableViewCellDelegate?

	private var buttons: [ButtonData] = []

	private var shouldSort: Bool {
		return buttons.filter({ $0.sortId != nil }).count == buttons.count
	}

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
			if shouldSort {
				// Only implements sorting buttons if all buttons have sort IDs
				let imageLabelButton = ImageLabelButton()
				imageLabelButton.delegate = self
				imageLabelButton.image = button.image
				imageLabelButton.isSelected = button.isSelected
				imageLabelButton.name = button.name
				if let sortId = button.sortId {
					imageLabelButton.tag = sortId
				}
				stackView.addArrangedSubview(imageLabelButton)
			} else {
				// Otherwise default to buttons without sort/swap functionality
				let linkButton = LinkButton()
				if let urlString = button.url,
				   let url = URL(string: urlString) {
					linkButton.url = url
				}
				linkButton.tintColor = .accentColor
				linkButton.setImage(button.image.withRenderingMode(.alwaysTemplate), for: .normal)
				linkButton.setImage(button.image.withTintColor(.secondaryAccentColor, renderingMode: .alwaysOriginal), for: .highlighted)
				stackView.addArrangedSubview(linkButton)
				linkButton.addTarget(self, action: #selector(linkButtonTapped(_:)), for: .touchUpInside)
			}
		}
	}

	@objc func linkButtonTapped(_ sender: LinkButton) {
		if let url = sender.url {
			delegate?.openURL(url)
		}
	}
}

// TODO2 on button long press, scale up??
extension ButtonsTableViewCell: ImageLabelButtonDelegate {
	func imageLabelButtonTapped(_ sender: ImageLabelButton) {
		if let index = buttons.firstIndex(where: { $0.sortId == sender.tag }) {
			buttons[index].isSelected = sender.isSelected
		}

		// If two buttons are selected, determine the associated indices and button views
		if buttons.filter({ $0.isSelected }).count == 2,
			let index0 = buttons.firstIndex(where: { $0.isSelected }),
			index0 < buttons.count - 1,
			let index1 = buttons[index0 + 1...buttons.count - 1].firstIndex(where: { $0.isSelected }),
			let button0 = stackView.arrangedSubviews[index0] as? ImageLabelButton,
			let button1 = stackView.arrangedSubviews[index1] as? ImageLabelButton {

			delegate?.evaluateAndSwap(sortId0: button0.tag, sortId1: button1.tag) { [weak self] result in
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

class LinkButton: UIButton {
	var url: URL?

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
