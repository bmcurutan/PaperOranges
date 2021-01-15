//
//  SortingViewModels.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/10/21.
//

import UIKit

// TODO2 add ability to navigate between completed steps
protocol SortingViewModel {
	var id: SortingID { get }
	var sections: [SortingSection] { get set }
	var sortingButtons: [ButtonData] { get set }
	// Steps
	var steps: [Step] { get }
	func addStepsSection()
	func removeStepsSection()
	// Messages
	var startMessage: String { get }
	var endingMessage: String { get }
	var successMessage: String { get }
	var errorMessage: String { get }
	var completedMessage: String { get }
	var completedSpeech: NSMutableAttributedString { get }
	// Errors
	var buttonsError: String? { get }
	var slotsError: String? { get }
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

	var completedMessage: String {
		return "Congratulations!"
	}

	var completedSpeech: NSMutableAttributedString {
		let attributedText = NSMutableAttributedString(string: "You have already completed the game for this sorting algorithm.\n\nTap ")
		attributedText.append(NSMutableAttributedString(string: "here ").setTextColor(.accentColor))
		attributedText.append(NSMutableAttributedString(string: "to reset your progress and play the game again."))
		return attributedText
	}

    var buttonsError: String? {
        return nil
    }

    var slotsError: String? {
        return nil
    }
}

class BubbleSortViewModel: SortingViewModel {
	var id: SortingID = .bubbleSort

	var sections: [SortingSection] = [.speaker, .buttons]

	var sortingButtons: [ButtonData] = [
		ButtonData(image: #imageLiteral(resourceName: "av_sorting_alex"), name: "Alex", sortID: 0),
		ButtonData(image: #imageLiteral(resourceName: "av_sorting_mandy"), name: "Mandy", sortID: 4),
		ButtonData(image: #imageLiteral(resourceName: "av_sorting_felicia"), name: "Felicia", sortID: 2),
		ButtonData(image: #imageLiteral(resourceName: "av_sorting_liam"), name: "Liam", sortID: 3),
		ButtonData(image: #imageLiteral(resourceName: "av_sorting_bb"), name: "BB", sortID: 1)
	]

    // Solution determines which two buttons to swap
	var steps: [Step] = [
		Step(speech: NSMutableAttributedString(string: "Sort the students alphabetically using Bubble Sort.\n\nHint: Only two students may interact at a time."), solution: (0, 4), completedText: "Compare Alex and Mandy (indices 0 and 1)"),
		Step(speech: NSMutableAttributedString(string: "A and M are already in order, so Alex and Mandy didn't swap places."), solution: (4, 2), completedText: "Compare Mandy and Felicia (indices 1 and 2)"),
		Step(speech: NSMutableAttributedString(string: "F is before M, so Mandy and Felicia swapped places."), solution: (4, 3), completedText: "Compare Mandy and Liam (indices 2 and 3)"),
		Step(speech: NSMutableAttributedString(string: "L is before M, so Mandy and Liam swapped places."), solution: (4, 1), completedText: "Compare Mandy and BB (indices 3 and 4)"),
		Step(speech: NSMutableAttributedString(string: "B is before M, so Mandy and BB swapped places."), solution: (0, 2), completedText: "Compare Alex and Felicia (indices 0 and 1)"),
		Step(speech: NSMutableAttributedString(string: "A is before F, so Alex and Felicia didn't swap places."), solution: (2, 3), completedText: "Compare Felicia and Liam (indices 1 and 2)"),
		Step(speech: NSMutableAttributedString(string: "F is before L, so Felicia and Liam didn't swap places."), solution: (3, 1), completedText: "Compare Liam and BB (indices 2 and 3)"),
		Step(speech: NSMutableAttributedString(string: "B is before L, so Liam and BB swapped places."), solution: (3, 4), completedText: "Compare Liam and Mandy (indices 3 and 4)"),
		Step(speech: NSMutableAttributedString(string: "L is before M, so Liam and Mandy didn't swap places."), solution: (0, 2), completedText: "Compare Alex and Felicia (indices 0 and 1)"),
		Step(speech: NSMutableAttributedString(string: "A is before F, so Alex and Felicia didn't swap places."), solution: (2, 1), completedText: "Compare Felicia and BB (indices 1 and 2)"),
		Step(speech: NSMutableAttributedString(string: "B is before F, so Felicia and BB swapped places."), solution: (2, 3), completedText: "Compare Felicia and Liam (indices 2 and 3)"),
		Step(speech: NSMutableAttributedString(string: "F is before L, so Felicia and Liam didn't swap places."), solution: (3, 4), completedText: "Compare Liam and Mandy (indices 3 and 4)"),
		  Step(speech: NSMutableAttributedString(string: "L is before M, so Liam and Mandy didn't swap places.\n\nAll the students are sorted - well done! Tap Back to play another sorting game."))
	]

	func addStepsSection() {
		if sections.filter({
			switch $0 {
			case .steps:
				return true
			default:
				return false
			}
		}).count == 0 {
			sections.append(.steps("Steps", steps))
		}
	}

	func removeStepsSection() {
		sections.removeAll(where: {
			switch $0 {
			case .steps:
				return true
			default:
				return false
			}
		})
	}
}

class InsertionSortViewModel: SortingViewModel {
	var id: SortingID = .insertionSort
	
	var sections: [SortingSection] = [.speaker, .buttons]

	// TODO
	var sortingButtons: [ButtonData] = [
		ButtonData(image: #imageLiteral(resourceName: "av_sorting_liam"), name: "Liam\n3", sortID: 3),
		ButtonData(image: #imageLiteral(resourceName: "av_sorting_felicia"), name: "Felicia\n5", sortID: 5),
		ButtonData(image: #imageLiteral(resourceName: "av_sorting_mandy"), name: "Mandy\n2", sortID: 2),
		ButtonData(image: #imageLiteral(resourceName: "av_sorting_alex"), name: "Alex\n4", sortID: 4),
		ButtonData(image: #imageLiteral(resourceName: "av_sorting_bb"), name: "BB\n1", sortID: 1)
	]

	// TODO
    // Solution determines which button and slot to select
	var steps: [Step] = [
		Step(speech: NSMutableAttributedString(string: "Sort the students by height (represented by 1-5) using Insertion Sort. \n\nHint: Move each student from the blue line to the red line, filling the slots from left to right."), solution: (3, 0), completedText: "TODO solution and completedText"),
//		Step(speech: "A and M are already in order, so Alex and Mandy didn't swap places.", solution: (4, 2), completedText: "Compare Mandy and Felicia (indices 1 and 2)"),
//		Step(speech: "F is before M, so Mandy and Felicia swapped places.", solution: (4, 3), completedText: "Compare Mandy and Liam (indices 2 and 3)"),
//		Step(speech: "L is before M, so Mandy and Liam swapped places.", solution: (4, 1), completedText: "Compare Mandy and BB (indices 3 and 4)"),
//		Step(speech: "B is before M, so Mandy and BB swapped places.", solution: (0, 2), completedText: "Compare Alex and Felicia (indices 0 and 1)"),
//		Step(speech: "A is before F, so Alex and Felicia didn't swap places.", solution: (2, 3), completedText: "Compare Felicia and Liam (indices 1 and 2)"),
//		Step(speech: "F is before L, so Felicia and Liam didn't swap places.", solution: (3, 1), completedText: "Compare Liam and BB (indices 2 and 3)"),
//		Step(speech: "B is before L, so Liam and BB swapped places.", solution: (3, 4), completedText: "Compare Liam and Mandy (indices 3 and 4)"),
//		Step(speech: "L is before M, so Liam and Mandy didn't swap places.", solution: (0, 2), completedText: "Compare Alex and Felicia (indices 0 and 1)"),
//		Step(speech: "A is before F, so Alex and Felicia didn't swap places.", solution: (2, 1), completedText: "Compare Felicia and BB (indices 1 and 2)"),
//		Step(speech: "B is before F, so Felicia and BB swapped places.", solution: (2, 3), completedText: "Compare Felicia and Liam (indices 2 and 3)"),
//		Step(speech: "F is before L, so Felicia and Liam didn't swap places.", solution: (3, 4), completedText: "Compare Liam and Mandy (indices 3 and 4)"),
//		Step(speech: "L is before M, so Liam and Mandy didn't swap places.\n\nAll the students are sorted - well done! Tap Back to play another sorting game.")
	]

	func addStepsSection() {
		if sections.filter({
			switch $0 {
			case .steps:
				return true
			default:
				return false
			}
		}).count == 0 {
			sections.append(.steps("Steps", steps))
		}
	}

	func removeStepsSection() {
		sections.removeAll(where: {
			switch $0 {
			case .steps:
				return true
		    default:
				return false
			}
		})
	}

    var buttonsError: String? {
        return "Only one student may take a turn at a time"
    }

    var slotsError: String? {
        return "Select one slot at a time"
    }
}

enum SortingSection {
	case speaker
	case buttons
	case steps(String = "Steps", [Step]) // title, steps
}

enum SortingID: String {
	case bubbleSort
	case insertionSort
	case mergeSort
}

struct Step {
	var speech: NSMutableAttributedString // Text to show in speech bubble
	var solution: (Int, Int) = (-1, -1) // Buttons to tap (based on id) to progress to next step
	var completedText: String? = nil // Step text to show once solution is reached
}

enum SpeechTitle {
	case start
	case success
	case error
	case completed
	case none
}
