//
//  UITableViewExt.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 1/12/21.
//

import UIKit

extension UITableView {
	func reloadDataAfterDelay(_ delay: TimeInterval = 0.3) -> Void {
		perform(#selector(reloadData), with: nil, afterDelay: delay)
	}
}
