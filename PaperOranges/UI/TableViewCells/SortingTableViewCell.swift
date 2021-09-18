//
//  SortingTableViewCell.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 3/6/21.
//

import UIKit

class SortingTableViewCell: UITableViewCell {
    func shakeButtons(_ buttons: [ImageLabelButton?]) {
        buttons.forEach { button in
            if let button = button {
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.2
                animation.fromValue = NSValue(cgPoint: CGPoint(x: button.center.x - 4, y: button.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: button.center.x + 4, y: button.center.y))
                button.layer.add(animation, forKey: "position")
            }
        }
        UIDevice.vibrate()
    }

    func resetButtonsUI(_ buttons: [ImageLabelButton?]) {
        buttons.forEach { button in
            UIView.animate(withDuration: 0.3, animations: {
                button?.isSelected = false
            })
        }
    }
}
