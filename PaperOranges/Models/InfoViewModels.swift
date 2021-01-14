//
//  InfoViewModels.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/11/21.
//

import UIKit

protocol InfoViewModel {
	var hero: Info { get }
	var rows: [Info] { get }
}

class MenuInfoViewModel: InfoViewModel {
	var hero: Info = .hero(#imageLiteral(resourceName: "hr_home"), nil) // TODO1 change image

	var rows: [Info] = [
		.description("What is Paper Oranges?", "Paper Oranges is a community and storytelling platform to elevate the voices of people in tech.\n\nWe partner with creators of color to develop educational materials related to STEAM featuring a diverse cast of characters."),
		.person(#imageLiteral(resourceName: "av_christine_pham"), "Founder", "Christine is a Software Engineer at VMware, Inc. She is passionate about increasing diversity in STEAM fields by creating stories and sharing perspectives from the field."),
		.buttons([
			ButtonData(image: #imageLiteral(resourceName: "ic_gmail"), url: "mailto: @gmail.com"), // TODO1 fix
			ButtonData(image: #imageLiteral(resourceName: "ic_instagram"), url: "https://www.instagram.com/paper_oranges/"),
			ButtonData(image: #imageLiteral(resourceName: "ic_facebook"), url: "https://www.facebook.com/paperoranges/"),
			ButtonData(image: #imageLiteral(resourceName: "ic_medium"), url: "https://medium.com/paper-oranges")]),
		.textLink("Version \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String) • ©\(Calendar.current.component(.year, from: Date())) Paper Oranges", nil),
		.textLink("www.paperoranges.com", "https://www.paperoranges.com/")
	]
}

class SortingInfoViewModel: InfoViewModel {
	var hero: Info = .hero(#imageLiteral(resourceName: "hr_bubble_sort"), "Intro to Sorting Algorithms") // TODO1 change image

	var rows: [Info] = [
		.person(#imageLiteral(resourceName: "av_bianca_curutan"), "Writer & Developer", "Bianca is an Engineering Manager at Postmates, working on the Fleet Android and iOS apps. Although originally from Canada, she is currently an active speaker, writer, and member of the tech community in the SF Bay Area."),
		.person(#imageLiteral(resourceName: "av_angelique_de_castro"), "Illustrator", "Angelique is a Full Stack Engineer at Nyansa and creative technologist. She loves consuming stories as much as producing them in fun illustrations or technology - or both!")
	]
}

class BubbleSortInfoViewModel: InfoViewModel {
	var hero: Info = .hero(#imageLiteral(resourceName: "hr_bubble_sort"), "Bubble Sort")

	var rows: [Info] = [
		.description("What is Bubble Sort?", "A sorting algorithm that compares each pair of elements. If elements are out of order, swap them. Repeat the algorithm (from the beginning to the end) until all the elements are sorted."),
		.description("How are indices used?", "The students are displayed as if they are stored in an array. Arrays use zero-based indexing, meaning the first item of the array has index 0 and the last element has the index \"total number of items minus one\".")
	]

	var test: [Info] = []
}

enum Info {
	case hero(UIImage, String?) // image, title
	case description(String?, String?) // title, description
	case person(UIImage?, String?, String?) // image, role, details
	case textLink(String, String?) // text, link
	case buttons([ButtonData]) 
}

struct ButtonData {
	var image: UIImage
	var isSelected: Bool = false
	var url: String?
	var name: String?
	var sortId: Int? // Determines final sort order
}
