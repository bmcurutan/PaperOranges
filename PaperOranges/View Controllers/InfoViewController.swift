//
//  InfoViewController.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/10/21.
//

import UIKit

// TODO resize modal to fit content
class InfoViewController: UIViewController {
	private var viewModel: InfoViewModel

	private var tableView: UITableView = {
		let tableView = UITableView()
		tableView.tableFooterView = UIView()
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
		tableView.register(HeroTableViewCell.self, forCellReuseIdentifier: "HeroCell")
		tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: "DescriptionCell")
		tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: "PersonCell")
		tableView.separatorStyle = .none

		view.addSubview(tableView)
		tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
		tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24).isActive = true
		view.rightAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
	}
}

extension InfoViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.rows.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = viewModel.rows[indexPath.row]
		switch row.type {
		case let .hero(image, title):
			let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell") as! HeroTableViewCell
			cell.heroImage = image
			cell.title = title
			return cell
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
		}
	}
}

extension InfoViewController: UITableViewDelegate {
}

private class HeroTableViewCell: UITableViewCell {
	var heroImage: UIImage? {
		didSet {
			heroView.image = heroImage
		}
	}

	var title: String? {
		didSet {
			heroView.title = title
		}
	}

	private var heroView: HeroView = {
		let view = HeroView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private var handleBar: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 2
		view.backgroundColor = UIColor.borderColor.withAlphaComponent(0.4)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.widthAnchor.constraint(equalToConstant: 32).isActive = true
		view.heightAnchor.constraint(equalToConstant: 4).isActive = true
		return view
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .backgroundColor

		contentView.addSubview(handleBar)
		handleBar.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		handleBar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

		contentView.addSubview(heroView)
		heroView.topAnchor.constraint(equalTo: handleBar.bottomAnchor, constant: 8).isActive = true
		heroView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: heroView.bottomAnchor).isActive = true
		contentView.rightAnchor.constraint(equalTo: heroView.rightAnchor).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private class PersonTableViewCell: UITableViewCell {
	var roundImage: UIImage? {
		didSet {
			roundImageView.image = roundImage
		}
	}

	var role: String? {
		didSet {
			roleLabel.text = role?.uppercased()
		}
	}

	var details: String? {
		didSet {
			detailsLabel.text = details
		}
	}

	private var borderedView: UIView = {
		let view = UIView()
		view.layer.borderColor = UIColor.borderColor.cgColor
		view.layer.borderWidth = 1
		view.layer.cornerRadius = 16
		view.clipsToBounds = true
		view.backgroundColor = .white
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private var roundImageView: RoundedImageView = {
		let imageView = RoundedImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.widthAnchor.constraint(equalToConstant: 56).isActive = true // TODO math
		imageView.heightAnchor.constraint(equalToConstant: 56).isActive = true // TODO math
		return imageView
	}()

	private var roleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 12)
		label.textColor = .accentColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private var detailsLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .backgroundColor

		contentView.addSubview(borderedView)
		borderedView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		borderedView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		contentView.bottomAnchor.constraint(equalTo: borderedView.bottomAnchor, constant: 8).isActive = true
		contentView.rightAnchor.constraint(equalTo: borderedView.rightAnchor, constant: 16).isActive = true

		borderedView.addSubview(roundImageView)
		roundImageView.topAnchor.constraint(equalTo: borderedView.topAnchor, constant: 8).isActive = true
		roundImageView.leftAnchor.constraint(equalTo: borderedView.leftAnchor, constant: 16).isActive = true
		borderedView.bottomAnchor.constraint(greaterThanOrEqualTo: roundImageView.bottomAnchor, constant: 8).isActive = true

		borderedView.addSubview(roleLabel)
		roleLabel.topAnchor.constraint(equalTo: borderedView.topAnchor, constant: 8).isActive = true
		roleLabel.leftAnchor.constraint(equalTo: roundImageView.rightAnchor, constant: 8).isActive = true
		borderedView.rightAnchor.constraint(equalTo: roleLabel.rightAnchor, constant: 16).isActive = true

		borderedView.addSubview(detailsLabel)
		detailsLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 4).isActive = true
		detailsLabel.leftAnchor.constraint(equalTo: roundImageView.rightAnchor, constant: 8).isActive = true
		borderedView.bottomAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 8).isActive = true
		borderedView.rightAnchor.constraint(equalTo: detailsLabel.rightAnchor, constant: 16).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private class DescriptionTableViewCell: UITableViewCell {
	var title: String? {
		didSet {
			titleLabel.text = title?.uppercased()
		}
	}

	var descriptionText: String? {
		didSet {
			descriptionLabel.text = descriptionText
		}
	}

	private var borderedView: UIView = {
		let view = UIView()
		view.layer.borderColor = UIColor.borderColor.cgColor
		view.layer.borderWidth = 1
		view.layer.cornerRadius = 16
		view.clipsToBounds = true
		view.backgroundColor = .white
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 12)
		label.textColor = .accentColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private var descriptionLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .backgroundColor

		contentView.addSubview(borderedView)
		borderedView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		borderedView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		contentView.bottomAnchor.constraint(equalTo: borderedView.bottomAnchor, constant: 8).isActive = true
		contentView.rightAnchor.constraint(equalTo: borderedView.rightAnchor, constant: 16).isActive = true

		borderedView.addSubview(titleLabel)
		titleLabel.topAnchor.constraint(equalTo: borderedView.topAnchor, constant: 8).isActive = true
		titleLabel.leftAnchor.constraint(equalTo: borderedView.leftAnchor, constant: 16).isActive = true
		borderedView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 16).isActive = true

		borderedView.addSubview(descriptionLabel)
		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
		descriptionLabel.leftAnchor.constraint(equalTo: borderedView.leftAnchor, constant: 16).isActive = true
		borderedView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
		borderedView.rightAnchor.constraint(equalTo: descriptionLabel.rightAnchor, constant: 16).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
