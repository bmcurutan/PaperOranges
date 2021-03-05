//
//  SortingViewModels.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/10/21.
//

import UIKit

// TODO2 add ability to navigate between completed steps or to undo
protocol SortingViewModel {
	var id: SortingID { get }
	var sections: [SortingSection] { get set }
	var sortingButtons: [ButtonData] { get set }
    var slotButtons: [ButtonData] { get set }
	// Steps
	var steps: [Step] { get } // Should be have at least two steps
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
		return "Oops, try again.\nNeed help? Check your zine for guidance."
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
        ButtonData(id: 0, image: #imageLiteral(resourceName: "av_sorting_alex"), name: "Alex"),
        ButtonData(id: 4, image: #imageLiteral(resourceName: "av_sorting_mandy"), name: "Mandy"),
        ButtonData(id: 2, image: #imageLiteral(resourceName: "av_sorting_felicia"), name: "Felicia"),
        ButtonData(id: 3, image: #imageLiteral(resourceName: "av_sorting_liam"), name: "Liam"),
        ButtonData(id: 1, image: #imageLiteral(resourceName: "av_sorting_bb"), name: "BB")
	]

    var slotButtons: [ButtonData] = []

    // Solution determines which two buttons to swap
	var steps: [Step] = [
		Step(speech: NSMutableAttributedString(string: "Sort the students alphabetically using Bubble Sort.\n\nHint: Only two students may interact at a time."), solution: (0, 4), stepText: "Compare Alex and Mandy (indices 0 and 1)"),
		Step(speech: NSMutableAttributedString(string: "A and M are already in order, so Alex and Mandy didn't swap places."), solution: (4, 2), stepText: "Compare Mandy and Felicia (indices 1 and 2)"),
		Step(speech: NSMutableAttributedString(string: "F is before M, so Mandy and Felicia swapped places."), solution: (4, 3), stepText: "Compare Mandy and Liam (indices 2 and 3)"),
		Step(speech: NSMutableAttributedString(string: "L is before M, so Mandy and Liam swapped places."), solution: (4, 1), stepText: "Compare Mandy and BB (indices 3 and 4)"),
		Step(speech: NSMutableAttributedString(string: "B is before M, so Mandy and BB swapped places."), solution: (0, 2), stepText: "Compare Alex and Felicia (indices 0 and 1)"),
		Step(speech: NSMutableAttributedString(string: "A is before F, so Alex and Felicia didn't swap places."), solution: (2, 3), stepText: "Compare Felicia and Liam (indices 1 and 2)"),
		Step(speech: NSMutableAttributedString(string: "F is before L, so Felicia and Liam didn't swap places."), solution: (3, 1), stepText: "Compare Liam and BB (indices 2 and 3)"),
		Step(speech: NSMutableAttributedString(string: "B is before L, so Liam and BB swapped places."), solution: (3, 4), stepText: "Compare Liam and Mandy (indices 3 and 4)"),
		Step(speech: NSMutableAttributedString(string: "L is before M, so Liam and Mandy didn't swap places."), solution: (0, 2), stepText: "Compare Alex and Felicia (indices 0 and 1)"),
		Step(speech: NSMutableAttributedString(string: "A is before F, so Alex and Felicia didn't swap places."), solution: (2, 1), stepText: "Compare Felicia and BB (indices 1 and 2)"),
		Step(speech: NSMutableAttributedString(string: "B is before F, so Felicia and BB swapped places."), solution: (2, 3), stepText: "Compare Felicia and Liam (indices 2 and 3)"),
		Step(speech: NSMutableAttributedString(string: "F is before L, so Felicia and Liam didn't swap places."), solution: (3, 4), stepText: "Compare Liam and Mandy (indices 3 and 4)"),
		  Step(speech: NSMutableAttributedString(string: "L is before M, so Liam and Mandy didn't swap places.\n\nAll the students are sorted alphabetically - well done! Tap Back to play another sorting game."))
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

    var sortingButtons: [ButtonData] = [
		ButtonData(id: 3, image: #imageLiteral(resourceName: "av_sorting_liam"), name: "`3`\nLiam"),
        ButtonData(id: 5, image: #imageLiteral(resourceName: "av_sorting_felicia"), name: "`5`\nFelicia"),
        ButtonData(id: 2, image: #imageLiteral(resourceName: "av_sorting_mandy"), name: "`2`\nMandy"),
        ButtonData(id: 4, image: #imageLiteral(resourceName: "av_sorting_alex"), name: "`4`\nAlex"),
        ButtonData(id: 1, image: #imageLiteral(resourceName: "av_sorting_bb"), name: "`1`\nBB")
	]

    // e.g., buttonIDs = [1, 2, 3], slotIDs = [4, 5, 6] - differentiate between buttons and slots
    // id = index + buttons.count + 1 - insertion sort uses a 1-indexed array for student height
    // name uses placeholder to make button1s the same height as button0s)
    var slotButtons: [ButtonData] = [
        ButtonData(id: 6, name: "\n"),
        ButtonData(id: 7, name: "\n"),
        ButtonData(id: 8, name: "\n"),
        ButtonData(id: 9, name: "\n"),
        ButtonData(id: 10, name: "\n")
    ]

    // Solution determines which button and slot to select
	var steps: [Step] = [
		Step(speech: NSMutableAttributedString(string: "Sort the students by height (represented by 1-5) using Insertion Sort. \n\nHint: Move each student from the blue line to the red line, filling the slots from left to right."), solution: (3, 6), stepText: "`3` goes to index 0"),
        Step(speech: NSMutableAttributedString(string: "There's no one on the red line yet, so `3` Liam goes to the first slot."), solution: (5, 7), stepText: "`5` goes to index 1"),
        Step(speech: NSMutableAttributedString(string: "`5` is higher than `3`, so `5` Felicia goes to the second slot after `3` Liam."), solution: (2, 6), stepText: "`2` goes to index 0"),
        Step(speech: NSMutableAttributedString(string: "`2` is lower than `3`, so `2` Mandy goes to the first slot and the others shift right."), solution: (4, 8), stepText: "`4` goes to index 3"),
        Step(speech: NSMutableAttributedString(string: "`4` is higher than `3` and lower than `5`, so `4` Alex goes to the third slot and `5` Felicia shifts right."), solution: (1, 6), stepText: "`1` goes to index 0"),
        Step(speech: NSMutableAttributedString(string: "`1` is lower than `2`, so `1` BB goes to the first slot and the others shift right.\n\nAll the students are sorted by height - well done! Tap Back to play another sorting game."))
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

enum SortingSection: Equatable {
	case speaker
	case buttons
	case steps(String = "Steps", [Step]) // title, steps

    static func == (lhs: SortingSection, rhs: SortingSection) -> Bool {
        switch (lhs, rhs) {
        case (.speaker, .speaker):
            return true
        case (.buttons, .buttons):
            return true
        case (let .steps(title0, steps0), let .steps(title1, steps1)):
            return title0 == title1 && steps0 == steps1
        default:
            return false
        }
    }
}

enum SortingID: String {
	case bubbleSort
	case insertionSort
	case mergeSort
}

struct Step: Equatable {
    var speech: NSMutableAttributedString = NSMutableAttributedString(string: "") // Text to show in speech bubble (usually explains the previou step)
	var solution: (Int, Int) = (-1, -1) // (sortID, sortID) Buttons to swap to progress to next step
	var stepText: String? = nil // Text to show once solution is completed

    static func == (lhs: Step, rhs: Step) -> Bool {
        return lhs.speech == rhs.speech && lhs.solution == rhs.solution && lhs.stepText == rhs.stepText
    }
}

enum SpeechTitle {
	case start
	case success
	case error
	case completed
	case none
}
