//
//  InfoViewModels.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/11/21.
//

import UIKit

protocol InfoViewModel {
	var sections: [InfoSection] { get }
}

class MenuInfoViewModel: InfoViewModel {
	var sections: [InfoSection] {
		return [
			InfoSection(image: #imageLiteral(resourceName: "hr_collaborate"), rows: menuRows)
		]
	}

	private var menuRows: [Info] = [
		.description("What is Paper Oranges?", "Paper Oranges is a community and storytelling platform to elevate the voices of people in tech. We partner with creators of color to develop educational materials related to science, technology, engineering, art and math (STEAM) and featuring a diverse cast of characters."),
		.buttons([
            ButtonData(id: 0, image: #imageLiteral(resourceName: "ic_gmail"), url: "mailto:info@paperoranges.com"),
            ButtonData(id: 1, image: #imageLiteral(resourceName: "ic_cart"), url: "https://www.paperoranges.com/shop/"),
            ButtonData(id: 2, image: #imageLiteral(resourceName: "ic_instagram"), url: "https://www.instagram.com/paper_oranges/"),
            ButtonData(id: 3, image: #imageLiteral(resourceName: "ic_medium"), url: "https://medium.com/paper-oranges")
        ]),
		.textLink("Version \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String) • ©\(Calendar.current.component(.year, from: Date())) Paper Oranges"),
		.textLink("www.paperoranges.com", "https://www.paperoranges.com/")
	]
}

class SortingInfoViewModel: InfoViewModel {
	var sections: [InfoSection] {
		return [
			InfoSection(title: "Intro to Sorting Algorithms", image: #imageLiteral(resourceName: "hr_bubble_sort"), rows: descriptionRows) // TODO1 change image
		]
	}

	private var descriptionRows: [Info] = [
		.description("Description", "An \"algorithm\" a way to solve a problem, so the term \"sorting algorithms\" suggests there are different ways to sort things."),
        .description("Arrays", "The students are displayed as if they're stored in an array, a collection of items. Loops through an array typically go from left to right."),
		.description("Indices", "Arrays use zero-based indexing, meaning the first item of the array has index 0 and the last item has the index \"total number of items minus one\"."),
        .description("Need help?", "Check the Sorting series zines for guidance. They may be purchased from the Paper Oranges shop.", "Paper Oranges shop", URL(string: "https://www.paperoranges.com/shop/"))
	]
}

class BubbleSortInfoViewModel: InfoViewModel {
	var sections: [InfoSection] {
		return [
			InfoSection(title: "Bubble Sort", image: #imageLiteral(resourceName: "hr_bubble_sort")),
			InfoSection(rows: descriptionRows)
		]
	}

	private var descriptionRows: [Info] = [
		.description("Description", "Bubble Sort is a sorting algorithm that compares pairs of elements. If elements are out of order, swap them. Repeat the algorithm (from the beginning to the end) until all the elements are sorted."),
        .description("Need help?", "Check your Bubble Sort zine for guidance. Don't have one yet? Sorting zines may be purchased from the Paper Oranges shop.", "Paper Oranges shop", URL(string: "https://www.paperoranges.com/shop/"))
	]
}

class InsertionSortInfoViewModel: InfoViewModel {
	var sections: [InfoSection] {
		return [
			InfoSection(title: "Insertion Sort", image: #imageLiteral(resourceName: "hr_insertion_sort")),
			InfoSection(rows: descriptionRows)
		]
	}

	private var descriptionRows: [Info] = [
		.description("Description", "Insertion Sort is a sorting algorithm that creates a list one element at a time by inserting the element into the proper sorted position."),
        .description("Need help?", "Check your Insertion Sort zine for guidance. Don't have one yet? Sorting zines may be purchased from the Paper Oranges shop.", "Paper Oranges shop", URL(string: "https://www.paperoranges.com/shop/"))
	]
}

struct InfoSection {
	var title: String? = nil
	var image: UIImage? = nil
	var rows: [Info] = []
}

enum Info {
	case description(String, String, String? = nil, URL? = nil) // title, description, link text, link url; link text should be a substring of description
	case person(UIImage, String, String) // image, role, details
	case textLink(String, String? = nil) // text, link
	case buttons([ButtonData])
}

struct ButtonData {
    var id: Int
	var image: UIImage = UIImage()
    var isHidden: Bool = false
	var isSelected: Bool = false
	var name: String? = nil
	var url: String? = nil
}
