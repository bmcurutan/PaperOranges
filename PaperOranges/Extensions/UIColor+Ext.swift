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

    static var tooltipBackgroundColor: UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.8) // Black with alpha
    }

	static var borderColor: UIColor {
        return UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0) // DCDCDC Light gray
	}

	static var accentColor: UIColor {
		return UIColor(red: 242/255, green: 126/255, blue: 76/255, alpha: 1.0) // #F27E4C Dark orange
	}

	static var secondaryAccentColor: UIColor {
		return UIColor(red: 254/255, green: 164/255, blue: 96/255, alpha: 1.0) // #FEA460 Light orange
	}

	static var primaryTextColor: UIColor {
		return UIColor(red: 21/255, green: 26/255, blue: 97/255, alpha: 1.0) // #151A61 Dark blue
	}

	static var secondaryTextColor: UIColor {
		return UIColor.lightGray
	}

	static var primaryButtonColor: UIColor {
		return desertTeal
	}

	static var highlightColor: UIColor {
		return desertYellow
	}

	static var desertBlue: UIColor {
		return UIColor(red: 17/255, green: 138/255, blue: 178/255, alpha: 1.0) // #118AB2 Blue
	}

    static var desertRed: UIColor {
        return UIColor(red: 188/255, green: 33/255, blue: 45/255, alpha: 1.0) // #BC212D Red
    }

    static var desertYellow: UIColor {
        return UIColor(red: 233/255, green: 196/255, blue: 106/255, alpha: 1.0) // #E9C46A Yellow
    }

    static var desertTeal: UIColor {
        return UIColor(red: 42/255, green: 157/255, blue: 143/255, alpha: 1.0) // #2A9D8F Teal
    }
}
