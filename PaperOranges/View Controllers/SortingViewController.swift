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
		// Don't show ending message for first or lats steps
		return currentStepIndex == 0 || currentStepIndex == viewModel.steps.count - 1 ? nil : viewModel.endingMessage
	}

	private var currentStepIndex: Int = 0 
	private var currentStep: Step {
		return viewModel.steps[currentStepIndex]
	}

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
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ⓘ", style: .plain, target: self, action: #selector(infoButtonTapped))

		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(SpeakerTableViewCell.self, forCellReuseIdentifier: "SpeakerCell")
		tableView.register(ButtonsTableViewCell.self, forCellReuseIdentifier: "ButtonsCell")
		tableView.register(StepsTableViewCell.self, forCellReuseIdentifier: "StepsCell")
		tableView.separatorStyle = .none

		view.addSubview(tableView)
		tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		view.rightAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
		view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
	}

	@objc private func infoButtonTapped() {
		present(InfoViewController(viewModel: BubbleSortInfoViewModel()), animated: true, completion: nil)
	}
}

extension SortingViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let section = viewModel.sections[indexPath.section]
		switch section {
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
		return viewModel.sections.count
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		switch viewModel.sections[section] {
		case let .steps(title):
			return SectionHeaderView(title: title)
		default:
			return UIView()
		}
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch viewModel.sections[section] {
		case .steps(_):
			return UITableView.automaticDimension
		default:
			return .leastNonzeroMagnitude
		}
	}
}

extension SortingViewController: ButtonsTableViewCellDelegate {
	func evaluateAndSwap(id0: Int, id1: Int, with completion: ((Bool) -> Void)?) {
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

			// Reload speaker section first so it appears less jumpy
			let indexSet = IndexSet(viewModel.sections.filter({
				switch $0 {
				case .speaker:
					return true
				default:
					return false
				}
			}).indices)
			tableView.reloadSections(indexSet, with: .automatic)

			// If current step index is > 0, there is at least one completed step so add steps section
			if currentStepIndex > 0, viewModel.sections.filter({
				switch $0 {
				case .steps:
					return true
				default:
					return false
				}
			   }).count == 0 {
				viewModel.sections.append(viewModel.stepsSection)
			}
			tableView.reloadDataAfterDelay { [weak self] in
				guard let `self` = self else { return }
				// Last successful step - show confetti!
				if self.currentStepIndex == self.viewModel.steps.count - 1 {
					self.confettiView.frame = self.view.bounds
					self.view.addSubview(self.confettiView)
					self.confettiView.startConfetti()
					self.perform(#selector(self.stopConfetti), with: nil, afterDelay: 1.0)
				}
			}

		} else {
			// Don't need to error out for the last step - nothing else to do
			guard currentStepIndex != viewModel.steps.count - 1 else { return }

			// Incorrect solution
			speechTitle = .error
			let indexSet = IndexSet(viewModel.sections.filter({
				switch $0 {
				case .speaker:
					return true
				default:
					return false
				}
			}).indices)
			tableView.reloadSections(indexSet, with: .automatic)
			completion?(false)
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

	private var speakerImageView: RoundImageView = {
		let imageView = RoundImageView(image: #imageLiteral(resourceName: "av_sorting_vanilla"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .backgroundColor

		contentView.addSubview(speakerImageView)
		speakerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
		speakerImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		speakerImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
		speakerImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true

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
