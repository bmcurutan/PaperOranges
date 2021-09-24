//
//  SortingViewController.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/9/21.
//

import UIKit

class SortingViewController: UIViewController {
	private var viewModel: SortingViewModel

	private var speechTitle: SpeechTitle = .start
	private var speechEnding: String? {
		// Don't show ending message for first or last steps
		return currentStepIndex == 0 || currentStepIndex == viewModel.steps.count - 1 ? nil : viewModel.endingMessage
	}
	private var currentStepIndex: Int = 0 
	private var currentStep: Step {
        if viewModel.steps.indices.contains(currentStepIndex) {
            return viewModel.steps[currentStepIndex]
        } else {
            return Step() // Shouldn't happen
        }
	}
	private var isLastStep: Bool {
		// Only detect the last step if not also the first step
		return currentStepIndex != 0 && currentStepIndex == viewModel.steps.count - 1
	}
	private var isCurrentlyCompleted: Bool = false // Detects if sorting game was completed during current instance

	private var tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .backgroundColor
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()

	private var confettiView = SAConfettiView()

	init(viewModel: SortingViewModel, title: String) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		self.title = title
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .backgroundColor

        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "← Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton

		let rightButton: UIButton = {
            let image = #imageLiteral(resourceName: "ic_help")
            let button = UIButton(type: .custom)
            button.setImage(image.withTintColor(.accentColor, renderingMode: .alwaysTemplate), for: .normal)
            button.setImage(image.withTintColor(.secondaryAccentColor, renderingMode: .alwaysOriginal), for: .highlighted)
			button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
			return button
		}()
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem?.customView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        navigationItem.rightBarButtonItem?.customView?.heightAnchor.constraint(equalToConstant: 20).isActive = true

		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(SpeakerTableViewCell.self, forCellReuseIdentifier: "SpeakerCell")
		tableView.register(BubbleSortButtonsTableViewCell.self, forCellReuseIdentifier: "BubbleSortButtonsCell")
		tableView.register(InsertionSortButtonsTableViewCell.self, forCellReuseIdentifier: "InsertionSortButtonsCell")
        tableView.register(MergeSortButtonsTableViewCell.self, forCellReuseIdentifier: "MergeSortButtonsCell")
		tableView.register(StepTableViewCell.self, forCellReuseIdentifier: "StepCell")
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: "HelpButtonCell")
		tableView.separatorStyle = .none

		view.addSubview(tableView)
		tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		view.rightAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
		view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true

		// If sorting game was completed, show steps
		if UserDefaults.standard.bool(forKey: viewModel.id.rawValue) {
			speechTitle = .completed
			currentStepIndex = viewModel.steps.count - 1
		}
	}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !UserDefaults.standard.bool(forKey: viewModel.educationID) {
           // Show info modal
            infoButtonTapped()
            UserDefaults.standard.setValue(true, forKey: viewModel.educationID)
        }
    }

    @objc private func backButtonTapped() {
        let alert = UIAlertController(with: traitCollection.userInterfaceStyle, title: viewModel.backAlert, completion: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alert, animated: true)
    }

	@objc private func infoButtonTapped() {
		switch viewModel.id {
		case .bubbleSort:
			present(InfoViewController(viewModel: BubbleSortInfoViewModel()), animated: true, completion: nil)
		case .insertionSort:
			present(InfoViewController(viewModel: InsertionSortInfoViewModel()), animated: true, completion: nil)
        case .mergeSort:
            present(InfoViewController(viewModel: MergeSortInfoViewModel()), animated: true, completion: nil)
		default:
			break
		}
	}

    private func saveCompletedProgress() {
        guard isLastStep else { return }
        switch viewModel.id {
        case .bubbleSort:
            UserDefaults.standard.setValue(true, forKey: SortingID.bubbleSort.rawValue)
        case .insertionSort:
            UserDefaults.standard.setValue(true, forKey: SortingID.insertionSort.rawValue)
        case .mergeSort:
            UserDefaults.standard.setValue(true, forKey: SortingID.mergeSort.rawValue)
        default:
            break
        }
        isCurrentlyCompleted = true
    }

    private func reloadSection(_ section: SortingSection) {
        let indexSet = IndexSet(viewModel.sections.filter({ $0 == section }).indices)
        tableView.reloadSections(indexSet, with: .fade)
    }

    private func showConfetti() {
        confettiView.frame = self.view.bounds
        view.addSubview(self.confettiView)
        confettiView.startConfetti()
        perform(#selector(self.stopConfetti), with: nil, afterDelay: 1.0)
    }

    @objc private func stopConfetti(_ view: SAConfettiView) {
        confettiView.stopConfetti()
        confettiView.perform(#selector(UIView.removeFromSuperview), with: nil, afterDelay: 2.0)
    }

    private func showBasicAlert(with title: String?) {
        let alert = UIAlertController(with: traitCollection.userInterfaceStyle, title: title, completion: nil)
        present(alert, animated: true)
    }
}

extension SortingViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.sections[section] {
        case .steps:
            return viewModel.steps.count - 1
        default:
            return 1
        }
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch viewModel.sections[indexPath.section] {
		case .speaker:
			return speakerCellForRow(at: indexPath)
		case .buttons:
			return buttonsCellForRow(at: indexPath)
		case .steps:
			return stepCellForRow(at: indexPath)
        case .help:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HelpButtonCell", for: indexPath) as! ButtonTableViewCell
            cell.delegate = self
            cell.button.isHidden = currentStepIndex >= viewModel.steps.count - 1
            return cell
		}
	}

	private func speakerCellForRow(at indexPath: IndexPath) -> SpeakerTableViewCell {
		// Overwrite current step speech if sorting game was completed
		var speech = currentStep.speech
		if UserDefaults.standard.bool(forKey: viewModel.id.rawValue) && !isCurrentlyCompleted {
			speech = viewModel.completedSpeech
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: "SpeakerCell", for: indexPath) as! SpeakerTableViewCell
		cell.delegate = self
		var title: String?
        var hint: String?
		switch speechTitle {
		case .start:
			title = viewModel.startMessage
		case .success:
			title = viewModel.successMessage
		case .error:
			title = viewModel.errorMessage
            hint = viewModel.hintMessage
		case .completed:
			title = viewModel.completedMessage
        case .none:
			title = nil
		}
        cell.setText(title: title, hint: hint, text: speech, ending: speechEnding)
		return cell
	}

	private func buttonsCellForRow(at indexPath: IndexPath) -> UITableViewCell {
		switch viewModel.id {
		case .bubbleSort:
			let cell = tableView.dequeueReusableCell(withIdentifier: "BubbleSortButtonsCell", for: indexPath) as! BubbleSortButtonsTableViewCell
			cell.delegate = self
            if UserDefaults.standard.bool(forKey: viewModel.id.rawValue) {
                cell.addButtons(viewModel.solution)
            } else {
                cell.addButtons(viewModel.sortingButtons)
            }
			// Disable all sorting buttons if sorting game was completed or user is on the last step
			if UserDefaults.standard.bool(forKey: viewModel.id.rawValue) || isLastStep {
				cell.disableAllButtons()
			}
			return cell
		case .insertionSort:
			let cell = tableView.dequeueReusableCell(withIdentifier: "InsertionSortButtonsCell", for: indexPath) as! InsertionSortButtonsTableViewCell
			cell.delegate = self
            if UserDefaults.standard.bool(forKey: viewModel.id.rawValue) {
                cell.addButtons(viewModel.solution)
            } else {
                cell.addButtons(viewModel.sortingButtons)
            }
            cell.addSlots(viewModel.slotButtons)
			// Disable all sorting buttons if sorting game was completed or user is on the last step
			if UserDefaults.standard.bool(forKey: viewModel.id.rawValue) || isLastStep {
				cell.disableAllButtons()
			}
			return cell
        case .mergeSort:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MergeSortButtonsCell", for: indexPath) as! MergeSortButtonsTableViewCell
            cell.delegate = self
            if UserDefaults.standard.bool(forKey: viewModel.id.rawValue) {
                cell.addButtons(viewModel.solution)
            } else {
                cell.addButtons(viewModel.sortingButtons)
            }
            cell.addSlots(viewModel.slotButtons)
            // Disable all sorting buttons if sorting game was completed or user is on the last step
            if UserDefaults.standard.bool(forKey: viewModel.id.rawValue) || isLastStep {
                cell.disableAllButtons()
            }
            return cell
		default:
			return UITableViewCell() // Shouldn't happen
		}
	}

	private func stepCellForRow(at indexPath: IndexPath) -> StepTableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell", for: indexPath) as! StepTableViewCell
        // Only show completed steps
        if indexPath.row < currentStepIndex,
           let text = viewModel.steps[indexPath.row].stepText {
                cell.stepText = "\(indexPath.row + 1). \(text)"
        } else {
            cell.stepText = nil
            return cell
        }
		return cell
	}
}

extension SortingViewController: UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		switch viewModel.sections[section] {
		case .steps:
			let header = SectionHeaderView(title: "Steps")
            header.progressView.setProgress(Float(currentStepIndex) / Float(viewModel.steps.count - 1), animated: true)
            return header
		default:
			return UIView()
		}
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch viewModel.sections[section] {
		case .steps:
			return UITableView.automaticDimension
		default:
			return .leastNonzeroMagnitude
		}
	}
}

extension SortingViewController: SpeakerTableViewCellDelegate {
	func speechBubbleTapped() {
		if UserDefaults.standard.bool(forKey: viewModel.id.rawValue) && !isCurrentlyCompleted {
			// Reset to uncompleted state
			UserDefaults.standard.setValue(false, forKey: viewModel.id.rawValue)
			speechTitle = .start
			currentStepIndex = 0
			tableView.reloadData()
		}
	}
}

extension SortingViewController: ButtonTableViewCellDelegate {
    func buttonTapped() {
        if viewModel.steps.indices.contains(currentStepIndex) {
            let solution = viewModel.steps[currentStepIndex].solution
            switch viewModel.id {
            case .bubbleSort:
                evaluate(sortID0: solution.0, sortID1: solution.1, isForced: true, completion: nil)
            case .insertionSort:
                evaluate(buttonID: solution.0, slotID: solution.1, isForced: true, completion: nil)
            case .mergeSort:
                if solution.0 <= 8 {
                    evaluateButtonAndSlot(buttonID: solution.0, slotID: solution.1, isForced: true, completion: nil)
                } else {
                    evaluateSlots(slotID0: solution.0, slotID1: solution.1, isForced: true, completion: nil)
                }
            default:
                break
            }
        }
    }
}

extension SortingViewController: BubbleSortButtonsTableViewCellDelegate {
	func openURL(_ url: URL) {
		// Do nothing
	}

    func evaluate(sortID0: Int, sortID1: Int, isForced: Bool, completion: ((BubbleSortState) -> Void)?) {
		let solution = currentStep.solution
		if (sortID0 == solution.0 && sortID1 == solution.1) || (sortID1 == solution.0 && sortID0 == solution.1) {
			// Successful (or forced/help) solution
            speechTitle = isForced ? .none : .success
			// Buttons are already in order
			if sortID0 < sortID1 {
                completion?(.successNoSwap)
			} else {
				// Update button data (swap buttons)
				if let index0 = viewModel.sortingButtons.firstIndex(where: { $0.id == sortID0 }),
					let index1 = viewModel.sortingButtons.firstIndex(where: { $0.id == sortID1 }) {
					viewModel.sortingButtons.swapAt(index0, index1)
				}
                completion?(.successSwap)
			}
			currentStepIndex += 1

			// Reload speaker section first so it appears less jumpy
            reloadSection(.speaker)

			tableView.reloadDataAfterDelay { [weak self] in
                guard let `self` = self, self.isLastStep else { return }
                self.showConfetti()
                self.showBasicAlert(with: self.viewModel.completedAlert)
			}
			saveCompletedProgress()

		} else {
			// Don't need to error out for the last step - nothing else to do
			guard currentStepIndex != viewModel.steps.count - 1 else { return }

			// Incorrect solution
			speechTitle = .error
            reloadSection(.speaker)
            completion?(.error)
		}
	}
}

extension SortingViewController: InsertionSortButtonsTableViewCellDelegate {
    func showError() {
        speechTitle = .error
        reloadSection(.speaker)
    }

    func evaluate(buttonID: Int, slotID: Int, isForced: Bool, completion: ((Bool) -> Void)?) {
        let solution = currentStep.solution
        if buttonID == solution.0 && slotID == solution.1 {
            // Successful solution
            speechTitle = isForced ? .none : .success

            // Update button data
            if let buttonIndex = viewModel.sortingButtons.firstIndex(where: { $0.id == buttonID }),
                let slotIndex = viewModel.slotButtons.firstIndex(where: { $0.id == slotID }) {
                // If slot already has button data, shift everything to the right
                // Only need to check for image and name to coincide with copyData
                if viewModel.slotButtons[slotIndex].image != UIImage() && viewModel.slotButtons[slotIndex].name != nil {
                    var loopIndex = viewModel.slotButtons.count - 1
                    while loopIndex > slotIndex {
                        let previousSlot = viewModel.slotButtons[loopIndex - 1]
                        viewModel.slotButtons[loopIndex].image = previousSlot.image
                        viewModel.slotButtons[loopIndex].name = previousSlot.name
                        loopIndex -= 1
                    }
                }
                viewModel.slotButtons[slotIndex] = viewModel.sortingButtons[buttonIndex]
                viewModel.slotButtons[slotIndex].id = slotID // Restore original slot ID because it gets overwritten in addSlots
                viewModel.sortingButtons[buttonIndex] = ButtonData(id: -1, isHidden: true)
            }
            completion?(true)
            currentStepIndex += 1

            // Reload speaker section first so it appears less jumpy
            reloadSection(.speaker)

            tableView.reloadDataAfterDelay { [weak self] in
                guard let `self` = self, self.isLastStep else { return }
                self.showConfetti()
                self.showBasicAlert(with: self.viewModel.completedAlert)
            }
            saveCompletedProgress()

        } else {
            // Don't need to error out for the last step - nothing else to do
            guard !isLastStep else { return }

            // Incorrect solution
            showError()
            completion?(false)
        }
    }
}

extension SortingViewController: MergeSortButtonsTableViewCellDelegate {
    func showMergeSortError() {
        speechTitle = .error
        reloadSection(.speaker)
    }

    func evaluateButtonAndSlot(buttonID: Int, slotID: Int, isForced: Bool, completion: ((Bool) -> Void)?) {
        let solution = currentStep.solution
        if buttonID == solution.0 && slotID == solution.1 {
            // Successful solution
            speechTitle = isForced ? .none : .success

            // Update button data
            if let buttonIndex = viewModel.sortingButtons.firstIndex(where: { $0.id == buttonID }),
                let slotIndex = viewModel.slotButtons.firstIndex(where: { $0.id == slotID }) {
                // If slot already has button data, shift everything to the right
                // Only need to check for image and name to coincide with copyData
                if viewModel.slotButtons[slotIndex].image != UIImage() && viewModel.slotButtons[slotIndex].name != nil {
                    var loopIndex = viewModel.slotButtons.count - 1
                    while loopIndex > slotIndex {
                        let previousSlot = viewModel.slotButtons[loopIndex - 1]
                        viewModel.slotButtons[loopIndex].image = previousSlot.image
                        viewModel.slotButtons[loopIndex].name = previousSlot.name
                        loopIndex -= 1
                    }
                }
                viewModel.slotButtons[slotIndex] = viewModel.sortingButtons[buttonIndex]
                viewModel.slotButtons[slotIndex].id = slotID // Restore original slot ID because it gets overwritten in addSlots
                viewModel.sortingButtons[buttonIndex] = ButtonData(id: -1, isHidden: true)
            }
            completion?(true)
            currentStepIndex += 1

            // Reload speaker section first so it appears less jumpy
            reloadSection(.speaker)

            tableView.reloadDataAfterDelay { [weak self] in
                guard let `self` = self, self.isLastStep else { return }
                self.showConfetti()
                self.showBasicAlert(with: self.viewModel.completedAlert)
            }
            saveCompletedProgress()

        } else {
            // Don't need to error out for the last step - nothing else to do
            guard !isLastStep else { return }

            // Incorrect solution
            showError()
            completion?(false)
        }
    }

    func evaluateSlots(slotID0: Int, slotID1: Int, isForced: Bool, completion: ((Bool) -> Void)?) {
        let solution = currentStep.solution
        if slotID0 == solution.0 && slotID1 == solution.1 {
            // Successful solution
            speechTitle = .success

            // Update data
            if let slot0Index = viewModel.slotButtons.firstIndex(where: { $0.id == slotID0 }),
                let slot1Index = viewModel.slotButtons.firstIndex(where: { $0.id == slotID1 }) {
                viewModel.slotButtons[slot1Index] = viewModel.slotButtons[slot0Index]
                viewModel.slotButtons[slot1Index].id = slotID1 // Restore original slot ID because it gets overwritten in addSlots
                viewModel.slotButtons[slot0Index] = ButtonData(id: -1, isHidden: true)
            }
            completion?(true)
            currentStepIndex += 1

            // Reload speaker section first so it appears less jumpy
            reloadSection(.speaker)

            tableView.reloadDataAfterDelay { [weak self] in
                guard let `self` = self, self.isLastStep else { return }
                self.showConfetti()
                self.showBasicAlert(with: self.viewModel.completedAlert)
            }
            saveCompletedProgress()

        } else {
            // Don't need to error out for the last step - nothing else to do
            guard !isLastStep else { return }

            // Incorrect solution
            showError()
            completion?(false)
        }
    }
}
