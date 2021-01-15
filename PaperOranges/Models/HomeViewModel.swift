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

	private var sortingTopics: [Topic] = [
		Topic(type: .bubbleSort, title: "Intro to Bubble Sort", image: #imageLiteral(resourceName: "av_sorting_bb"), isActive: true),
		Topic(type: .insertionSort, title: "Intro to Insertion Sort", image: #imageLiteral(resourceName: "av_sorting_mandy"), isActive: true),
		Topic(type: .mergeSort, title: "Intro to Merge Sort", text: "(Coming Soon)", image: #imageLiteral(resourceName: "av_sorting_liam"), isActive: false)
   ]
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
}

enum TopicType {
	case bubbleSort
	case insertionSort
	case mergeSort
}

