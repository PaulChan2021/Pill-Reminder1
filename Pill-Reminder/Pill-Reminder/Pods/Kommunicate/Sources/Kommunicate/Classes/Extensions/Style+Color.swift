//
//  Style+Color.swift
//  ApplozicSwift
//
//  Created by Mukesh on 17/02/20.
//

import Foundation
import UIKit

extension Style {
    enum Color {
        enum Background: Int {
            case primary = 0x5553B7
            case mediumGrey = 0xF0F0F0
            case lightGreyOne = 0xF9F9F9
            case darkYellow = 0xD6A64D
        }

        enum Text: Int {
            case warmGrey = 0x8B8888
            case warmBlue = 0x5451E2
            case brownishGreyTwo = 0x676767
            case mediumDarkBlack = 0x373535
            case mediumDarkBlackTwo = 0x363636
        }
    }
}

extension UIColor {
    static func background(_ color: Style.Color.Background) -> UIColor {
        return .init(netHex: color.rawValue)
    }

    static func text(_ color: Style.Color.Text) -> UIColor {
        return .init(netHex: color.rawValue)
    }
}
