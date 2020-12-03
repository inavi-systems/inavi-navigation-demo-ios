//
//  SampleExtenstion.swift
//  naviSDKSample
//
//  Created by DAECHEOL KIM on 2020/10/05.
//  Copyright © 2020 DAECHEOL KIM. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    open class var INVBlue: UIColor { UIColor(red: 0, green: 0, blue: 1.0, alpha: 1.0) }
    open class var INVGray: UIColor { UIColor(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0) }
    open class var INVGrayText: UIColor { UIColor(red: 115/255.0, green: 115/255.0, blue: 115/255.0, alpha: 1.0) }
    open class var INVCellHighlighted: UIColor { UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0) }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
