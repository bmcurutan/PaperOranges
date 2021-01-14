//
//  UIColorExt.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/9/21.
//

import UIKit

extension UIColor {
	static var backgroundColor: UIColor {
		return UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0) // FAFAFA Very light gray
	}

	static var borderColor: UIColor {
		return .lightGray
	}

	static var accentColor: UIColor {
		return UIColor(red: 231/255, green: 111/255, blue: 81/255, alpha: 1.0) // #E76F51 Dark orange
	}

	static var secondaryAccentColor: UIColor {
		return UIColor(red: 244/255, green: 162/255, blue: 97/255, alpha: 1.0) // #F4A261 Light orange
	}

	static var primaryTextColor: UIColor {
		return UIColor(red: 38/255, green: 70/255, blue: 83/255, alpha: 1.0) // #264653 Dark teal
	}

	static var secondaryTextColor: UIColor {
		return UIColor.lightGray
	}

	static var primaryButtonColor: UIColor {
		return UIColor(red: 42/255, green: 157/255, blue: 143/255, alpha: 1.0) // #2A9D8F Light teal
	}

	static var highlightColor: UIColor {
		return UIColor(red: 233/255, green: 196/255, blue: 106/255, alpha: 1.0) // #E9C46A Yellow
	}

	static var desertBlue: UIColor {
		return UIColor(red: 17/255, green: 138/255, blue: 178/255, alpha: 1.0) // #118AB2 Blue
	}
}
