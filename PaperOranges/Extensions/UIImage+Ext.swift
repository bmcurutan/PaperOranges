//
//  UIImage+Ext.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/13/21.
//

import UIKit

extension UIImage {
	static func withColor(_ color: UIColor) -> UIImage? {
		let rect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		guard let cgImage = image?.cgImage else { return nil }
		return UIImage(cgImage: cgImage)
	  }
}
