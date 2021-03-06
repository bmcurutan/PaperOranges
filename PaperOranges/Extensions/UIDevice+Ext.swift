//
//  UIDevice+Ext.swift
//  PaperOranges
//
//  Created by Bianca Curutan on 3/6/21.
//

import AVFoundation
import UIKit

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
