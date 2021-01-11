//
//  HomeViewController.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/9/21.
//

import UIKit

class HomeViewController: UIViewController {
	private var viewModel = HomeViewModel()

	private var heroImageView: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "hr_home"))
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private var tableView: UITableView = {
		let tableView = UITableView()
		tableView.tableFooterView = UIView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		navigationController?.navigationBar.barTintColor = .white
		navigationController?.navigationBar.tintColor = .accentColor
		navigationController?.navigationBar.shadowImage = UIImage()

		let rightButton: UIButton = {
			let button = UIButton(type: .custom)
			button.tintColor = .accentColor
			button.setImage(#imageLiteral(resourceName: "ic_menu").withRenderingMode(.alwaysTemplate), for: .normal)
			button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
			return button
		}()
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
		navigationItem.rightBarButtonItem?.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
		navigationItem.rightBarButtonItem?.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true

		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(TopicTableViewCell.self, forCellReuseIdentifier: "TopicCell")
		tableView.separatorStyle = .none

		view.addSubview(heroImageView)
		heroImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		heroImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		view.rightAnchor.constraint(equalTo: heroImageView.rightAnchor).isActive = true

		let newHeight = heroImageView.frame.height / heroImageView.frame.width * UIScreen.main.bounds.width
		heroImageView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true

		view.addSubview(tableView)
		tableView.topAnchor.constraint(equalTo: heroImageView.bottomAnchor).isActive = true
		tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24).isActive = true
		view.rightAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
	}

	@objc private func menuButtonTapped() {
		present(MenuViewController(), animated: true, completion: nil)
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
		default:
			break
		}
	}
}

extension HomeViewController: SectionHeaderViewDelegate {
	func infoButtonTapped() {
		present(InfoViewController(viewModel: HomeInfoViewModel()), animated: true, completion: nil)
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
			buttonImageView.image = topic.image
			buttonLabel.text = topic.title
			if let text = topic.text {
				buttonLabel.text?.append("\n\(text)")
			}
			if !topic.isActive {
				button.layer.borderColor = UIColor.secondaryTextColor.cgColor
				buttonLabel.textColor = .secondaryTextColor
			}
		}
	}

	var button: UIButton = {
		let button = UIButton()
		button.layer.borderColor = UIColor.primaryButtonColor.cgColor
		button.layer.borderWidth = 1
		button.layer.cornerRadius = 16
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
		// TODO add button highlighting on select
	}()

	private var buttonImageView: RoundedImageView = {
		let imageView = RoundedImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
		imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
		return imageView
	}()

	private var buttonLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 16.0)
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.textColor = .primaryButtonColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectedBackgroundView = UIView()

		contentView.addSubview(button)
		button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		button.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		contentView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 8).isActive = true
		contentView.rightAnchor.constraint(equalTo: button.rightAnchor, constant: 16).isActive = true

		button.addSubview(buttonImageView)
		buttonImageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 8).isActive = true
		buttonImageView.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 16).isActive = true
		button.bottomAnchor.constraint(greaterThanOrEqualTo: buttonImageView.bottomAnchor, constant: 8).isActive = true

		button.addSubview(buttonLabel)
		buttonLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: 8).isActive = true
		buttonLabel.leftAnchor.constraint(equalTo: buttonImageView.rightAnchor, constant: 16).isActive = true
		button.bottomAnchor.constraint(equalTo: buttonLabel.bottomAnchor, constant: 8).isActive = true
		button.rightAnchor.constraint(equalTo: buttonLabel.rightAnchor, constant: 16).isActive = true
		button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc private func buttonTapped() {
		if let topic = topic {
			delegate?.buttonTapped(topic: topic) // TODO2 add some sort of button tap UI
		}
	}
}

