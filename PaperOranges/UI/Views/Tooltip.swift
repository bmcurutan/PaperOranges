//
//  Tooltip.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 2/26/21.
//

import UIKit

class Tooltip: UIView {
    var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .tooltipBackgroundColor
        view.clipsToBounds = true
        view.font = UIFont.systemFont(ofSize: 12)
        view.isScrollEnabled = false
        view.isSelectable = false
        view.textColor = .white
        view.textContainerInset = UIEdgeInsets(top: 6, left: 4, bottom: 6, right: 4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var line: UIView = {
        let view = UIView()
        view.backgroundColor = .tooltipBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(line)
        line.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: line.rightAnchor, constant: 8).isActive = true
        line.widthAnchor.constraint(equalToConstant: 2).isActive = true
        line.heightAnchor.constraint(equalToConstant: 6).isActive = true

        addSubview(textView)
        textView.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
