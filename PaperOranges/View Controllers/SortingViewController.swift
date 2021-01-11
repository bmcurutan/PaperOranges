//
//  SortingViewController.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/9/21.
//

import UIKit

// TODO move some things out of this file -  it's too long now

class SortingViewController: UIViewController {
	private var viewModel: SortingViewModel

	private var speechTitle: SpeechTitle = .start
	private var speechEnding: String? {
		// Don't show ending message for first or lats steps
		return currentStepIndex == 0 || currentStepIndex == viewModel.steps.count - 1 ? nil : viewModel.endingMessage
	}

	private var currentStepIndex: Int = 0 // TODO move to shared prefs? or just put a warning on the back button "are you sure? you will lose your progress"
	private var currentStep: Step {
		return viewModel.steps[currentStepIndex]
	}

	private var tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .clear
		tableView.tableFooterView = UIView()
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
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ⓘ", style: .plain, target: self, action: #selector(infoButtonTapped))

		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(SpeakerTableViewCell.self, forCellReuseIdentifier: "SpeakerCell")
		tableView.register(ButtonsTableViewCell.self, forCellReuseIdentifier: "ButtonsCell")
		tableView.register(StepsTableViewCell.self, forCellReuseIdentifier: "StepsCell")
		tableView.separatorStyle = .none

		view.addSubview(tableView)
		tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
		tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		view.rightAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
		view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24).isActive = true
	}

	@objc private func infoButtonTapped() {
		present(InfoViewController(viewModel: BubbleSortInfoViewModel()), animated: true, completion: nil)
	}
}

extension SortingViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch viewModel.sections[section].type {
		case .speaker, .buttons:
			return 1
		case .steps:
			return 1
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let section = viewModel.sections[indexPath.section]
		switch section.type {
		case .speaker:
			let cell = tableView.dequeueReusableCell(withIdentifier: "SpeakerCell", for: indexPath) as! SpeakerTableViewCell
			var title: String?
			switch speechTitle {
			case .start:
				title = viewModel.startMessage
			case .success:
				title = viewModel.successMessage
			case .error:
				title = viewModel.errorMessage
			case .none:
				title = nil
			}
			cell.setText(title: title, text: currentStep.speech, ending: speechEnding)
			return cell
		case .buttons:
			let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonsCell", for: indexPath) as! ButtonsTableViewCell
			cell.delegate = self
			cell.addButtons(viewModel.sortingButtons)
			return cell
		case .steps:
			let cell = tableView.dequeueReusableCell(withIdentifier: "StepsCell", for: indexPath) as! StepsTableViewCell
			// Completed steps are steps up to (but not including) current step
			let endIndex = currentStepIndex - 1
			if viewModel.steps.indices.contains(endIndex) {
				cell.stepsText = viewModel.steps[0...endIndex].map { $0.completedText }
			}
			return cell
		}
	}
}

extension SortingViewController: UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		// If current step index is 0, there are no completed steps
		return viewModel.sections.count - (currentStepIndex == 0 ? 1 : 0)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if let title = viewModel.sections[section].title {
			return SectionHeaderView(title: title)
		} else {
			return UIView()
		}
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return viewModel.sections[section].title != nil ? UITableView.automaticDimension : .leastNonzeroMagnitude
	}
}

// TODO2 scale so one button is "behind" the other one, add interpolator curve
extension SortingViewController: ButtonsTableViewCellDelegate {
	func evaluate(id0: Int, id1: Int, with completion: ((Bool) -> Void)?) {
		let solution = currentStep.solution
		if (id0 == solution.0 && id1 == solution.1) || (id1 == solution.0 && id0 == solution.1) {
			// Successful solution
			speechTitle = .success

			// If the buttons are already in order, do nothing
			// i.e., treat like an incorrect solution
			if id0 < id1 {
				completion?(false)
			} else {
				// Update data (swap buttons)
				if let index0 = viewModel.sortingButtons.firstIndex(where: { $0.id == id0 }),
					let index1 = viewModel.sortingButtons.firstIndex(where: { $0.id == id1 }) {
					viewModel.sortingButtons.swapAt(index0, index1)
				}
				completion?(true)
			}

			currentStepIndex += 1
			tableView.reloadDataAfterDelay() // Use a delay to give the button swap animation time to complete

			// Last successful step - show confetti!
			if currentStepIndex == viewModel.steps.count - 1 {
				confettiView.frame = view.bounds
				view.addSubview(confettiView)
				confettiView.startConfetti()
				perform(#selector(stopConfetti), with: nil, afterDelay: 1.0)
			}

		} else {
			// Don't need to error out for last step - nothing else to do
			guard currentStepIndex != viewModel.steps.count - 1 else { return }

			// Incorrect solution
			speechTitle = .error
			if let speakerSection = viewModel.sections.firstIndex(where: { $0.type == .speaker }) {
				let indexSet: IndexSet = [speakerSection]
				tableView.reloadSections(indexSet, with: .automatic)
				completion?(false)
			}
		}
	}

	@objc private func stopConfetti(_ view: SAConfettiView) {
		confettiView.stopConfetti()
		confettiView.perform(#selector(UIView.removeFromSuperview), with: nil, afterDelay: 2.0)
	}
}

private class SpeakerTableViewCell: UITableViewCell {
	private var speechBubbleView: UIView = {
		let imageView = UIImageView()
		imageView.layer.borderColor = UIColor.lightGray.cgColor
		imageView.layer.borderWidth = 1
		imageView.layer.cornerRadius = 16
		imageView.backgroundColor = .white
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private var speechBubbleLabel: UILabel = {
		let label = UILabel()
		label.font = label.font.withSize(14.0)
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.textColor = .primaryTextColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private var speakerImageView: RoundedImageView = {
		let imageView = RoundedImageView(image: #imageLiteral(resourceName: "av_sorting_vanilla"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
		imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
		return imageView
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .backgroundColor

		contentView.addSubview(speakerImageView)
		speakerImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		speakerImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true

		contentView.addSubview(speechBubbleView)
		speechBubbleView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		speechBubbleView.leftAnchor.constraint(equalTo: speakerImageView.rightAnchor, constant: 8).isActive = true
		contentView.rightAnchor.constraint(equalTo: speechBubbleView.rightAnchor, constant: 16).isActive = true
		contentView.bottomAnchor.constraint(equalTo: speechBubbleView.bottomAnchor).isActive = true

		speechBubbleView.addSubview(speechBubbleLabel)
		speechBubbleLabel.topAnchor.constraint(equalTo: speechBubbleView.topAnchor, constant: 8).isActive = true
		speechBubbleLabel.leftAnchor.constraint(equalTo: speechBubbleView.leftAnchor, constant: 8).isActive = true
		speechBubbleView.bottomAnchor.constraint(equalTo: speechBubbleLabel.bottomAnchor, constant: 8).isActive = true
		speechBubbleView.rightAnchor.constraint(equalTo: speechBubbleLabel.rightAnchor, constant: 8).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setText(title: String? = nil, text: String, ending: String? = nil) {
		let attributedText = NSMutableAttributedString(string: "")
		if let title = title {
			attributedText.append(NSMutableAttributedString(string: "\(title)\n\n").setTextColor(.accentColor))
		}
		attributedText.append(text)
		if let ending = ending {
			attributedText.append("\n\n\(ending)")
		}
		speechBubbleLabel.attributedText = attributedText
	}
}

protocol ButtonsTableViewCellDelegate {
	func evaluate(id0: Int, id1: Int, with completion: ((Bool) -> Void)?)
}

private class ButtonsTableViewCell: UITableViewCell {
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
		// Reset stack view
		stackView.arrangedSubviews.forEach {
			$0.removeFromSuperview()
		}

		self.buttons = buttons
		buttons.forEach {
			let button = RoundImageAndLabelButton()
			button.delegate = self
			button.tag = $0.id
			button.image = $0.image
			button.name = $0.name
			button.isSelected = $0.isSelected
			stackView.addArrangedSubview(button)
		}
	}
}

// TODO2 on button long press, scale up??
extension ButtonsTableViewCell: RoundImageAndLabelButtonDelegate {
	func buttonTapped(_ sender: RoundImageAndLabelButton) {
		if let index = buttons.firstIndex(where: { $0.id == sender.tag }) {
			buttons[index].isSelected = sender.isSelected
		}

		// If two buttons are selected, determine the associated indices and button views
		if buttons.filter({ $0.isSelected }).count == 2,
		    let index0 = buttons.firstIndex(where: { $0.isSelected }),
		    index0 < buttons.count - 1,
		    let index1 = buttons[index0 + 1...buttons.count - 1].firstIndex(where: { $0.isSelected }),
			let button0 = stackView.arrangedSubviews[index0] as? RoundImageAndLabelButton,
			let button1 = stackView.arrangedSubviews[index1] as? RoundImageAndLabelButton {

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

	private func resetButtonSelection(button0: RoundImageAndLabelButton, button1: RoundImageAndLabelButton) {
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

private class StepsTableViewCell: UITableViewCell {
	var stepsText: [String] = [] {
		didSet {
			addSteps()
		}
	}

	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fillProportionally
		stackView.spacing = 8
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		contentView.addSubview(stackView)
		stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
		stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8).isActive = true
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
			stackView.addArrangedSubview(StepView($0, count: stackView.arrangedSubviews.count))
		}
	}
}

private class StepView: UIView {
	private var stepLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14.0)
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.textColor = .primaryTextColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	init(_ step: String, count: Int) {
		self.init()
		stepLabel.text = "\(count + 1). \(step)"
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white

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
