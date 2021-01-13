//
//  SortingViewModels.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/10/21.
//

import UIKit

// TODO2 add ability to navigate between completed steps
protocol SortingViewModel {
	var sections: [SortingSection] { get set }
	var stepsSection: SortingSection { get }
	var sortingButtons: [SortingButton] { get set } 
	var steps: [Step] { get }
	var successMessage: String { get }
	var errorMessage: String { get }
}

extension SortingViewModel {
	var startMessage: String {
		return "Let's play!"
	}

	var endingMessage: String {
		return "What's the next step?"
	}

	var successMessage: String {
		return "That's correct!"
	}

	var errorMessage: String {
		return "Oops, try again." 
	}
}

class BubbleSortViewModel: SortingViewModel {
	var sections: [SortingSection] = [.speaker, .buttons]

	var stepsSection: SortingSection = .steps("Steps")

	var sortingButtons: [SortingButton] = [
		SortingButton(id: 0, name: "Alex", image: #imageLiteral(resourceName: "av_sorting_alex")),
		SortingButton(id: 4, name: "Mandy", image: #imageLiteral(resourceName: "av_sorting_mandy")),
		SortingButton(id: 2, name: "Felicia", image: #imageLiteral(resourceName: "av_sorting_felicia")),
		SortingButton(id: 3, name: "Liam", image: #imageLiteral(resourceName: "av_sorting_liam")),
		SortingButton(id: 1, name: "BB", image: #imageLiteral(resourceName: "av_sorting_bb"))
	]

	// TODO2 translate into Italian
	var steps: [Step] = [
		Step(speech: "Sort the students alphabetically using Bubble Sort. The catch is only two of them can interact at a time.", solution: (0, 4), completedText: "Compare Alex and Mandy (indices 0 and 1)"),
		Step(speech: "A and M are already in order, so Alex and Mandy didn't swap places.", solution: (4, 2), completedText: "Compare Mandy and Felicia (indices 1 and 2)"),
		Step(speech: "F is before M, so Mandy and Felicia swapped places.", solution: (4, 3), completedText: "Compare Mandy and Liam (indices 2 and 3)"),
		Step(speech: "L is before M, so Mandy and Liam swapped places.", solution: (4, 1), completedText: "Compare Mandy and BB (indices 3 and 4)"),
		Step(speech: "B is before M, so Mandy and BB swapped places.", solution: (0, 2), completedText: "Compare Alex and Felicia (indices 0 and 1)"),
		Step(speech: "A is before F, so Alex and Felicia didn't swap places.", solution: (2, 3), completedText: "Compare Felicia and Liam (indices 1 and 2)"),
		Step(speech: "F is before L, so Felicia and Liam didn't swap places.", solution: (3, 1), completedText: "Compare Liam and BB (indices 2 and 3)"),
		Step(speech: "B is before L, so Liam and BB swapped places.", solution: (3, 4), completedText: "Compare Liam and Mandy (indices 3 and 4)"),
		Step(speech: "L is before M, so Liam and Mandy didn't swap places.", solution: (0, 2), completedText: "Compare Alex and Felicia (indices 0 and 1)"),
		Step(speech: "A is before F, so Alex and Felicia didn't swap places.", solution: (2, 1), completedText: "Compare Felicia and BB (indices 1 and 2)"),
		Step(speech: "B is before F, so Felicia and BB swapped places.", solution: (2, 3), completedText: "Compare Felicia and Liam (indices 2 and 3)"),
		Step(speech: "F is before L, so Felicia and Liam didn't swap places.", solution: (3, 4), completedText: "Compare Liam and Mandy (indices 3 and 4)"),
		Step(speech: "L is before M, so Liam and Mandy didn't swap places.\n\nAll the students are sorted - well done! Tap Back to play another sorting game.", solution: (-1, -1))
	]
}

enum SortingSection {
	case speaker
	case buttons
	case steps(String) // title
}

struct SortingButton {
	var id: Int // Determines final sort order
	var name: String
	var image: UIImage
	var isSelected: Bool = false
}

struct Step {
	var speech: String // Text to show in speech bubble
	var solution: (Int, Int) // Buttons to tap (based on id) to progress to next step
	var completedText: String = "" // Step text to show once solution is reached
}

enum SpeechTitle {
	case start
	case success
	case error
	case none
}
