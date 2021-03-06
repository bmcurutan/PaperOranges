//
//  NSMutableAttributedStringExt.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/10/21.
//

import UIKit

extension NSMutableAttributedString {
    func setFont(_ font: UIFont) -> NSMutableAttributedString {
        addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, length))
        return self
    }

	func setTextColor(_ color: UIColor) -> NSMutableAttributedString {
		addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, length))
		return self
	}

	func append(_ string: String) {
		append(NSAttributedString(string: string))
	}
}
