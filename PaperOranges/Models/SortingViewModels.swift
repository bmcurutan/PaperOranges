//
//  SortingViewModels.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/10/21.
//

import UIKit

protocol SortingViewModel {
	var id: SortingID { get }
	var sections: [SortingSection] { get set }
	var sortingButtons: [ButtonData] { get set }
    var solution: [ButtonData] { get }
    var slotButtons: [ButtonData] { get set }
    // Education
    var educationID: String { get }
    var educationText: String { get }
	// Steps
	var steps: [Step] { get } // Should be have at least two steps
	// Messages
	var startMessage: String { get }
	var endingMessage: String { get }
	var successMessage: String { get }
	var errorMessage: String { get }
    var hintMessage: String { get }
	var completedMessage: String { get }
	var completedSpeech: NSMutableAttributedString { get }
    var completedAlert: String { get }
}

extension SortingViewModel {
    var educationID: String {
        return "\(id.rawValue)Education"
    }

    var educationText: String {
        return "Tap here for help with getting started."
    }

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
}

class BubbleSortViewModel: SortingViewModel {
	var id: SortingID = .bubbleSort

    var sections: [SortingSection] = [.speaker, .buttons, .steps]

	var sortingButtons: [ButtonData] = [
        ButtonData(id: 0, image: #imageLiteral(resourceName: "av_sorting_alex"), name: "Alex"),
        ButtonData(id: 4, image: #imageLiteral(resourceName: "av_sorting_mandy"), name: "Mandy"),
        ButtonData(id: 2, image: #imageLiteral(resourceName: "av_sorting_felicia"), name: "Felicia"),
        ButtonData(id: 3, image: #imageLiteral(resourceName: "av_sorting_liam"), name: "Liam"),
        ButtonData(id: 1, image: #imageLiteral(resourceName: "av_sorting_bb"), name: "BB")
	]

    // Solution determines which two buttons to swap
    var solution: [ButtonData] = [
        ButtonData(id: 0, image: #imageLiteral(resourceName: "av_sorting_alex"), name: "Alex"),
        ButtonData(id: 1, image: #imageLiteral(resourceName: "av_sorting_bb"), name: "BB"),
        ButtonData(id: 2, image: #imageLiteral(resourceName: "av_sorting_felicia"), name: "Felicia"),
        ButtonData(id: 3, image: #imageLiteral(resourceName: "av_sorting_liam"), name: "Liam"),
        ButtonData(id: 4, image: #imageLiteral(resourceName: "av_sorting_mandy"), name: "Mandy"),
    ]

    var slotButtons: [ButtonData] = []

	var steps: [Step] = [
		Step(speech: NSMutableAttributedString(string: "Sort the students alphabetically using Bubble Sort. Only two students may interact at a time."), solution: (0, 4), stepText: "Compare Alex and Mandy (indices 0 and 1) - no swapping"),
		Step(speech: NSMutableAttributedString(string: "A and M are already in order, so Alex and Mandy didn't swap places."), solution: (4, 2), stepText: "Compare Mandy and Felicia (indices 1 and 2) - they swap places"),
		Step(speech: NSMutableAttributedString(string: "F is before M, so Mandy and Felicia swapped places."), solution: (4, 3), stepText: "Compare Mandy and Liam (indices 2 and 3) - they swap places"),
		Step(speech: NSMutableAttributedString(string: "L is before M, so Mandy and Liam swapped places."), solution: (4, 1), stepText: "Compare Mandy and BB (indices 3 and 4) - they swap places"),
		Step(speech: NSMutableAttributedString(string: "B is before M, so Mandy and BB swapped places."), solution: (0, 2), stepText: "Compare Alex and Felicia (indices 0 and 1) - no swapping"),
		Step(speech: NSMutableAttributedString(string: "A is before F, so Alex and Felicia didn't swap places."), solution: (2, 3), stepText: "Compare Felicia and Liam (indices 1 and 2) - no swapping"),
		Step(speech: NSMutableAttributedString(string: "F is before L, so Felicia and Liam didn't swap places."), solution: (3, 1), stepText: "Compare Liam and BB (indices 2 and 3) - they swap places"),
		Step(speech: NSMutableAttributedString(string: "B is before L, so Liam and BB swapped places."), solution: (3, 4), stepText: "Compare Liam and Mandy (indices 3 and 4) - no swapping"),
		Step(speech: NSMutableAttributedString(string: "L is before M, so Liam and Mandy didn't swap places."), solution: (0, 2), stepText: "Compare Alex and Felicia (indices 0 and 1) - no swapping"),
		Step(speech: NSMutableAttributedString(string: "A is before F, so Alex and Felicia didn't swap places."), solution: (2, 1), stepText: "Compare Felicia and BB (indices 1 and 2) - they swap places"),
		Step(speech: NSMutableAttributedString(string: "B is before F, so Felicia and BB swapped places."), solution: (2, 3), stepText: "Compare Felicia and Liam (indices 2 and 3) - no swapping"),
		Step(speech: NSMutableAttributedString(string: "F is before L, so Felicia and Liam didn't swap places."), solution: (3, 4), stepText: "Compare Liam and Mandy (indices 3 and 4) - no swapping"),
        Step(speech: NSMutableAttributedString(string: "L is before M, so Liam and Mandy didn't swap places."))
	]

    var hintMessage: String {
        return "Hint: Compare adjacent students. For additional help, check your zine."
    }

    var completedAlert: String {
        return "All the students are sorted alphabetically - well done! Go back to select your next game."
    }
}

class InsertionSortViewModel: SortingViewModel {
	var id: SortingID = .insertionSort
	
    var sections: [SortingSection] = [.speaker, .buttons, .steps]

    var sortingButtons: [ButtonData] = [
		ButtonData(id: 3, image: #imageLiteral(resourceName: "av_sorting_liam"), name: "3"),
        ButtonData(id: 5, image: #imageLiteral(resourceName: "av_sorting_felicia"), name: "5"),
        ButtonData(id: 2, image: #imageLiteral(resourceName: "av_sorting_mandy"), name: "2"),
        ButtonData(id: 4, image: #imageLiteral(resourceName: "av_sorting_alex"), name: "4"),
        ButtonData(id: 1, image: #imageLiteral(resourceName: "av_sorting_bb"), name: "1")
	]

    // Solution determines which button and slot to select
    var solution: [ButtonData] = [
        ButtonData(id: 1, image: #imageLiteral(resourceName: "av_sorting_bb"), name: "1"),
        ButtonData(id: 2, image: #imageLiteral(resourceName: "av_sorting_mandy"), name: "2"),
        ButtonData(id: 3, image: #imageLiteral(resourceName: "av_sorting_liam"), name: "3"),
        ButtonData(id: 4, image: #imageLiteral(resourceName: "av_sorting_alex"), name: "4"),
        ButtonData(id: 5, image: #imageLiteral(resourceName: "av_sorting_felicia"), name: "5")
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

	var steps: [Step] = [
		Step(speech: NSMutableAttributedString(string: "Sort the students by height 1-5 using Insertion Sort. Move each student from the blue line to the red line, filling the slots from left to right."), solution: (3, 6), stepText: "3 goes to index 0 - no shifting"),
        Step(speech: NSMutableAttributedString(string: "There's no one on the red line yet, so 3 goes to the first slot."), solution: (5, 7), stepText: "5 goes to index 1 - no shifting"),
        Step(speech: NSMutableAttributedString(string: "5 is higher than 3, so 5 goes to the second slot after 3."), solution: (2, 6), stepText: "2 goes to index 0 - 3 and 5 shift right"),
        Step(speech: NSMutableAttributedString(string: "2 is lower than 3, so 2 goes to the first slot and the others shift right."), solution: (4, 8), stepText: "4 goes to index 3 - 5 shifts right"),
        Step(speech: NSMutableAttributedString(string: "4 is higher than 3 and lower than 5, so 4 goes to the third slot and 5 Felicia shifts right."), solution: (1, 6), stepText: "1 goes to index 0 - 2, 3, 4, and 5 shift right"),
        Step(speech: NSMutableAttributedString(string: "1 is lower than 2, so 1 goes to the first slot and the others shift right."))
	]

    var hintMessage: String {
        return "Hint: Select one student and one slot. For additional help, check your zine."
    }

    var completedAlert: String {
        return "All the students are sorted by height - well done! Go back to select your next game."
    }
}

class MergeSortViewModel: SortingViewModel {
    var id: SortingID = .mergeSort

    var sections: [SortingSection] = [.speaker, .buttons, .steps]

    var sortingButtons: [ButtonData] = [
        ButtonData(id: 8, image: #imageLiteral(resourceName: "av_sorting_bb"), name: "Dec\n20"),
        ButtonData(id: 2, image: #imageLiteral(resourceName: "av_sorting_mandy"), name: "Mar\n3"),
        ButtonData(id: 3, image: #imageLiteral(resourceName: "av_sorting_felicia"), name: "May\n12"),
        ButtonData(id: 7, image: #imageLiteral(resourceName: "av_sorting_tanwi"), name: "Nov\n17"),
        ButtonData(id: 4, image: #imageLiteral(resourceName: "av_sorting_vincente"), name: "May\n27"),
        ButtonData(id: 1, image: #imageLiteral(resourceName: "av_sorting_rae"), name: "Jan\n1"),
        ButtonData(id: 6, image: #imageLiteral(resourceName: "av_sorting_alex"), name: "Sept\n28"),
        ButtonData(id: 5, image: #imageLiteral(resourceName: "av_sorting_liam"), name: "July\n30")
    ]

    var solution: [ButtonData] = [
        ButtonData(id: 1, image: #imageLiteral(resourceName: "av_sorting_rae"), name: "Jan\n1"),
        ButtonData(id: 2, image: #imageLiteral(resourceName: "av_sorting_mandy"), name: "Mar\n3"),
        ButtonData(id: 3, image: #imageLiteral(resourceName: "av_sorting_felicia"), name: "May\n12"),
        ButtonData(id: 4, image: #imageLiteral(resourceName: "av_sorting_vincente"), name: "May\n27"),
        ButtonData(id: 5, image: #imageLiteral(resourceName: "av_sorting_liam"), name: "July\n30"),
        ButtonData(id: 6, image: #imageLiteral(resourceName: "av_sorting_alex"), name: "Sept\n28"),
        ButtonData(id: 7, image: #imageLiteral(resourceName: "av_sorting_tanwi"), name: "Nov\n17"),
        ButtonData(id: 8, image: #imageLiteral(resourceName: "av_sorting_bb"), name: "Dec\n20"),
    ]

    var slotButtons: [ButtonData] = [
        // Round 1
        ButtonData(id: 9, name: "\n"), // Index 0
        ButtonData(id: 10, name: "\n"), // 1
        ButtonData(id: 11, name: "\n"), // 2
        ButtonData(id: 12, name: "\n"), // 3
        ButtonData(id: 13, name: "\n"), // 4
        ButtonData(id: 14, name: "\n"), // 5
        ButtonData(id: 15, name: "\n"), // 6
        ButtonData(id: 16, name: "\n"), // 7
        // Round 2
        ButtonData(id: 17, name: "\n"), // 8
        ButtonData(id: 18, name: "\n"), // 9
        ButtonData(id: 19, name: "\n"), // 10
        ButtonData(id: 20, name: "\n"), // 11
        ButtonData(id: 21, name: "\n"), // 12
        ButtonData(id: 22, name: "\n"), // 13
        ButtonData(id: 23, name: "\n"), // 14
        ButtonData(id: 24, name: "\n"), // 15
        // Round 3
        ButtonData(id: 25, name: "\n"),
        ButtonData(id: 26, name: "\n"),
        ButtonData(id: 27, name: "\n"),
        ButtonData(id: 28, name: "\n"),
        ButtonData(id: 29, name: "\n"),
        ButtonData(id: 30, name: "\n"),
        ButtonData(id: 31, name: "\n"),
        ButtonData(id: 32, name: "\n"),
        // Round 4
        ButtonData(id: 33, name: "\n"),
        ButtonData(id: 34, name: "\n"),
        ButtonData(id: 35, name: "\n"),
        ButtonData(id: 36, name: "\n"),
        ButtonData(id: 37, name: "\n"),
        ButtonData(id: 38, name: "\n"),
        ButtonData(id: 39, name: "\n"),
        ButtonData(id: 40, name: "\n")
    ]

    var steps: [Step] = [
        Step(speech: NSMutableAttributedString(string: "Sort the students by birthday. The first step is to separate them out into groups of 1 using the first row of slots."), solution: (8, 9), stepText: "Dec 20 goes to index 0"),
        Step(speech: NSMutableAttributedString(string: "Let's keep separating the students out into groups of 1."), solution: (2, 10), stepText: "Mar 3 goes to index 1"),
        Step(speech: NSMutableAttributedString(string: "Let's keep separating the students out into groups of 1."), solution: (3, 11), stepText: "May 12 goes to index 2"),
        Step(speech: NSMutableAttributedString(string: "Let's keep separating the students out into groups of 1."), solution: (7, 12), stepText: "May 27 goes to index 3"),
        Step(speech: NSMutableAttributedString(string: "Let's keep separating the students out into groups of 1."), solution: (4, 13), stepText: "July 30 goes to index 4"),
        Step(speech: NSMutableAttributedString(string: "Let's keep separating the students out into groups of 1."), solution: (1, 14), stepText: "Sept 28 goes to index 5"),
        Step(speech: NSMutableAttributedString(string: "Let's keep separating the students out into groups of 1."), solution: (6, 15), stepText: "Nov 17 goes to index 6"),
        Step(speech: NSMutableAttributedString(string: "Let's keep separating the students out into groups of 1."), solution: (5, 16), stepText: "Dec 20 goes to index 7"),
        Step(speech: NSMutableAttributedString(string: "And each group of 1 is already sorted! Next, combine groups to form sorted groups of 2 using the second row of slots."), solution: (-1, -1), stepText: ""),
        Step(speech: NSMutableAttributedString(string: "// TODO last step"))
    ]

    var hintMessage: String {
        return "Hint: For additional help, check your zine." 
    }

    var completedAlert: String {
        return "All the students are sorted by birthday - well done! Go back to select your next game."
    }
}

enum SortingSection: Equatable {
    case speaker
    case buttons
    case steps

    static func == (lhs: SortingSection, rhs: SortingSection) -> Bool {
        switch (lhs, rhs) {
        case (.speaker, .speaker):
            return true
        case (.buttons, .buttons):
            return true
        case (.steps, .steps):
            return true
        default:
            return false
        }
    }
}

enum SortingID: String {
	case bubbleSort
	case insertionSort
	case mergeSort
    case quickSort
}

enum BubbleSortState: String {
    case successSwap
    case successNoSwap
    case error
}

struct Step: Equatable {
    var speech: NSMutableAttributedString = NSMutableAttributedString(string: "") // Text to show in speech bubble (usually explains the previous step)
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
