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
	private var isCompletedCurrently: Bool = false // Detects if sorting game was completed during current instance

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

		let rightButton: UIButton = {
            let image = #imageLiteral(resourceName: "ic_help")
            let button = UIButton(type: .custom)
            button.setImage(image.withTintColor(.accentColor, renderingMode: .alwaysTemplate), for: .normal)
            button.setImage(image.withTintColor(.secondaryAccentColor, renderingMode: .alwaysOriginal), for: .highlighted)
			button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
			return button
		}()
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
		navigationItem.rightBarButtonItem?.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
		navigationItem.rightBarButtonItem?.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true

		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(SpeakerTableViewCell.self, forCellReuseIdentifier: "SpeakerCell")
		tableView.register(BubbleSortButtonsTableViewCell.self, forCellReuseIdentifier: "BubbleSortButtonsCell")
		tableView.register(InsertionSortButtonsTableViewCell.self, forCellReuseIdentifier: "InsertionSortButtonsCell")
		tableView.register(StepsTableViewCell.self, forCellReuseIdentifier: "StepsCell")
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
			viewModel.addStepsSection()
		}
	}

	@objc private func infoButtonTapped() {
		switch viewModel.id {
		case .bubbleSort:
			present(InfoViewController(viewModel: BubbleSortInfoViewModel()), animated: true, completion: nil)
		case .insertionSort:
			present(InfoViewController(viewModel: InsertionSortInfoViewModel()), animated: true, completion: nil)
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
        default:
            break
        }
        isCompletedCurrently = true
    }

    private func reloadSection(_ section: SortingSection) {
        let indexSet = IndexSet(viewModel.sections.filter({ $0 == section }).indices)
        tableView.reloadSections(indexSet, with: .fade)
    }

    private func showConfetti() {
        guard isLastStep else { return }
        confettiView.frame = self.view.bounds
        view.addSubview(self.confettiView)
        confettiView.startConfetti()
        perform(#selector(self.stopConfetti), with: nil, afterDelay: 1.0)
    }

    @objc private func stopConfetti(_ view: SAConfettiView) {
        confettiView.stopConfetti()
        confettiView.perform(#selector(UIView.removeFromSuperview), with: nil, afterDelay: 2.0)
    }
}

extension SortingViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch viewModel.sections[indexPath.section] {
		case .speaker:
			return speakerCellForRow(at: indexPath)
		case .buttons:
			return buttonsCellForRow(at: indexPath)
		case .steps:
			return stepsCellForRow(at: indexPath)
		}
	}

	private func speakerCellForRow(at indexPath: IndexPath) -> SpeakerTableViewCell {
		// Overwrite current step speech if sorting game was completed
		var speech = currentStep.speech
		if UserDefaults.standard.bool(forKey: viewModel.id.rawValue) && !isCompletedCurrently {
			speech = viewModel.completedSpeech
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: "SpeakerCell", for: indexPath) as! SpeakerTableViewCell
		cell.delegate = self
		var title: String?
		switch speechTitle {
		case .start:
			title = viewModel.startMessage
		case .success:
			title = viewModel.successMessage
		case .error:
			title = viewModel.errorMessage
		case .completed:
			title = viewModel.completedMessage
		case .none:
			title = nil
		}
		cell.setText(title: title, text: speech, ending: speechEnding)
		return cell
	}

	private func buttonsCellForRow(at indexPath: IndexPath) -> UITableViewCell {
		switch viewModel.id {
		case .bubbleSort:
			let cell = tableView.dequeueReusableCell(withIdentifier: "BubbleSortButtonsCell", for: indexPath) as! BubbleSortButtonsTableViewCell
			cell.delegate = self
			cell.addButtons(viewModel.sortingButtons)
			// Disable all sorting buttons if sorting game was completed or user is on the last step
			if UserDefaults.standard.bool(forKey: viewModel.id.rawValue) || isLastStep {
				cell.disableAllButtons()
			}
			return cell
		case .insertionSort:
			let cell = tableView.dequeueReusableCell(withIdentifier: "InsertionSortButtonsCell", for: indexPath) as! InsertionSortButtonsTableViewCell
			cell.delegate = self
            cell.showLines()
			cell.addButtons(viewModel.sortingButtons)
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

	private func stepsCellForRow(at indexPath: IndexPath) -> StepsTableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "StepsCell", for: indexPath) as! StepsTableViewCell
		// Completed steps are steps up to (but not including) current step
		let endIndex = currentStepIndex - 1
		if viewModel.steps.indices.contains(endIndex) {
			cell.stepsText = viewModel.steps[0...endIndex].map { $0.stepText }
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
		case let .steps(title, _):
			return SectionHeaderView(title: title)
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
		if UserDefaults.standard.bool(forKey: viewModel.id.rawValue) && !isCompletedCurrently {
			// Reset to uncompleted state
			UserDefaults.standard.setValue(false, forKey: viewModel.id.rawValue)
			viewModel.removeStepsSection()
			speechTitle = .start
			currentStepIndex = 0
			tableView.reloadData()
		}
		// Otherwise do nothing
	}
}

extension SortingViewController: BubbleSortButtonsTableViewCellDelegate {
	func openURL(_ url: URL) {
		// Do nothing
	}

	func evaluate(sortID0: Int, sortID1: Int, with completion: ((Bool) -> Void)?) {
		let solution = currentStep.solution
		if (sortID0 == solution.0 && sortID1 == solution.1) || (sortID1 == solution.0 && sortID0 == solution.1) {
			// Successful solution
			speechTitle = .success
			// If buttons are already in order, do nothing
			// i.e., treat like an incorrect solution
			if sortID0 < sortID1 {
				completion?(false)
			} else {
				// Update button data (swap buttons)
				if let index0 = viewModel.sortingButtons.firstIndex(where: { $0.id == sortID0 }),
					let index1 = viewModel.sortingButtons.firstIndex(where: { $0.id == sortID1 }) {
					viewModel.sortingButtons.swapAt(index0, index1)
				}
				completion?(true)
			}
			currentStepIndex += 1

			// Reload speaker section first so it appears less jumpy
            reloadSection(.speaker)

			// If current step index is > 0, there is at least one completed step so add steps section
			if currentStepIndex > 0 {
				viewModel.addStepsSection()
			}
			tableView.reloadDataAfterDelay { [weak self] in
                self?.showConfetti()
			}
			saveCompletedProgress()

		} else {
			// Don't need to error out for the last step - nothing else to do
			guard currentStepIndex != viewModel.steps.count - 1 else { return }

			// Incorrect solution
			speechTitle = .error
            reloadSection(.speaker)
			completion?(false)
		}
	}
}

extension SortingViewController: InsertionSortButtonsTableViewCellDelegate {
	func showButtonsError(with completion: (() -> Void)?) {
        let alert = UIAlertController(title: viewModel.buttonsError, message: nil, preferredStyle: .alert)
        var textColor: UIColor = .primaryTextColor
        if traitCollection.userInterfaceStyle == .dark {
            textColor = .white
        }
        alert.setAttributedTitle(color: textColor)
        alert.view.tintColor = .accentColor
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
			completion?()
		}))
		present(alert, animated: true)
	}

	func showSlotsError(with completion: (() -> Void)?) {
        let alert = UIAlertController(title: viewModel.slotsError, message: nil, preferredStyle: .alert)
        alert.setAttributedTitle()
		alert.view.tintColor = .accentColor
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
			completion?()
		}))
		present(alert, animated: true)
	}

    func evaluate(buttonID: Int, slotID: Int, with completion: ((Bool) -> Void)?) {
        let solution = currentStep.solution
        if buttonID == solution.0 && slotID == solution.1 {
            // Successful solution
            speechTitle = .success

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

            // If current step index is > 0, there is at least one completed step so add steps section
            if currentStepIndex > 0 {
                viewModel.addStepsSection()
            }
            tableView.reloadDataAfterDelay { [weak self] in
                self?.showConfetti()
            }
            saveCompletedProgress()

        } else {
            // Don't need to error out for the last step - nothing else to do
            guard !isLastStep else { return }

            // Incorrect solution
            speechTitle = .error
            reloadSection(.speaker)
            completion?(false)
        }
    }
}
