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
		return viewModel.rows.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let info = viewModel.rows[indexPath.row]
		switch info {
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
		default:
			return UITableViewCell()
		}
	}
}

extension InfoViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		switch viewModel.hero {
		case let .hero(image, title):
			let view = HeroView(image: image, title: title)
			return view
		default:
			return UIView()
		}
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch viewModel.hero {
		case .hero(_, _):
			return UITableView.automaticDimension
		default:
			return .leastNonzeroMagnitude
		}
	}
}
