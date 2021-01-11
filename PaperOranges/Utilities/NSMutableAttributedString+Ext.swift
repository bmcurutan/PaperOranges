//
//  NSMutableAttributedStringExt.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/10/21.
//

import UIKit

extension NSMutableAttributedString {
	func setTextColor(_ color: UIColor) -> NSMutableAttributedString {
		addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, length - 1))
		return self
	}

	func append(_ string: String) {
		append(NSAttributedString(string: string))
	}
}
