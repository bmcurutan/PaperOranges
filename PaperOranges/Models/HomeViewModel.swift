//
//  Topic.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/10/21.
//

import UIKit

class HomeViewModel {
	var sections: [TopicSection] {
		return [TopicSection(title: "Intro to Sorting Algorithms", topics: sortingTopics)]
	}

	private var sortingTopics: [Topic] {
		return [
			Topic(type: .bubbleSort, title: "Intro to Bubble Sort", image: #imageLiteral(resourceName: "av_sorting_bb"), isActive: true, isCompleted: UserDefaults.standard.bool(forKey: SortingID.bubbleSort.rawValue)),
			Topic(type: .insertionSort, title: "Intro to Insertion Sort", image: #imageLiteral(resourceName: "av_sorting_mandy"), isActive: true, isCompleted: UserDefaults.standard.bool(forKey: SortingID.insertionSort.rawValue)),
			Topic(type: .mergeSort, title: "Intro to Merge Sort", text: "(Coming Soon)", image: #imageLiteral(resourceName: "av_sorting_liam"), isActive: false, isCompleted: UserDefaults.standard.bool(forKey: SortingID.mergeSort.rawValue)),
		]
	}
}

struct TopicSection {
	var title: String? = nil
	var topics: [Topic]
}

struct Topic {
	var type: TopicType
	var title: String
	var text: String? = nil
	var image: UIImage
	var isActive: Bool
	var isCompleted: Bool
}

enum TopicType {
	case bubbleSort
	case insertionSort
	case mergeSort
}

