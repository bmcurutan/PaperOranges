//
//  InfoViewController.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/10/21.
//

import UIKit

class InfoViewController: UIViewController {
	private var viewModel: InfoViewModel

	private var tableView: UITableView = {
		let tableView = UITableView()
		tableView.alwaysBounceVertical = false
		tableView.backgroundColor = .backgroundColor
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()

	init(viewModel: InfoViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .backgroundColor

		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: "DescriptionCell")
		tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: "PersonCell")
		tableView.register(TextLinkTableViewCell.self, forCellReuseIdentifier: "TextLinkCell")
		tableView.register(ButtonsTableViewCell.self, forCellReuseIdentifier: "ButtonsCell")
		tableView.separatorStyle = .none

		view.addSubview(tableView)
		tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
		tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
		view.rightAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
	}
}

extension InfoViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.sections[section].rows.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = viewModel.sections[indexPath.section].rows[indexPath.row]
		switch row {
		case let .description(title, description):
			let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionTableViewCell
			cell.title = title
			cell.descriptionText = description
			return cell
		case let .person(image, role, details):
			let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell") as! PersonTableViewCell
			cell.roundImage = image
			cell.role = role
			cell.details = details
			return cell
		case let .buttons(buttons):
			let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonsCell") as! ButtonsTableViewCell
			cell.delegate = self
			cell.addButtons(buttons)
			return cell
		case let .textLink(text, link):
			let cell = tableView.dequeueReusableCell(withIdentifier: "TextLinkCell") as! TextLinkTableViewCell
			cell.delegate = self
			cell.displayText = text
			cell.link = link
			return cell
		}
	}
}

extension InfoViewController: UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.sections.count 
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let infoSection = viewModel.sections[section]
		if let image = infoSection.image {
			return HeroView(image: image, title: infoSection.title ?? "")
		} else if let title = infoSection.title {
			return SectionHeaderView(title: title)
		} else {
			return UIView()
		}
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		let infoSection = viewModel.sections[section]
		return infoSection.image != nil || infoSection.title != nil ? UITableView.automaticDimension : .leastNonzeroMagnitude
	}
}

extension InfoViewController: TextLinkTableViewCellDelegate {
	func openURL(_ url: URL) {
		UIApplication.shared.open(url)
	}
}

extension InfoViewController: ButtonsTableViewCellDelegate {
	func evaluateAndSwap(sortId0: Int, sortId1: Int, with completion: ((Bool) -> Void)?) {
		// Do nothing
	}

	func linkButtonTapped(_ sender: LinkButton) {
		if let url = sender.url {
			openURL(url)
		}
	}
}

protocol TextLinkTableViewCellDelegate {
	func openURL(_ url: URL)
}

private class TextLinkTableViewCell: UITableViewCell {
	var delegate: TextLinkTableViewCellDelegate?

	var displayText: String? {
		didSet {
			linkButton.setTitle(displayText, for: .normal)
		}
	}

	var link: String? {
		didSet {
			if let _ = link {
				linkButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
				linkButton.setTitleColor(.accentColor, for: .normal)
				linkButton.setTitleColor(.secondaryAccentColor, for: .highlighted)
			} else {
				linkButton.isUserInteractionEnabled = false
			}
		}
	}

	private var linkButton: UIButton = {
		let button = UIButton()
		button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
		button.titleLabel?.textAlignment = .center
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitleColor(.primaryTextColor, for: .normal)
		return button
	}()
	private var linkLabelTopConstraint: NSLayoutConstraint?
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .backgroundColor

		contentView.addSubview(linkButton)
		linkButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		linkButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		contentView.bottomAnchor.constraint(equalTo: linkButton.bottomAnchor).isActive = true
		contentView.rightAnchor.constraint(equalTo: linkButton.rightAnchor, constant: 16).isActive = true
		linkButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
		linkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc private func buttonTapped() {
		if let link = link,
		   let url = URL(string: link) {
			delegate?.openURL(url)
		}
	}
}
