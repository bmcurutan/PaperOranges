//
//  HomeViewController.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/9/21.
//

import UIKit

// TODO2 support dark mode
class HomeViewController: UIViewController {
	private var viewModel = HomeViewModel()

	private var heroImageView: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "hr_home"))
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private var tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .backgroundColor

		let rightButton: UIButton = {
            let image = #imageLiteral(resourceName: "ic_info")
			let button = UIButton(type: .custom)
			button.tintColor = .accentColor
            button.setImage(image.withTintColor(.accentColor, renderingMode: .alwaysTemplate), for: .normal)
			button.setImage(image.withTintColor(.secondaryAccentColor, renderingMode: .alwaysTemplate), for: .highlighted)
			button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
			return button
		}()
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
		navigationItem.rightBarButtonItem?.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
		navigationItem.rightBarButtonItem?.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true

		tableView.dataSource = self
		tableView.delegate = self
		tableView.backgroundColor = .backgroundColor // Keep this in viewDidLoad
		tableView.register(TopicTableViewCell.self, forCellReuseIdentifier: "TopicCell")
		tableView.separatorStyle = .none

		view.addSubview(heroImageView)
		heroImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		heroImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		heroImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
		view.rightAnchor.constraint(equalTo: heroImageView.rightAnchor).isActive = true

		view.addSubview(tableView)
		tableView.topAnchor.constraint(equalTo: heroImageView.bottomAnchor).isActive = true
		tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
		view.rightAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
	}

	@objc private func menuButtonTapped() {
		present(InfoViewController(viewModel: MenuInfoViewModel()), animated: true, completion: nil)
	}
}

extension HomeViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.sections[section].topics.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath) as! TopicTableViewCell
		cell.delegate = self
		cell.topic = viewModel.sections[indexPath.section].topics[indexPath.row]
		return cell
	}
}

extension HomeViewController: UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.sections.count
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if let title = viewModel.sections[section].title {
			let header = SectionHeaderView(title: title)
			header.delegate = self
			return header
		} else {
			return UIView()
		}
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return viewModel.sections[section].title != nil ? UITableView.automaticDimension : .leastNonzeroMagnitude
	}
}

extension HomeViewController: TopicTableViewCellDelegate {
	func buttonTapped(topic: Topic) {
		guard topic.isActive else { return }
		switch topic.type {
		case .bubbleSort:
			navigationController?.pushViewController(SortingViewController(viewModel: BubbleSortViewModel(), title: topic.title), animated: true)
		case .insertionSort:
			navigationController?.pushViewController(SortingViewController(viewModel: InsertionSortViewModel(), title: topic.title), animated: true)
		default:
			break
		}
	}
}

extension HomeViewController: SectionHeaderViewDelegate {
	func infoButtonTapped() {
		present(InfoViewController(viewModel: SortingInfoViewModel()), animated: true, completion: nil)
	}
}

protocol TopicTableViewCellDelegate {
	func buttonTapped(topic: Topic)
}

private class TopicTableViewCell: UITableViewCell {
	var delegate: TopicTableViewCellDelegate?

	var topic: Topic? = nil {
		didSet {
			guard let topic = topic else { return }
			roundImageView.image = topic.image
			button.setTitle(topic.title, for: .normal)
			if let text = topic.text {
				button.setTitle("\(topic.title)\n\(text)", for: .normal)
			} else {
				button.setTitle(topic.title, for: .normal)
			}
			if !topic.isActive {
				button.layer.borderColor = UIColor.borderColor.cgColor
				button.setTitleColor(.secondaryTextColor, for: .normal)
				button.isEnabled = false
			}
			checkmarkView.isHidden = !topic.isCompleted
		}
	}

	var button: RoundedButton = {
		let button = RoundedButton()
		button.backgroundColor = .white
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	private var roundImageView: RoundImageView = {
		let imageView = RoundImageView()
        imageView.backgroundColor = .backgroundColor
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private var checkmarkView: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "ic_checkmark").withRenderingMode(.alwaysTemplate))
		imageView.isHidden = true
		imageView.tintColor = .primaryButtonColor
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .backgroundColor
		selectedBackgroundView = UIView()

		contentView.addSubview(button)
		button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		button.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		contentView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 8).isActive = true
		contentView.rightAnchor.constraint(equalTo: button.rightAnchor, constant: 16).isActive = true

		button.addSubview(roundImageView)
		roundImageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 8).isActive = true
		roundImageView.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 16).isActive = true
		button.bottomAnchor.constraint(greaterThanOrEqualTo: roundImageView.bottomAnchor, constant: 8).isActive = true
		roundImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
		roundImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true

		button.addSubview(checkmarkView)
		button.rightAnchor.constraint(equalTo: checkmarkView.rightAnchor, constant: 16).isActive = true
		checkmarkView.centerYAnchor.constraint(equalTo: roundImageView.centerYAnchor).isActive = true
		checkmarkView.widthAnchor.constraint(equalToConstant: 20).isActive = true
		checkmarkView.heightAnchor.constraint(equalToConstant: 20).isActive = true

		button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc private func buttonTapped() {
		if let topic = topic {
			delegate?.buttonTapped(topic: topic)
		}
	}
}
