//
//  RoundedCellView.swift
//  
//
//  Created by mac on 19/5/2022.
//

import UIKit

@IBDesignable
class RoundedCellView: UIView {
    
   //design
    override func layoutSubviews() {
        clipsToBounds = true
        layer.cornerRadius = 15
        backgroundColor = UIColor(red: 220 / 255, green: 250 / 255, blue: 255 / 255, alpha: 1)
    }
}
