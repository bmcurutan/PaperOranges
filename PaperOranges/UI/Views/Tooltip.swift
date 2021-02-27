//
//  Tooltip.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 2/26/21.
//

import UIKit

class Tooltip: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        layer.cornerRadius = 12
        backgroundColor = .tooltipBackgroundColor
        clipsToBounds = true
        font = UIFont.systemFont(ofSize: 12)
        isScrollEnabled = false
        isSelectable = false
        textColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
