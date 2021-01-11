//
//  InfoViewModels.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/11/21.
//

import UIKit

protocol InfoViewModel {
	var rows: [Info] { get }
}

class HomeInfoViewModel: InfoViewModel {
	var rows: [Info] = [
		Info(type: .hero(#imageLiteral(resourceName: "hr_bubble_sort"), "Intro to Sorting Algorithms")), // TODO change image
		Info(type: .person(#imageLiteral(resourceName: "av_bianca_curutan"), "Writer & Developer", "Bianca is an engineering manager at Postmates, working on the Fleet Android and iOS apps. Although originally from Canada, she is currently an active speaker, writer, and member of the tech community in the SF Bay Area.")),
		Info(type: .person(#imageLiteral(resourceName: "av_angelique_de_castro"), "Illustrator", "Angelique is a full stack engineer at Nyansa and creative technologist. She loves consuming stories as much as producing them in fun illustrations or technology - or both!"))
	]
}

class BubbleSortInfoViewModel: InfoViewModel {
	var rows: [Info] = [
		Info(type: .hero(#imageLiteral(resourceName: "hr_bubble_sort"), "Bubble Sort")),
		Info(type: .description("What is Bubble Sort?", "A sorting algorithm that compares each pair of elements. If elements are out of order, swap them. Repeat the algorithm (from the beginning to the end) until all the elements are sorted.")),
		Info(type: .description("How are indices used?", "The students are displayed as if they are stored in an array. Arrays use zero-based indexing, meaning the first item of the array has index 0 and the last element has the index \"total number of items minus one\"."))
	]
}

struct Info {
	var type: InfoType
}

enum InfoType {
	case hero(UIImage?, String?) // image, title
	case description(String?, String?) // title, description
	case person(UIImage?, String?, String?) // image, role, details
}
