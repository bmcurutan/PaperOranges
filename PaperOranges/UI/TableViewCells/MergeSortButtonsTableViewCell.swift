//
//  MergeSortButtonsTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 9/17/21.
//

import UIKit

protocol MergeSortButtonsTableViewCellDelegate {
    func showMergeSortError()
    func evaluateButtonAndSlot(buttonID: Int, slotID: Int, isForced: Bool, completion: ((Bool) -> Void)?)
    func evaluateSlots(slotID0: Int, slotID1: Int, isForced: Bool, completion: ((Bool) -> Void)?)
}

// Hack: Hardcoded/expected number of slots (8) for each round (4)
class MergeSortButtonsTableViewCell: SortingTableViewCell {
    var delegate: MergeSortButtonsTableViewCellDelegate?

    private var buttons: [ButtonData] = []
    private var slots: [ButtonData] = []

    private let round1IndexRange = 0...7
    private let round2IndexRange = 8...15
    private let round3IndexRange = 16...23
    private let round4IndexRange = 24...31

    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var blueLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.desertBlue.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let slotsStackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var redLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.desertRed.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let slotsStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var tealLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.desertTeal.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let slotsStackView3: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var yellowLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.desertYellow.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let slotsStackView4: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .backgroundColor

        contentView.addSubview(buttonsStackView)
        buttonsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        buttonsStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        contentView.rightAnchor.constraint(equalTo: buttonsStackView.rightAnchor, constant: 16).isActive = true

        contentView.addSubview(blueLineView)
        blueLineView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: blueLineView.rightAnchor).isActive = true
        blueLineView.heightAnchor.constraint(equalToConstant: 16).isActive = true

        contentView.addSubview(slotsStackView1)
        slotsStackView1.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 8).isActive = true
        slotsStackView1.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        contentView.rightAnchor.constraint(equalTo: slotsStackView1.rightAnchor, constant: 16).isActive = true
        blueLineView.centerYAnchor.constraint(equalTo: slotsStackView1.centerYAnchor).isActive = true

        contentView.addSubview(redLineView)
        redLineView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: redLineView.rightAnchor).isActive = true
        redLineView.heightAnchor.constraint(equalToConstant: 16).isActive = true

        contentView.addSubview(slotsStackView2)
        slotsStackView2.topAnchor.constraint(equalTo: slotsStackView1.bottomAnchor, constant: 8).isActive = true
        slotsStackView2.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        contentView.rightAnchor.constraint(equalTo: slotsStackView2.rightAnchor, constant: 16).isActive = true
        redLineView.centerYAnchor.constraint(equalTo: slotsStackView2.centerYAnchor).isActive = true

        contentView.addSubview(tealLineView)
        tealLineView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: tealLineView.rightAnchor).isActive = true
        tealLineView.heightAnchor.constraint(equalToConstant: 16).isActive = true

        contentView.addSubview(slotsStackView3)
        slotsStackView3.topAnchor.constraint(equalTo: slotsStackView2.bottomAnchor, constant: 8).isActive = true
        slotsStackView3.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        contentView.rightAnchor.constraint(equalTo: slotsStackView3.rightAnchor, constant: 16).isActive = true
        tealLineView.centerYAnchor.constraint(equalTo: slotsStackView3.centerYAnchor).isActive = true

        contentView.addSubview(yellowLineView)
        yellowLineView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: yellowLineView.rightAnchor).isActive = true
        yellowLineView.heightAnchor.constraint(equalToConstant: 16).isActive = true

        contentView.addSubview(slotsStackView4)
        slotsStackView4.topAnchor.constraint(equalTo: slotsStackView3.bottomAnchor, constant: 8).isActive = true
        slotsStackView4.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        contentView.bottomAnchor.constraint(equalTo: slotsStackView4.bottomAnchor, constant: 16).isActive = true
        contentView.rightAnchor.constraint(equalTo: slotsStackView4.rightAnchor, constant: 16).isActive = true
        yellowLineView.centerYAnchor.constraint(equalTo: slotsStackView4.centerYAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            imageLabelButton.text = button.name
            imageLabelButton.tag = button.id
            buttonsStackView.addArrangedSubview(imageLabelButton)
        }
    }

    func addSlots(_ slots: [ButtonData]) {
        self.slots = slots
        // Reset button stack views
        slotsStackView1.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        slotsStackView2.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        slotsStackView3.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        slotsStackView4.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        for (index, slot) in slots.enumerated() {
            let imageLabelButton = ImageLabelButton()
            imageLabelButton.layer.borderColor = UIColor.borderColor.cgColor
            imageLabelButton.layer.borderWidth = slot.isHidden ? 0 : 1
            imageLabelButton.backgroundColor = slot.isHidden ? .clear : UIColor.backgroundColor.withAlphaComponent(0.4)
            imageLabelButton.isUserInteractionEnabled = !slot.isHidden
            imageLabelButton.delegate = self
            imageLabelButton.text = slot.name
            imageLabelButton.image = slot.image
            imageLabelButton.tag = slot.id

            switch index {
            case let i where i < 8:
                // Groups 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8
                if slot.name == "\n" {
                    imageLabelButton.setTitle("\(i + 1)", for: .normal)
                }
                slotsStackView1.addArrangedSubview(imageLabelButton)
            case let i where i < 16:
                // Groups 1 | 2 | 3 | 4
                if slot.name == "\n" {
                    if i == 8 || i == 9 {
                        imageLabelButton.setTitle("1", for: .normal)
                    } else if i == 10 || i == 11 {
                        imageLabelButton.setTitle("2", for: .normal)
                    } else if i == 12 || i == 13 {
                        imageLabelButton.setTitle("3", for: .normal)
                    } else if i == 14 || i == 15 {
                        imageLabelButton.setTitle("4", for: .normal)
                    }
                }
                slotsStackView2.addArrangedSubview(imageLabelButton)
            case let i where i < 24:
                // Groups 1 | 2
                if slot.name == "\n" {
                    if i == 16 || i == 17 || i == 18 || i == 19 {
                        imageLabelButton.setTitle("1", for: .normal)
                    } else if i == 20 || i == 21 || i == 22 || i == 23 {
                        imageLabelButton.setTitle("2", for: .normal)
                    }
                }
                slotsStackView3.addArrangedSubview(imageLabelButton)
            default:
                // Group 1
                if slot.name == "\n" {
                    imageLabelButton.setTitle("1", for: .normal)
                }
                slotsStackView4.addArrangedSubview(imageLabelButton)
            }
        }
    }

    func disableAllButtons() {
        buttonsStackView.arrangedSubviews.forEach { button in
            if let button = button as? UIButton {
                button.isUserInteractionEnabled = false
            }
        }
        slotsStackView1.arrangedSubviews.forEach { button in
            if let button = button as? UIButton {
                button.isUserInteractionEnabled = false
            }
        }
    }
}

extension MergeSortButtonsTableViewCell: ImageLabelButtonDelegate {
    func imageLabelButtonTapped(_ sender: ImageLabelButton) {
        var senderButtonIndex = -1
        var senderSlotIndex = -1

        // Set selected state
        if let index = buttons.firstIndex(where: { $0.id == sender.tag }) {
            buttons[index].isSelected = sender.isSelected
            senderButtonIndex = index
        } else if sender.tag > buttons.count {
            senderSlotIndex = sender.tag - buttons.count - 1 // insertion sort uses a 1-indexed array for student height
            slots[senderSlotIndex].isSelected = sender.isSelected
        }
        let selectedButtonsCount = buttons.filter({ $0.isSelected }).count
        let selectedSlotsCount = slots.filter({ $0.isSelected }).count
        guard (senderButtonIndex > -1 || senderSlotIndex > -1) && (selectedButtonsCount > 0 || selectedSlotsCount > 0) else {
            return
        }

        if selectedButtonsCount > 1, senderButtonIndex > -1 {
            // Only one button may be selected at a time
            guard buttons.filter({ $0.isSelected }).count == 2,
                let index0 = buttons.firstIndex(where: { $0.isSelected }),
                index0 < buttons.count - 1,
                let index1 = buttons[index0 + 1...buttons.count - 1].firstIndex(where: { $0.isSelected }),
                let button0 = buttonsStackView.arrangedSubviews[index0] as? ImageLabelButton,
                let button1 = buttonsStackView.arrangedSubviews[index1] as? ImageLabelButton else {
                return
            }
            resetButtonsUI([button0, button1])
            // Update button data
            buttons.indices.forEach { index in
                buttons[index].isSelected = false
            }
            shakeButtons([button0, button1])
            delegate?.showMergeSortError()

        } else if selectedSlotsCount > 1, senderSlotIndex > -1 {
            // Only one slot per stack view may be selected at a time
            guard slots.filter({ $0.isSelected }).count == 2,
                let index0 = slots.firstIndex(where: { $0.isSelected }),
                index0 < slots.count - 1,
                let index1 = slots[index0 + 1...slots.count - 1].firstIndex(where: { $0.isSelected }) else { return }

            var slot0: ImageLabelButton?
            var slot1: ImageLabelButton?
            if round1IndexRange.contains(index0) && round1IndexRange.contains(index1) {
                slot0 = slotsStackView1.arrangedSubviews[index0] as? ImageLabelButton
                slot1 = slotsStackView1.arrangedSubviews[index1] as? ImageLabelButton
            } else if round2IndexRange.contains(index0) && round2IndexRange.contains(index1) {
                slot0 = slotsStackView2.arrangedSubviews[index0 - 8] as? ImageLabelButton
                slot1 = slotsStackView2.arrangedSubviews[index1 - 8] as? ImageLabelButton
            } else if round3IndexRange.contains(index0) && round3IndexRange.contains(index1) {
                slot0 = slotsStackView3.arrangedSubviews[index0 - 16] as? ImageLabelButton
                slot1 = slotsStackView3.arrangedSubviews[index1 - 16] as? ImageLabelButton
            } else if round4IndexRange.contains(index0) && round4IndexRange.contains(index1) {
                slot0 = slotsStackView4.arrangedSubviews[index0 - 24] as? ImageLabelButton
                slot1 = slotsStackView4.arrangedSubviews[index1 - 24] as? ImageLabelButton
            } else {
                evaluateSlots()
                return
            }

            resetButtonsUI([slot0, slot1])
            // Update slot data
            slots.indices.forEach { index in
                slots[index].isSelected = false
            }
            shakeButtons([slot0, slot1])
            delegate?.showMergeSortError()

        } else if selectedButtonsCount == 1, selectedSlotsCount == 1,
            let buttonIndex = buttons.firstIndex(where: { $0.isSelected }),
            let slotIndex = slots.firstIndex(where: { $0.isSelected }),
            let button = buttonsStackView.arrangedSubviews[buttonIndex] as? ImageLabelButton {
            // TODO merge this with evaluateSlots() ??
            // One button and one slot selected
            // Re-calculated indices because don't know if button/slot was selected first/second

            var slotButton: ImageLabelButton?
            if round1IndexRange.contains(slotIndex) {
                slotButton = slotsStackView1.arrangedSubviews[slotIndex] as? ImageLabelButton
            } else if round2IndexRange.contains(slotIndex) {
                slotButton = slotsStackView2.arrangedSubviews[slotIndex - 8] as? ImageLabelButton
            } else if round3IndexRange.contains(slotIndex) {
                slotButton = slotsStackView3.arrangedSubviews[slotIndex - 16] as? ImageLabelButton
            } else if round4IndexRange.contains(slotIndex) {
                slotButton = slotsStackView4.arrangedSubviews[slotIndex - 24] as? ImageLabelButton
            }

            guard let slot = slotButton else { return }

            delegate?.evaluateButtonAndSlot(buttonID: button.tag, slotID: slot.tag, isForced: false) { [weak self] isSuccess in
                guard let `self` = self else { return }

                guard isSuccess else {
                    // Error - reset selection UI
                    self.resetSelection(button: button, slot: slot)
                    self.shakeButtons([button, slot])
                    return
                }

                // If evaluation is successful, make a copy of the button
                let copy = button.createCopy()
                copy.frame = self.buttonsStackView.convert(button.frame, to: self.contentView)
                self.contentView.addSubview(copy)

                // Hide the original button - use alpha instead of removing to maintain arranged subviews positions
                button.alpha = 0

                // Animate the buttons moving
                UIView.animate(withDuration: 0.3, animations: {
                    copy.frame.origin =  self.slotsStackView1.convert(slot.frame, to: self.contentView).origin
                }) { _ in
                    slot.copyData(from: copy)
                    // Remove copy
                    copy.removeFromSuperview()
                }

                // Reset selection UI
                self.resetSelection(button: button, slot: slot)
            }
        }
    }

    private func resetSelection(button: ImageLabelButton, slot: ImageLabelButton?) {
        // Update button UI
        UIView.animate(withDuration: 0.3, animations: {
            button.isSelected = false
            slot?.isSelected = false
        })

        // Update button and slot data
        buttons.indices.forEach { index in
            buttons[index].isSelected = false
        }
        slots.indices.forEach { index in
            slots[index].isSelected = false
        }
    }

    private func evaluateSlots() {
        guard let index0 = slots.firstIndex(where: { $0.isSelected }),
            index0 < slots.count - 1,
            let index1 = slots[index0 + 1...slots.count - 1].firstIndex(where: { $0.isSelected }) else { return }

        var stackView1 = slotsStackView1
        var stackView2 = slotsStackView2

        var slotButton0: ImageLabelButton?
        var slotButton1: ImageLabelButton?
        if round1IndexRange.contains(index0) {
            slotButton0 = slotsStackView1.arrangedSubviews[index0] as? ImageLabelButton
            stackView1 = slotsStackView1
        } else if round2IndexRange.contains(index0) {
            slotButton0 = slotsStackView2.arrangedSubviews[index0 - 8] as? ImageLabelButton
            stackView1 = slotsStackView2
        } else if round3IndexRange.contains(index0) {
            slotButton0 = slotsStackView3.arrangedSubviews[index0 - 16] as? ImageLabelButton
            stackView1 = slotsStackView3
        } else if round4IndexRange.contains(index0) {
            slotButton0 = slotsStackView4.arrangedSubviews[index0 - 24] as? ImageLabelButton
            stackView1 = slotsStackView4
        }
        if round1IndexRange.contains(index1) {
            slotButton1 = slotsStackView1.arrangedSubviews[index1] as? ImageLabelButton
            stackView2 = slotsStackView1
        } else if round2IndexRange.contains(index1) {
            slotButton1 = slotsStackView2.arrangedSubviews[index1 - 8] as? ImageLabelButton
            stackView2 = slotsStackView2
        } else if round3IndexRange.contains(index1) {
            slotButton1 = slotsStackView3.arrangedSubviews[index1 - 16] as? ImageLabelButton
            stackView2 = slotsStackView3
        } else if round4IndexRange.contains(index1) {
            slotButton1 = slotsStackView4.arrangedSubviews[index1 - 24] as? ImageLabelButton
            stackView2 = slotsStackView4
        }

        guard let slot0 = slotButton0, let slot1 = slotButton1 else { return }

        delegate?.evaluateSlots(slotID0: slot0.tag, slotID1: slot1.tag, isForced: false) { [weak self] isSuccess in
            guard let `self` = self else { return }

            guard isSuccess else {
                // Error - reset selection UI
                self.resetSelection(button: slot0, slot: slot1)
                self.shakeButtons([slot0, slot1])
                return
            }

            // If evaluation is successful, make a copy of the button
            let copy = slot0.createCopy()
            copy.frame = stackView1.convert(slot0.frame, to: self.contentView)
            self.contentView.addSubview(copy)

            // Hide the original button - use alpha instead of removing to maintain arranged subviews positions
            slot0.alpha = 0

            // Animate the buttons moving
            UIView.animate(withDuration: 0.3, animations: {
                copy.frame.origin = stackView2.convert(slot1.frame, to: self.contentView).origin
            }) { _ in
                slot1.copyData(from: copy)
                // Remove copy
                copy.removeFromSuperview()
            }

            // Reset selection UI
            self.resetSelection(button: slot0, slot: slot1)
        }
    }
}

